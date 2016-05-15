function [ result ] = GmmFit( data )
%Get best Gmm centers of one dimension data
    clusterAICChangeThreshold = 0.21;
    lastGmm = {};
    lastDelta = 0;
    options = statset('MaxIter',500);
    for i = 1 : 8
        gmm = fitgmdist(data', i, 'Options',options);
        disp([num2str(i), ' AIC = ', num2str(gmm.AIC)]);
        if ~isempty(lastGmm)
            disp(['last delta = ', num2str(lastDelta)]);
            if lastGmm.AIC < gmm.AIC || (lastGmm.AIC - gmm.AIC) < clusterAICChangeThreshold*lastDelta
                break;
            end
            lastDelta = lastGmm.AIC - gmm.AIC;
        end
        lastGmm = gmm;
    end
    result = lastGmm;
end

