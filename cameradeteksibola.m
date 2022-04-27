clc; clear; close all;
a = imaqhwinfo;
[camera_name, format] = getCameraInfo(a);
% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
vid = videoinput(camera_name, 1, format);
% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;
start(vid)
while(vid.FramesAcquired<=200)
    % ambil gambar
    data = getsnapshot(vid);
    
    I = data;
    Ihsv=rgb2hsv(data);
    bw=createMask(Ihsv);
    bw = bwareaopen(bw,50);
    se = strel('disk',10,8);
    bw= imdilate(bw,se);
%     imshow(bw)
    imshow(I)
    
    [b,L] = bwboundaries(bw,'noholes');
    stats = regionprops(L,'All');

 hold on
    for object = 1:length(stats)
        %Keliling bola
        perimeter = stats.Perimeter;
        %Luas bola
        area = stats.Area;
        %mencari metrik bola
        metric = 4*pi*area/perimeter^2;
        %posisi bola
        bb = stats.BoundingBox;
        bc = stats.Centroid;
        %create bounding box
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2, 'Curvature',[1 1])
        %Pusat bola
        plot(bc(1),bc(2), '-m+')
        %koordinat pusat kamera
        plot(494,291,'-m+')
        bx=round(bc(1))-494;
        by=-round(bc(2))+291;
        %bola dideteksi pada metriks>0,2
        if metric >0.2 
            a=text(bc(1)+15,bc(2), strcat('X: ', num2str(bx), '    Y: ', num2str(by)));
            set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        end
    end
    hold off
end
%stop video
stop(vid);
flushdata(vid);
% Clear all variables
clear all
sprintf('%s','Selesai :) ')
