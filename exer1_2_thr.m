%%

clc;
close all;
clear;

scr = get(0,'ScreenSize');

lenna = imread('lenna.jpg');
lenna = im2gray(lenna);
lenna = uint8(lenna);
[M,N] = size(lenna);
sub = 32;

lenna_pad = padarray(lenna,mod([sub,sub]-mod([M,N],...
    [sub,sub]),[sub,sub]),'post');

[M,N] = size(lenna_pad);

part_M = floor(M/sub);
part_N = floor(N/sub);

parts = mat2cell(lenna_pad,repmat(sub,1,part_M),repmat(sub,1,part_N));

figure(1);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Partiotioned Images of lenna.jpg');
rows = size(parts,1);
cols = size(parts,2);
for i = 1:rows
    for j=1:cols
        subplot(rows,cols,(i-1)*cols+j)
        imshow(parts{i,j})
    end
end

parts_dct = cellfun(@(x) dct2(x),parts,'UniformOutput',false);

%% threshold method
figure(3);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Threshold Method Application with percentages = [5% 50%]')

percent = linspace(5,50,10);
parts_dct_quant = cell(size(parts_dct));
parts_dct_deq = cell(size(parts_dct));
mse = zeros(size(percent));
steps = zeros(size(parts_dct));

for i = 1:numel(percent)
    p = percent(i);
    for j = 1:numel(parts_dct)

        part = parts_dct{j};
        
        %thresholding
        mask = thr_mask(p,part);
        part = part.*mask;

        %quantize
        minval = min(part(:));
        maxval = max(part(:));
        steps(j) = (maxval-minval) / (4096-1);
        part = round(part/steps(j))*steps(j);
        parts_dct_quant{j} = part;
    end 
    
    for j = 1:numel(parts_dct_quant)
        quant_coeffs = parts_dct_quant{j};
        %dequantize
        deq_coeffs = quant_coeffs/steps(j);
        parts_dct_deq{j} = deq_coeffs;
    end
    
    decomp_parts = cellfun(@(x) idct2(x),parts_dct_deq,...
        'UniformOutput',false);
    decomp_lenna = cell2mat(decomp_parts);
    decomp_lenna_int = uint8(decomp_lenna);
    subplot(2,numel(percent)/2,i);
    imshow(decomp_lenna_int,[]);
    mse(i) = immse(uint8(lenna_pad),decomp_lenna_int);
    title(num2str(p)+"% of coefficients kept");
end

