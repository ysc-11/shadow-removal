%Run this file to get the shadow removal of image 1.jpg.

clear all;
shadowimage=im2double(imread('1.jpg')); % read 1.jpg

m = shadowimage;
R = m(:,:,1); 
[width,height]=size(R); % calculate the size of image
rm0 = zeros(width,height);
rm = rm0;
k1 = 0.502; % set color perameters
k2 = 1;

for i = 1:8  % choose the needed region line
    a = 270+i;
    b = 500;
    c = 300+i;
    d = 600;
    rm=huaxian(a,b,c,d,k1,rm);
    a = 270+i;
    b = 200;
    c = 300+i;
    d = 300;
    rm=huaxian(a,b,c,d,k2,rm);
end

line2 = rm0;

for i = 1:8
    a = 350+i;
    b = 450;
    c = 300+i;
    d = 500;
    line2=huaxian(a,b,c,d,k2,line2);
end

line1=im2double(rm);
line2=im2double(line2);
[deshadowimage]=deshadow(shadowimage,line1,line2); % get the results

