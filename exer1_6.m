clc;
clear;
close all;

scr = get(0,'ScreenSize');

clock = im2gray(imread('clock.jpg'));

%% Sobel Mask
figure(1);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

sobelX = edge(clock,'sobel','horizontal');
sobelY = edge(clock,'sobel','vertical');
sobel = edge(clock,'sobel');

subplot(1,4,1);
imshow(clock);
title("Original Image clock.jpg");
subplot(1,4,2);
imshow(sobelX);
title("Sobel Horizontal Edge Detection")
subplot(1,4,3);
imshow(sobelY);
title("Sobel Vertical Edge Detection")
subplot(1,4,4);
imshow(sobel);
title("Whole Image Edge Decection")

%% Thresholding

numsobel = clock;
thr = 0.4;
clock_otsu = imbinarize(numsobel,'global');
clock_manual = imbinarize(numsobel,thr);
clock_adapt = imbinarize(numsobel,'adaptive');
figure(2);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
sgtitle("Thresholding Methods");

subplot(2,3,1);
imshow(clock_otsu);
title("Otsu Method Thresholding");
subplot(2,3,2);
imshow(clock_manual);
title(sprintf("Manually selected Threshold Value = %.2f",thr));
subplot(2,3,3);
imshow(clock_adapt);
title("Adaptive Thresholding");
subplot(2,3,4);
imshow(edge(clock_otsu,'sobel'));
subplot(2,3,5);
imshow(edge(clock_manual,'sobel'));
subplot(2,3,6);
imshow(edge(clock_adapt,'sobel'));

%% Hough transform

edges = edge(clock,'canny');
[H,T,R] = hough(edges,'RhoResolution',0.5,'Theta',-90:0.5:89);

figure(2);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

imshow(imadjust(rescale(H)),[],...
    'XData',T,'YData',R,'InitialMagnification','fit');
axis on;
axis normal;
hold on;
colormap(gca,'bone');

%identify peaks

P = houghpeaks(H,5,'Threshold',ceil(0.3*max(H(:))));

x = T(P(:,2));
y = R(P(:,1));
scatter(x,y,'filled','green');

lines = houghlines(edges,T,R,P,'FillGap',5,'MinLength',7);


figure(3);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
imshow(clock);
hold on;

for k=1:numel(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'color','blue');

end

hold off;




