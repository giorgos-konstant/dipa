clc;
clear;
close all;

scr = get(0,'ScreenSize');

factory = im2double(imread('factory.jpg'));
sm_fac = im2double(imgaussfilt(factory,1.75));
sm_fac_n = im2double(imnoise(sm_fac,'gaussian',0,0.01174));

noise = sm_fac_n - sm_fac;
fac_mean = mean(factory(:));
noise_std = std(noise(:));

SNR = 20*log10(fac_mean/noise_std)

%% WGN
figure(1);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

subplot(1,2,1);
imshow(factory);
title("Original Image factory.jpg");
subplot(1,2,2);
imshow(sm_fac_n);
title(sprintf('factory.jpg + WGN (SNR = %d)',round(SNR)));

%% Impulse And Amplitude Response
In = fft2(factory);
Out = fft2(sm_fac_n);
H = Out./In;
h = ifftshift(ifft2(H));

figure(2);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
subplot(2,1,1);
imshow(im2gray(abs(h./max(h))));
title('Impulse Response of Degradation Filter');
axis on;
subplot(2,1,2);
imshow(im2gray(abs(fftshift(H))));
title('Amplitude Response of Degradation Filter');
axis on;

%% de-noising and inverse filtering

psf = fspecial('gaussian',[5 5],0.5);
denoised = im2gray(deconvwnr(sm_fac_n,psf,0.01));
deconv = im2gray(deconvwnr(sm_fac_n,psf));
deconv_thr = im2gray(deconvwnr(sm_fac_n,psf,0.1));

figure(3);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

subplot(2,2,1);
imshow(sm_fac_n);
title('factory.jpg + WGN');
subplot(2,2,2);
imshow(denoised);
title('denoised image');
subplot(2,2,3);
imshow(deconv);
title('Reconstructed image without Threshold');
subplot(2,2,4);
imshow(deconv_thr);
title('Reconstructed Image with Threshold');


%% wiener deconvolution

NSR = 10^(-SNR/20)
fac_deconv = deconvwnr(sm_fac_n,psf,NSR);

% estimated NSR case 

figure(4);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
imshow(sm_fac_n);
noiseRect = round(getrect);
noiseRegion = sm_fac_n(noiseRect(2):noiseRect(2)+noiseRect(4)-1, noiseRect(1):noiseRect(1)+noiseRect(3)-1);

signalRect = round(getrect);
signalRegion = sm_fac_n(signalRect(2):signalRect(2)+signalRect(4)-1, signalRect(1):signalRect(1)+signalRect(3)-1);

noisePSD = abs(fft2(noiseRegion)).^2 / numel(noiseRegion);
signalPSD = abs(fft2(signalRegion)).^2 / numel(signalRegion);
estNSR = mean(noisePSD(:))/mean(signalPSD(:));

close;

fac_deconv_est = deconvwnr(sm_fac_n,psf,estNSR);

figure(4);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle('Reconstruction with Wiener Deconvolution');
subplot(1,3,1);
imshow(sm_fac_n);
title("factory.jpg + WGN")
subplot(1,3,2);
imshow(fac_deconv);
title("Calculated NSR");
subplot(1,3,3);
imshow(fac_deconv_est);
title("Estimated NSR");
