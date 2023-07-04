function img=huaxian(a,b,c,d,k,Ih)
img=Ih;
xk=(c-a);
yk=(d-b);
if xk==0
    if yk>0        
        for i=b:d
            img(i,a)=k;
        end
    end
    if yk<0   
        for i=d:b
            img(i,a)=k;
        end
    end
return
end
if yk==0
    if xk>0
        for i=a:c
            img(b,i)=k;
        end
    end
    if xk<0
        for i=c:a
            img(b,i)=k;
        end
    end
return
end
ykk=(yk/xk);
if a<c
    y=b;
    for i=a:c
        img(round(y),i)=k;
        y=(y+ykk);
    end
end
if a>c
    y=d;
    for i=c:a
        img(round(y),i)=k;
        y=(y+ykk);
    end
end
xkk=(xk/yk);
if b<d
    x=a;
    for i=b:d
        img(i,round(x))=k;
        x=(x+xkk);
    end
end
if b>d
    x=c;
    for i=d:b
        img(i,round(x))=k;
        x=(x+xkk);
    end
end