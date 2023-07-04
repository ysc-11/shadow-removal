function bd = shadowboundary(msk,fsp)

imhw = size(msk); % calculate the image size
[bdp,~,N] = bwboundaries(msk); % get boundaries of choosen areas
bdl = cellfun(@(x) size(x,1),bdp); % calculate the length
pl = find(bdl>3); % remove too short boundaries
bdpf = bdp(pl); 
bdnf = cell(size(bdpf)); 
bdtf = cell(size(bdpf)); 
bdmf = cell(size(bdpf)); 

for i = 1:length(pl)
    cbd = flipud(bdpf{i}'); 
    ptlen = size(cbd,2); % current bondary
    % compute boundary normal
    t = cumsum([0,sqrt((sum(diff(cbd,1,2).^2)))]); % calculate each boundary length
    cv = csaps(t,cbd,1/(1 + fsp^3/0.6)); % find the relationship between neighbors
    v = fntlr(cv,2,t); 
    R = [0,1;-1,0]; 

    if pl(i)>N 
        R = -R; 
    end 

    cbdn = R*v(3:4,:); 
    cbdn = bsxfun(@rdivide,cbdn,sqrt(sum(cbdn.^2)));
    
    bm = cbd(1,:)==1|cbd(1,:)==imhw(2)|cbd(2,:)==1|cbd(2,:)==imhw(1); % exclude boudnary at image boarder
    cdt = zeros(ptlen,1); cdt(bm) = -1; % mark points at image boarder
    % curature sampling
    npt = fnval(cv,t); ksp = 20;
    x = abs(slope(npt'));
    if abs(slope(npt')) < 0
        x = 0;
       else if abs(slope(npt')) > ksp
            x = 20;
        end
    end
    krv = cumsum(x);
    krv = krv/ksp;
    kxv = [1;find(diff(fix(krv),1)>0);ptlen]; 
    krvx = union(transpose(1:fsp:ptlen),kxv); 
    bdpf{i} = transpose(cbd(:,krvx)); bdnf{i} = transpose(cbdn(:,krvx));
    bdtf{i} = cdt(krvx); bdmf{i} = ones(numel(krvx),1)*i;
end
bd.p = transpose(cell2mat(bdpf)); bd.n = transpose(cell2mat(bdnf));
bd.t = cell2mat(bdtf); bd.m = cell2mat(bdmf);
end