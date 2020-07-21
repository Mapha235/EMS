function BScan = slice(bscan_count, dataset, number)    
    [nrow, ncol] = size(dataset);
    periode = floor(ncol / bscan_count);

    curve_nr = periode * number;
    for i = 1:nrow
       for j = 1:periode
           BScan(i, j) = dataset(i, j + curve_nr);  
       end
    end
end