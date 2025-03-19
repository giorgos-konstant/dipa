clc;
clear;
close all;

scr = get(0,'ScreenSize');
images = {'dark_road_1.jpg','dark_road_2.jpg','dark_road_3.jpg'};

%% Histograms
figure(1);
set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);

for i = 1:numel(images)
    dr{i} = im2gray(imread(images{i}));
    subplot(2,3,i);
    imshow(dr{i});
    title(sprintf('dark road %d ',i));
    subplot(2,3,i+3);
    imhist(dr{i});
    ylim auto
    xlim([-10 150]);
end

%% Global EQ
for i = 1:numel(dr)
    
    figure(i+1);
    set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
    sgtitle('Global Histogram EQ');
    gl_eq{i} = histeq(dr{i});
    subplot(2,2,1);
    imshow(dr{i});
    title(sprintf('dark road %d',i));
    subplot(2,2,2);
    imshow(gl_eq{i});
    title((sprintf('dark road %d after Gloal EQ',i)));
    subplot(2,2,3);
    imhist(dr{i});
    subplot(2,2,4);
    imhist(gl_eq{i});
    ylim auto

end

%% Local EQ
w = 60;
for i = 1:numel(dr)

    figure(i+4);
    set(gcf,'Position',[0.12*scr(3) 0.12*scr(4) 0.75*scr(3) 0.75*scr(4)]);
    sgtitle('Local Histogram EQ')
    loc_eq{i} = adapthisteq(dr{i},'NumTiles',[w w]);
    subplot(2,2,1);
    imshow(dr{i});
    title(sprintf('dark road %d',i));
    subplot(2,2,2);
    imshow(loc_eq{i});
    title(sprintf('dark road %d after Local EQ',i));
    subplot(2,2,3);
    imhist(dr{i});
    subplot(2,2,4);
    imhist(loc_eq{i});
    ylim auto

end    