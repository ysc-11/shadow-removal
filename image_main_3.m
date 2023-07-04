%Run this file to get the shadow removal of image 3.jpg.

clear all;
shadowimage=im2double(imread('3.jpg')); % read 3.jpg

m = shadowimage;
R = m(:,:,1);
[width,height]=size(R); % calculate the size of image
rm0 = zeros(width,height);
rm = rm0;
k1 = 0.502; % set color perameters
k2 = 1;

for i = 1:8  % choose the needed region line
    a = 138+i;
    b = 112;
    c = 319+i;
    d = 397;
    rm=huaxian(a,b,c,d,k1,rm);
    a = 402+i;
    b = 88;
    c = 562+i;
    d = 378;
    rm=huaxian(a,b,c,d,k2,rm);
end

line2 = rm0;

for i = 1:8
    a = 330+i;
    b = 120;
    c = 220+i;
    d = 180;
    line2=huaxian(a,b,c,d,k2,line2);
end

line1=im2double(rm);
line2=im2double(line2);
[deshadowimage]=deshadow(shadowimage,line1,line2); % get the results
