function BScan = slice(bscan_count, dataset, number)    
    % dataset = dataset(100:512,:);
    [nrow, ncol] = size(dataset);
    % for c=1:ncol
    %     mean = (dataset(220, c)+ dataset(226, c))/2;
    %        dataset(223, c) = mean;
    %        dataset(224, c) = mean;
    %        dataset(225, c) = mean;
    % end

    periode = floor(ncol / bscan_count);


    curve_nr = periode * number;
    for i = 1:nrow
       for j = 1:periode
           BScan(i, j) = dataset(i, j + curve_nr);  
       end
    end
end