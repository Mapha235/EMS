function [X, Y] = mesh_polartocart(BScan) 
    [nrow, ncol] = size(BScan);
    [rho,theta] = meshgrid(1:nrow,1:ncol);
    for i=1:ncol
        for j=1:nrow
            theta(i,j)= theta(i,j)*2*pi/ncol;
        end
    end
    [X,Y] = pol2cart(theta,rho);
end