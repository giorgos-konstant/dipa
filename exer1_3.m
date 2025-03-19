clc;
clear;
close all;
scr = get(0,'ScreenSize');



fl = im2double(imread("flower.png"));

%% AWGN

fl_noise = im2double(imnoise(fl,"gaussian",0,0.006));
noise = fl_noise - fl;

fl_mean = mean(fl(:));
noise_mean = mean(noise(:));
noise_std = std(noise(:));

SNR = 20*log10(fl_mean/noise_std)

figure(1);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
subplot(1,2,1);
imshow(fl);
title("original image: flower.png");
subplot(1,2,2);
imshow(fl_noise);
title("flower.png with AWGN (SNR= "+num2str(SNR)+')');

%% Moving Average Filter
figure(2);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Moving Average Filter applied to flower.png + AWGN');
for i = 3:11
    
    mv_avg = ones(i)/(i^2);
    ma_filt = imfilter(fl_noise,mv_avg);
    subplot(3,3,i-2);
    imshow(ma_filt);
    title(sprintf('Filter Length: %d x %d',i,i));
end

%% Median filter

figure(3);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Median Filter applied to flower.png + AWGN');

for i = 3:11
    med_filt = medfilt2(fl_noise,[i i]);
    subplot(3,3,i-2);
    imshow(med_filt);
    title(sprintf('Filter Length: %d x %d',i,i));
end


%% impact noise

clear;
scr = get(0,'ScreenSize');
fl = im2double(imread("flower.png"));
num_pixels = numel(fl);
num_noise_pixels = round(25/100 * num_pixels);
noise_ind = randperm(num_pixels,num_noise_pixels);
fl_noise = fl;
fl_noise(noise_ind) = randi([0,255],size(noise_ind));

noise = fl_noise - fl;

fl_mean = mean(fl(:));
noise_mean = mean(noise(:));
noise_std = std(noise(:));

SNR = 20*log10(fl_mean/noise_std)

figure(4);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
subplot(1,2,1);
imshow(fl);
title("original image: flower.png");
subplot(1,2,2);
imshow(fl_noise);
title('Flower.png + 25% Impact Noise')


%% MA filter
figure(5);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Moving Average Filter applied to flower.png + 25% ImpN');

for i = 3:11
    mv_avg = ones(i)/(i^2);
    ma_filt = imfilter(fl_noise,mv_avg);
    subplot(3,3,i-2);
    imshow(ma_filt);
    title(sprintf('Filter Length: %d x %d',i,i));
end

%% Median Filter
figure(6);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Median Filter applied to flower.png + 25% ImpN');

for i = 3:11
    med_filt = medfilt2(fl_noise,[i i]);
    subplot(3,3,i-2);
    imshow(med_filt);
    title(sprintf('Filter Length: %d x %d',i,i));
end

