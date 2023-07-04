function bl = endpoint(img,smsk,bd,gsc)
bdp = bd.p(:,~bd.t);
bdn = bd.n(:,~bd.t);

xlabel = size(bdp,2); % calculate the size
imagesize = size(img); 
bl.s = zeros(2,xlabel); bl.e = zeros(2,xlabel); 
[fx,fy] = gradient(img);

% get endpoints
for i = 1:xlabel
    % get current parameters
    point = bdp(:,i); % boundary point
    adv = bdn(:,i); 
    gdv = [fx(point(2),point(1));
    fy(point(2),point(1))];
    % get starting end
    t1 = round(point); 
    t2 = round(point); % current ends
    hdv = dot(gdv,adv)/norm(adv);
    hdv = hdv/gsc;

    h = 1; h1 = 0;
    while h
        tt1 = round(t1);
        tt2 = round(t2);
        if boundry(tt1,imagesize) || boundry(tt2,imagesize) || hdv<=0
            h = 0; 
        else
            if h1 && (~smsk(tt1(2),tt1(1)) || smsk(tt2(2),tt2(1)))
                h = 0; 
            end
            vec1 = [fx(tt1(2),tt1(1)),fy(tt1(2),tt1(1))];
            vec2 = [fx(tt2(2),tt2(1)),fy(tt2(2),tt2(1))];
            p1 = dot(vec1, adv)/norm(adv);
            p2 = dot(vec2, adv)/norm(adv);
            if max(p1,p2) < hdv  % gradient check
                h = 0;
            else
                t1 = t1 - adv; t2 = t2 + adv; 
                h1 = 1;
            end
        end
    end
    bl.s(:,i) = t1; bl.e(:,i) = t2;
end

    function bound = boundry(pt,sz)
    % test whether a point is at image boarder
    bound = pt(1)<1 || pt(2)<1 || pt(1) > sz(2) || pt(2) > sz(1);
end

end
