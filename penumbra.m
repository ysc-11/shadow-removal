function pmask = penumbra(bd,imhw)
mask = zeros(imhw,'uint8');  %Convert to uint
for k = 1:max(bd.m)
    h = find(bd.m==k); 
    ms = bd.t(h)~=-1 & bd.t(h)~=-4 ; 
    [m,n] = bwlabel(ms); % label consecutive segments
    for i = 1:n
        hm = h(m==i); % label the index 
        hm1 = bd.w(hm); % calculate the width
        hm2 = find(hm1>0); qsw = find(hm1==0);
        if numel(hm2)>2 
            hm1(qsw) = max(interp1(hm2,hm1(hm2),qsw,'nearest','extrap'),2);
            hm3 = bsxfun(@times,bd.n(:,hm),hm1/2);   % get penumbra boundary points
            hm4 = bd.p(:,hm)-hm3;
            hm5 = bd.p(:,hm)+hm3;
            km = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','White','Opacity',1);% plot the mask image
            image_on = zeros(size(hm3,2)-1,8,'int32');

            for i = 1:size(image_on,1)
                gm = [hm4(:,[i,i+1]),hm5(:,[i,i+1])];
                gg = mean(gm,2);
                hh = atan2(gm(2,:)-gg(2), gm(1,:)-gg(1)); % calculate angle
                [~,order] = sort(hh); % sort angles
                gm = gm(:,order); % reorder
                image_on(i,:) = int32(reshape(gm,[],1)); % assign
            end
            mask = step(km,mask,image_on);
        end
    end
end
pmask = logical(mask);
end