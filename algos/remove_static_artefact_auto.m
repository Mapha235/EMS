function dataset = remove_static_artefact_auto(dataset)
    [nrow ncol] = size(dataset);
    staticMax = 0;
    staticPos = 0;

    for c = 150:260
        val = 0;
        for d = 1:10
            val = val + dataset(c, d*40);
        end
        if val > staticMax
            staticMax = val;
            staticPos = c;
        end
    end

    for c=1:ncol
        mean = (dataset(staticPos-4, c) + dataset(staticPos+5, c))/2;
        for i = 1:7
            dataset(staticPos-3+i, c) = mean;
        end
    end
end