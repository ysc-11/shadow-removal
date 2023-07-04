%Run this file to get the shadow removal of image 4.jpg.

clear all;
shadowimage=im2double(imread('4.jpg')); % read 4.jpg

m = shadowimage;
R = m(:,:,1);
[width,height]=size(R); % calculate the size of image
rm0 = zeros(width,height);
rm = rm0;
k1 = 0.502; % set color perameters
k2 = 1;

for i = 1:8  % choose the needed region line
    a = 322+i;
    b = 10;
    c = 362+i;
    d = 300;
    rm=huaxian(a,b,c,d,k1,rm);
    a = 522+i;
    b = 10;
    c = 562+i;
    d = 300;
    rm=huaxian(a,b,c,d,k2,rm);
end

line2 = rm0;

for i = 1:8
    a = 350+i;
    b = 300;
    c = 550+i;
    d = 400;
    line2=huaxian(a,b,c,d,k2,line2);
end

line1=im2double(rm);
line2=im2double(line2);
[deshadowimage]=deshadow(shadowimage,line1,line2); % get the results