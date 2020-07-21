function M = FilterM(Bscan,num)
    M = Bscan;
    M = medfilt2(M,[3,3]);
    M = mat2gray(mat2gray(imadjust(imadjust(M))),[num,1]);
%     [~,threshold] = edge(M,'sobel');
%     fudgeFactor = 0.5;
%     M = edge(M,'sobel',threshold * fudgeFactor);
%     se90 = strel('line',30,90);
%     se0 = strel('line',30,0);
%     M = imdilate(M,[se90 se0]);
    %M = imbinarize(M, 'adaptive');
    %M = otsuthresh(M);
end