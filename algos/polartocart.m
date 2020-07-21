function cart = polartocart(BScan, x, y) 
    cart = zeros(1100);
    [nrow, ncol] = size(BScan);
    periodlength = double(ncol);
    for x1 = 1:periodlength
        theta = x1 * 2 * pi /floor(periodlength);
        for x2 = 1:nrow
            rho = x2;
            [y1, y2] = pol2cart(theta, rho);
            %Map values to pixels on d-image
            m11 = floor(y1)+550;
            m12 = floor(y2)+550;
            cart(m11, m12) = BScan((x2), x1);
        end
    end
end