%% Detect boundaries
% you can control the speed/accuracy tradeoff by setting 'type' to one of the values below
% for more control, feel free to play with the parameters in setEnvironment.m

clear; close all; clc;
% type = 'speedy'; % use this for fastest results
%type = 'accurate_low_res'; % use this for slightly slower but more accurate results
type = 'accurate_high_res'; % use this for slow, but high resolution results

I = imread('../test_images/253027.jpg');
[height, width, ~] = size(I);
% resize image short edge to 100px
bigEnd = 200;
if bigEnd < min([height, width])
    I = imresize(I, bigEnd/min([height, width]));
end
hsv = rgb2hsv(I);
[E,E_oriented] = findBoundaries(hsv(:,:,3),type);

subplot(121); imshow(I); subplot(122); imshow(1-mat2gray(E));
E_oriented = E_oriented ./ max(E_oriented(:));

%% Segment image
% builds an Ultrametric Contour Map from the detected boundaries (E_oriented)
% then segments image based on this map
%
% this part of the code is only supported on Mac and Linux
E_ucm = contours2ucm_crisp_boundaries(mat2gray(E_oriented));

%%
close all;
[hueCenters, valueCenters] = HueCluster(I);

%%
S = Ucm2HueSeg(E_ucm,I, valueCenters);

%show cells in image
for i = 1 : length(S)
    figure; imagesc(S{i});
end
