a = imread('../test_images/12003.jpg');
a = imresize(a,0.2);
scatterColor = reshape(a, size(a, 1)*size(a,2), size(a,3));
scatterColor = double(scatterColor)/255;
a = rgb2hsv(a);
vec = reshape(a, size(a, 1)*size(a,2), size(a,3));
conVec = Hsv2Cone3D(vec);
%%
scatter3(conVec(:,1), conVec(:,2), conVec(:, 3), [], scatterColor, 'filled', 'MarkerEdgeColor','k');
xlim([0,1]);
ylim([0,1]);
zlim([0,1]);

%%
AIC = zeros(1,4);
GMModels = cell(1,4);
options = statset('MaxIter',500);
for k = 1:4
    GMModels{k} = fitgmdist(conVec,k,'Options',options,'CovarianceType','diagonal');
    AIC(k)= GMModels{k}.AIC;
end

[minAIC,numComponents] = min(AIC);
numComponents

BestModel = GMModels{numComponents}