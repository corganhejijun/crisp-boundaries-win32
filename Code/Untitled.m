a = imread('../test_images/000001.png');
a = imresize(a,0.2);
scatterColor = reshape(a, size(a, 1)*size(a,2), size(a,3));
scatterColor = double(scatterColor)/255;
a = rgb2lab(a);
vec = reshape(a, size(a, 1)*size(a,2), size(a,3));
%%
scatter3(vec(:,1), vec(:,2), vec(:, 3), [], scatterColor, 'filled', 'MarkerEdgeColor','k');
% xlim([0,1]);
% ylim([0,1]);
% zlim([0,1]);

%%
AIC = zeros(1,4);
GMModels = cell(1,4);
options = statset('MaxIter',500);
for k = 1:4
    GMModels{k} = fitgmdist(vec,k,'Options',options,'CovarianceType','diagonal');
    AIC(k)= GMModels{k}.AIC;
end

[minAIC,numComponents] = min(AIC);
numComponents

BestModel = GMModels{numComponents}