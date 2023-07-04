function [deshaowimage] = deshadow(shadowimage, line1, line2)
R = shadowimage(:,:,1);
[X,Y] = size(R);
[offset, ~]=Offset(shadowimage,line2);
% Offset correction
imgg = zeros([X,Y,3]);
if size(offset,1)==X
     imgg= shadowimage - offset;
else
    for i=1:3
    imgg(:,:,i) = shadowimage(:,:,i) - offset(i);
    end
end

Z = load('shadow_data.mat');
shadowdata = Z.shadowdata;
mdl = KDTreeSearcher(shadowdata);
% color-line clustering
imgg1=reshape(shadowimage,X*Y,3);
geometric = sqrt( shadowimage(:,:,1).^2 + shadowimage(:,:,2).^2 +shadowimage(:,:,3).^2 );
geometric1 = reshape(geometric,[X*Y,1]);
unit = imgg1./geometric1;   %Normalization of processing data


% Correction image clustering
N = 1000;
imgg2=reshape(imgg,[X*Y,3]);
geometric = sqrt( imgg(:,:,1).^2 + imgg(:,:,2).^2 +imgg(:,:,3).^2 );
geometric1 = reshape(geometric,[X*Y,1]);
unit = imgg2./geometric1;
neighbor = knnsearch(mdl, unit);      %Find the nearest neighbor
add_neighbor = accumarray(neighbor,geometric(:),[N,1],@max);
radius_max = reshape( add_neighbor(neighbor), X, Y);
ra = (geometric)./(radius_max+eps);


% Shadow detection 
detectionmap = line1>0.9; 
shadowmap = line1<0.6 & line1>0.4;
log_imgg1=log(imgg1);
trdata=[log_imgg1(detectionmap(:),:);log_imgg1(shadowmap(:),:)];
trlabel=zeros([size(trdata,1),1]);
trlabel(1:sum(detectionmap(:)))=1;
model = ClassificationKNN.fit(trdata,trlabel,'NumNeighbors',3);
shadowit = predict(model,log_imgg1);
shadowit=reshape(shadowit,X,Y);
gsH = fspecial('gaussian',14,round(7));
shadowit = imfilter(shadowit,gsH,'replicate');
rmask=zeros([X,Y]);
rmask(shadowit<0.5)=1;
rmask=bwareaopen(~bwareaopen(~rmask,100),200);
bd=shadowboundary(rmask,ceil(max([X Y])/512));
bl=endpoint(ra,rmask,bd,8);
bdv=bl.e-bl.s;
mm = arrayfun(@(x) norm(bdv(:,x)), 1:length(bl.s));
bd.w = zeros(1,length(bd.t));
bd.w(~bd.t) = mm;
pmask=penumbra(bd,[X,Y]);
umask = rmask & ~pmask;
lmask=~(umask|pmask);

% Umbra shadow removal
umask1=reshape([umask umask umask],[X,Y,3]);
lmask1=reshape([lmask lmask lmask],[X,Y,3]);
umask2=neighbor;
lmask2=neighbor;
umask2(umask(:)==0)=N+1;
lmask2(lmask(:)==0)=N+1;
lm=zeros([N+1 3]);
um=zeros([N+1 3]);
lmean=zeros([N+1 3]);
umean=zeros([N+1 3]);

for i=1:3
      lm(:,i)=accumarray(lmask2,imgg1(:,i),[N+1 1],@std);
      um(:,i)=accumarray(umask2,imgg1(:,i),[N+1 1],@std);
      lmean(:,i)=accumarray(lmask2,imgg1(:,i),[N+1 1],@mean);
      umean(:,i)=accumarray(umask2,imgg1(:,i),[N+1 1],@mean);
end

% Use the average statistis to relight the umbra region that has no reference lit pixels
lingtx=sum(umean,2)>0;
lighty=lingtx & (sum(lmean,2)==0);
if find(lighty)
    lights=lingtx & ~lighty;
    meanscale=mean(lmean(lights,:)./umean(lights,:),1);
    stdscale=mean(lm(lights,:)./um(lights,:),1);
    for index=1:3
        lmean(lighty,index)=umean(lighty,index)* meanscale(index);
        lm(lighty,index)=um(lighty,index)* stdscale(index);
    end
end
% Relight umbra region.
std_scale=lm./max((um+eps),0.01);
udeimg=(imgg1-umean(umask2,:)).*std_scale(umask2,:)+lmean(umask2,:);

% Penumbra shadow removal
pmask1=reshape([pmask pmask pmask],[X,Y,3]);
pmask2=neighbor;
pmask2(pmask(:)==0)=N+1;
umean1=accumarray(umask2,ra(:),[N+1 1],@mean);
lmean2=accumarray(lmask2,ra(:),[N+1 1],@mean);
uscale=imgg1./udeimg;
uscale_mean=zeros([N+1 3]);
pscale=zeros([X*Y,3]);
for i=1:3
      uscale_mean(:,i)=accumarray(umask2,uscale(:,i),[N+1 1],@mean);
      pscale(:,i)=uscale_mean(pmask2,i)+(1-uscale_mean(pmask2,i)).*(ra(:)-umean1(pmask2))./(lmean2(pmask2)-umean1(pmask2));
end
pscale=reshape(pscale,X,Y,3);
uscale=reshape(uscale,X,Y,3);
pscale(pmask1==0)=0;
uscale(umask1==0)=0;
scale=pscale+uscale;
scale(lmask1==1)=1;
deshaowimage=shadowimage./scale;


figure,
subplot(2,2,1);
imshow(shadowimage);
title('Input');

subplot(2,2,2);
imshow(imgg);
title('offset result'); 

%subplot(2,3,3);
%imshow(pscale);
%title('mask1');

subplot(2,2,3);
imshow(lmask*0.3+pmask*0.7+umask);
title('mask2');

%subplot(2,3,5);
%imshow(shadowit);
%title('mask3');

subplot(2,2,4);
imshow(deshaowimage);
title('Shadow free image'); 


end