function [offset, line2] = Offset(img, line2)
    if isempty(line2)
        figure;imshow(img);
        [~,x,y] = handle(gca,3);
        close
        offseting=zeros([size(img,1),size(img,2)]);
       for index=1:length(x)
           offseting(round(y(index)),round(x(index)))=1;
       end
        offseting=logical(imdilate(offseting,strel('sphere',3)));
        line2 = offseting;
    else
        offseting = line2 > 0.4;
    end
    r = img(:,:,1); g = img(:,:,2); b = img(:,:,3);
    selectData = cat(2, r(offseting), g(offseting), b(offseting));
    [~,V]=pca(selectData);
    v=V';
    p=mean(selectData);
    ori=p-v*dot(p,v)/norm(v);
    for channel=1:3
        img(:,:,channel)=img(:,:,channel)-ori(channel);
    end
    imgnorm=sqrt(img(:,:,1).^2+img(:,:,2).^2+img(:,:,3).^2);
    offset=zeros(size(img));
    v=v./norm(v);
    for channel=1:3
        offset(:,:,channel)=img(:,:,channel).*ori(channel)./(v(channel).*imgnorm+eps);
    end
    
    function [d v] = pca(X)
        m = mean(X,1)';  %Zero the center of the matrix column to get matrix X
        for c=1:3
            X(:,c) = X(:,c)-m(c);
        end
        X = X'*X ;  %Calculate X'*X
        X = X/size(X,1);
        [V, lambda] = eig(X);     %Solving eigenvalues and eigenvectors.
        d = diag(lambda);
        v = V(:,3);
    end
end