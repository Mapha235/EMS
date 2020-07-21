function img = remove_static_artefact(BScan_with_catheter)
    [nrow, ncol] = size(BScan_with_catheter);
    removed_pixels = 512 - nrow;
    display(223 - removed_pixels)
    for c=1:ncol
        mean = (BScan_with_catheter(220 - removed_pixels, c) + BScan_with_catheter(226 - removed_pixels, c))/2;
        BScan_with_catheter(223 - removed_pixels, c) = mean;
        BScan_with_catheter(224 - removed_pixels, c) = mean;
        BScan_with_catheter(225 - removed_pixels, c) = mean;
    end
    img = BScan_with_catheter;

    img = BScan_with_catheter;
    for c=1:ncol
       mean = ( img(218,c)+ img(227,c) )/2;
       for d=1:(226-220)
           img(220+d,c) = mean;
       end
    end
end