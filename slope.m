function s = slope(xr)
if(nargin<2)
    linee1=[(1:(size(xr,1)-1))' (2:size(xr,1))'];
end

left=zeros(size(xr,1),1); % find neighbors of each points
right=zeros(size(xr,1),1);
left(linee1(:,1))=linee1(:,2); 
right(linee1(:,2))=linee1(:,1);

leftif=left==0;
rightif=right==0;
left1=left;
right1=right;
left1(leftif)=find(leftif); 
right1(rightif)=find(rightif);
left(leftif)=right1(right1(leftif)); 
right(rightif)=left1(left1(rightif));

Ta=-sqrt(sum((xr-xr(left,:)).^2,2));
Tb=sqrt(sum((xr-xr(right,:)).^2,2)); 
Ta(leftif)=-Ta(leftif);  % use two another neighor when lack the left or right one.
Tb(rightif)=-Tb(rightif);

x = [xr(left,1) xr(:,1) xr(right,1)];
y = [xr(left,2) xr(:,2) xr(right,2)];
Z = [ones(size(Tb)) -Ta Ta.^2 ones(size(Tb)) zeros(size(Tb)) zeros(size(Tb)) ones(size(Tb)) -Tb Tb.^2];
s = Z(:,2);
end