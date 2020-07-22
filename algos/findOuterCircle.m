function [center,averageDist,lumen,minDist,maxDist] =findOuterCircle(BScan,edge)
    [~,col] = size(BScan);

    %Koordinaten umwandlung
    border=zeros(col,2);
    for c=1:col
        theta = (c * 2 * pi /col);
        rho = edge(c,1);
        [y1,y2]=pol2cart(theta,rho);
        border(c,1)=floor(y1)+550;
        border(c,2)=floor(y2)+550;

    end
    
    %mittelpunkt bestimmen
    centerY=0;
    centerX=0;
    for c=1:col
        centerY=centerY+border(c,1);
        centerX=centerX+border(c,2);
    end
    CenterX=floor(centerX/col);
    CenterY=floor(centerY/col);
    center=[CenterY,CenterX];
    
    %durchschnittlicher Abstand
    averageDist=0;
    maxDist=sqrt((center(1)-border(1,1))^2+(center(2)-border(1,2))^2);
    minDist=maxDist;
    for c=1:col
        dist=sqrt((center(1)-border(c,1))^2+(center(2)-border(c,2))^2);
        averageDist=averageDist+dist;
        if maxDist<dist
            maxDist=floor(dist);
        end
        if minDist>dist
            minDist=floor(dist);
        end
    end
    averageDist=floor(averageDist/col);
   
    lumen = border;
end