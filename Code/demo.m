% Demo of crisp boundaries
%
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------


%% setup
% first cd to the directory containing this file, then run:
%compile; % this will check to make sure everything is compiled properly; if it is not, will try to compile it
%%

clear; close all; clc;
imgFolder = '../test_images/';
outFolder = '../result/';
imgFiles = dir([imgFolder, '34005124000001.jpg']);
times = [];
for i = 1 : length(imgFiles)
    disp(imgFiles(i).name);
    close all;

%% Detect boundaries
% you can control the speed/accuracy tradeoff by setting 'type' to one of the values below
% for more control, feel free to play with the parameters in setEnvironment.m

type = 'speedy'; % use this for fastest results
%type = 'accurate_low_res'; % use this for slightly slower but more accurate results
%type = 'accurate_high_res'; % use this for slow, but high resolution results

I = imread([imgFolder, imgFiles(i).name]);
tic;
[E,E_oriented] = findBoundaries(I,type);

%close all; subplot(121); imshow(I); subplot(122); imshow(1-mat2gray(E));
E_oriented = E_oriented ./ max(E_oriented(:));

%% Segment image
% builds an Ultrametric Contour Map from the detected boundaries (E_oriented)
% then segments image based on this map
%
% this part of the code is only supported on Mac and Linux
segs = {};
[~, name, ~] = fileparts(imgFiles(i).name);
for j = 1:5
    thresh = 0.1 * j; % larger values give fewer segments
    E_ucm = contours2ucm_crisp_boundaries(mat2gray(E_oriented));
    labels = bwlabel(E_ucm <= thresh);
    labels = imresize(labels, 2);
    [h, w] = size(labels);
    labels = labels(1:h-1, 1:w-1);
    segs{j}=labels;
    S = ucm2colorsegs(E_ucm,I,thresh);
end
save([outFolder, name, '.mat'], 'segs');
times(i) = toc;

close all; subplot(121); imshow(I); subplot(122); imshow(S);
end