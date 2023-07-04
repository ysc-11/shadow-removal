%Run this file to get the shadow removal of image 5.jpg.

clear all;
shadowimage=im2double(imread('5.jpg')); % read 5.jpg

m = shadowimage;
R = m(:,:,1);
[width,height]=size(R); % calculate the size of image
rm0 = zeros(width,height);
rm = rm0;
k1 = 0.502; % set color perameters
k2 = 1;

for i = 1:8  % choose the needed region line
    a = 10+i;
    b = 350;
    c = 50+i;
    d = 440;
    rm=huaxian(a,b,c,d,k1,rm);
    a = 150+i;
    b = 350;
    c = 190+i;
    d = 440;
    rm=huaxian(a,b,c,d,k2,rm);
end

line2 = rm0;

for i = 1:8
    a = 30+i;
    b = 380;
    c = 150+i;
    d = 330;
    line2=huaxian(a,b,c,d,k2,line2);
end

line1=im2double(rm);
line2=im2double(line2);
[deshadowimage]=deshadow(shadowimage,line1,line2); % get the results