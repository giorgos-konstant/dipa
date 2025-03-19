clc;
close all;
clear;

scr = get(0,'ScreenSize');

image = imread('aerial.tiff');
amp = abs(fft2(image));

%% linear and logarithmic representation of image amplitude
figure(1);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

subplot(1,2,1);
imagesc(amp);
axis square;
colorbar;
title("Linear");
clim([0 9000]);
subplot(1,2,2);
imagesc(log10(1+amp));
axis square;
colorbar;
title('Logarithmic');

%% lowpass filtered image
figure(2);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

lowpass = zeros(size(amp));
lowpass(1:30,1:30) = 1;
amp_lp = amp.*lowpass;
img_lp = ifft2(amp_lp);

subplot(1,3,1);
imshow(image);
title('Original Image');
subplot(1,3,2);
imshow(abs(img_lp),[]);
title("LP-filtered image");
subplot(1,3,3);
imagesc(amp_lp);
title('2D-FFT Amplitude of Filtered Image');
clim([0 9000]);
axis square;
colorbar;

%% highpass filtered image

figure(3);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

highpass = ones(size(amp));
highpass(1:100,1:100) = 0;
amp_hp = amp.*highpass;
img_hp = ifft2(amp_hp);

subplot(1,3,1);
imshow(image);
title('Original Image');
subplot(1,3,2);
imshow(abs(img_hp),[]);
title("HP-filtered image");
subplot(1,3,3);
imagesc(amp_hp);
title('2D-FFT Amplitude of Filtered Image');
clim([0 9000]);
axis square;
colorbar;

%% impulse response and amplitude response of filters and filtered images

figure(4);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
subplot(2,2,1);
plot(abs(ifft2(lowpass(1:256))));
title("Impulse Response of Lowpass Filter");
subplot(2,2,3);
plot(abs(ifft2(highpass(1:256))));
title("Impulse Response of Highpass Filter");
subplot(2,2,2);
imagesc(lowpass);
title("Amplitude Response of Lowpass Filter");
subplot(2,2,4);
imagesc(highpass);
title("Amplitude Response of Highpass Filter");

