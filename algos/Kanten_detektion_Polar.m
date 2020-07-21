function value = Kanten_detektion_Polar(Bscan,tryT)
    M=FilterM(Bscan,0.6);
    [row,col] = size(M);
    value=zeros(col,1);
    for i = 1:col
        for j=tryT:row
            if M(j,i)>0
                value(i)=j;
               
                break;
            end
        end
    end
    for i=1:col
        if value(i)==0
            for j=i+1:col
                if value(j)>0
                    value(i)=value(j);
                    break;
                end
            end
        end
    end
    value = medfilt1(value,floor(row/2));
    value = floor((value+0.5));
    k=floor(col/12);
    while k>0
        if value(k)<=tryT || abs(value(k)-value(k+1))>25
            value(k)=value(k+1);
        end
        k=k-1;
    end
    k=floor(col/12);
    for i=col-k:col
        if value(i)<=tryT || abs(value(i)-value(i-1))>25
            value(i)=value(i-1);
        end
    end
    M = Bscan;
    M = medfilt2(M,[3,3]);
    M= imadjust(M);
    M = mat2gray(mat2gray(M),[0.49,1]);
    for i=1:col-1
        j= value(i);
        if j>tryT
        if M(j-1,i+1)>0 && M(j-1,i+1)==0
            value(i+1)=j-1;
        elseif M(j,i+1)>0 && M(j-1,i+1)==0
            value(i+1)=j;
        end
        end
    end
    for i=1:col-1
        j1= value(i)-3;
        j2= value(i)+3;
        if j1<1
            j1=1;
        end
        if j2>row
            j2=row;
        end
        find=0;
        find2=0;
        for j=j1:j2
            if M(j,i)>0 && find==0
                value(i)=j;
                find=1;
               
            end
            if M(j,i+1)>0 && find2==0
                value(i+1)=j;
                find2=1;
            end
            if find==1 && find2==1
                break;
            end
        end
    end
    value=medfilt1(value,row/4);
    value = floor((value+0.5));
    k=floor(col/12);
    while k>0
        if value(k)<=tryT || abs(value(k)-value(k+1))>25
            value(k)=value(k+1);
        end
        k=k-1;
    end
    k=floor(col/12);
    for i=col-k:col
        if value(i)<=tryT || abs(value(i)-value(i-1))>25
            value(i)=value(i-1);
        end
    end
end