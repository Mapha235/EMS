function numberOfScans = numberofAScans(dataset)
    % dataset = load('phantom1_1_2.mat');
    % dataset = dataset.mscancut;
    [rows, values] = size(dataset);
    
    
    B = dataset(20:140, :);
    C = edge(B, 'Canny', [0.4 0.5]);
    numberOfScans = 0;

    %Find the starting Point of the triange signal
    c = 120
    while B(c, 1) + B(c-4, 1) + B(c-8, 1) + B(c-12, 1) < 950 %ca. 250 pro B
        c = c-1;
    end

    numberOfScansPosition = c-1;

    %Look how many triangles there are
    c = 1;
    while c < values - 5
        
        if C(numberOfScansPosition, c) + C(numberOfScansPosition, c+1) + C(numberOfScansPosition, c+2) + C(numberOfScansPosition, c+3) + C(numberOfScansPosition, c+4) == 5
            numberOfScans = numberOfScans + 1;
            c = c+7000;                         %Davon ausgehend, dass der nächste Spike min. 7000 Pixel entfernt ist
        end
        c = c+1;
    end
end