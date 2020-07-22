function [M] =sideView(Scan,lengthOFBScan,numberOfBScans,winkel)
[row,col] = size(Scan);
l = lengthOFBScan;
if(l==0)
l = floor(col/numberOfBScans);
end

if winkel<0 || winkel>360
    winkel=1;
end
if winkel>180
    winkel=winkel-180;
end
winkel = floor((winkel*l)/360);

M=zeros(1,1);
for x=1:numberOfBScans
    for c=1:row
        M(c+row,  x) =(Scan(c,(x-1)*l+ winkel)+Scan(c,(x-1)*l+ winkel+1)+Scan(c,(x-1)*l+ winkel+2)+Scan(c,(x-1)*l+ winkel-1)+Scan(c,(x-1)*l+ winkel-2))/5;        
        M(row-c+1,x) =(Scan(c,(x- 1)*l+ winkel+floor(l/2))+Scan(c,(x- 1)*l+ winkel+floor(l/2)+1)+Scan(c,(x- 1)*l+ winkel+floor(l/2)+2)+Scan(c,(x- 1)*l+ winkel+floor(l/2)-1)+Scan(c,(x- 1)*l+ winkel+floor(l/2)-2))/5;
    
    end
end

    %M = imsharpen(M);
    M = ordfilt2(M,14,ones(20,1));
    M = ordfilt2(M,8,ones(4,3));
    %medfilt2(M,[3,3])
    M=mat2gray(M,[200,250]);
    
    % subplot(2,1,1),imagesc(Scan);
    %for c= 1:numberOfBScans
    %    hold on;
    %    rectangle('Position',[(c-1)*l+winkel,    100,100,10],'Curvature',[1,1],'EdgeColor','b');
    %    hold on;
    %    rectangle('Position',[(c-1)*l+winkel+l/2,100,100,10],'Curvature',[1,1],'EdgeColor','g');
    %    hold on;
    %    rectangle('Position',[(c-1)*l,100,100,10],'Curvature',[1,1],'EdgeColor','r');
    %end
    % subplot(2,1,2),imagesc(M);
end
