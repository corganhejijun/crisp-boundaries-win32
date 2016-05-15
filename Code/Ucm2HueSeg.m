function [ hueSeg ] = Ucm2HueSeg( ucm, img, hueCenters )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % 当value小于0.2时，为黑色。当saturation小于0.1时，图像变为黑白
    blackValueThreshold = 0.2;
    colorSaturationThreshold = 0.1;
    edgeThreshold = 0;
    
    % in hueCenters array, black is -0.2, white and gray is -0.1
    
    img = im2double(img);
    labels = bwlabel(~(ucm > edgeThreshold));

    % make higher resolution
    labels = inPaint(labels,labels~=0);
    
    ii = unique(labels);
    ii = ii(2:end); % remove zero label
    
    % Each cell element store 1 cluster image, divided by hueCenters
    colorsegs = cell(1, size(hueCenters, 1) + 1);
    for i = 1 : size(hueCenters, 1) + 1
        colorsegs{i} = zeros(size(img));
    end
    for i=1:length(ii)
        m = labels==ii(i);
        meanR = img(:,:,1);
        meanR = mean(meanR(m));
        meanG = img(:,:,2);
        meanG = mean(meanG(m));
        meanB = img(:,:,3);
        meanB = mean(meanB(m));
        [meanHue, meanSat, meanValue] = rgb2hsv([meanR, meanG, meanB]);
        meanHsv = meanHue;
        if meanValue < blackValueThreshold
%             meanHsv = -0.2;
            index = size(hueCenters, 1) + 1;
        elseif meanSat < colorSaturationThreshold
%             meanHsv = -0.1;
            index = size(hueCenters, 1) + 1;
        else
            [~, index] = min(abs(meanHsv - hueCenters));
        end
        
         for c=1:size(img,3)
             tmp = img(:,:,c);
             colorsegs_tmp = colorsegs{index}(:,:,c);
             colorsegs_tmp(m) = tmp(m);
             colorsegs{index}(:,:,c) = colorsegs_tmp;
         end
    end    
    hueSeg = colorsegs;
end

