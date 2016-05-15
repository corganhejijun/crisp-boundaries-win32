function [ hueCenters, valueCenters ] = HueCluster( img )
%Get hue centers of image
    [height, width, ~] = size(img);
    hsvImg = rgb2hsv(img);
    % 当value小于0.2时，为黑色。当saturation小于0.1时，图像变为黑白
    blackValueThreshold = 0.2;
    colorSaturationThreshold = 0.1;
    hue = hsvImg(:,:,1);
    saturation = hsvImg(:,:,2);
    grayMap = (saturation < colorSaturationThreshold);
    value = hsvImg(:,:,3);
    
    blackMap = (value < blackValueThreshold);
    noColorMap = or(grayMap, blackMap);
    colorMap = ~noColorMap;
    
    hue = hue .* colorMap;
    
    % no color hue stands for black-gray-white color, the value is from
    % -0.2 to -0.1, -0.2 means value is 1 stands for white, and -0.1 means
    % value is 0 stands for black
%     noColorHue = value .* noColorMap;
    noColorRegion = -0.1 * noColorMap;
    hue = hue + noColorRegion;
    % black is -0.2, white and gray is -0.1
%     hue = hue + (noColorHue*(-0.1) - noColorMap*0.1);
    hueData = reshape(hue, [1, height*width]);
    hueData(hueData == -0.1) = [];
    
    gmmResult = GmmFit(hueData);
    disp('hue cluster result is:');
    disp(gmmResult);
    hueCenters = gmmResult.mu;
    
    valueData = reshape(value, [1, height*width]);
    gmmResult2 = GmmFit(valueData);
    disp('value cluster result is:');
    disp(gmmResult2);
    valueCenters = gmmResult2.mu;
    
%     meanSaturation = mean(saturation(:));
%     meanValue = mean(value(:));
%     centers = zeros([size(lastGmm.mu, 1), 3]);
%     for i = 1 : size(lastGmm.mu, 1)
%         if (lastGmm.mu(i) < 0)
%             centers(i, :) = [0, 0, 10*(lastGmm.mu(i) + 0.2)];
%         else
%             centers(i, :) = [lastGmm.mu(i), meanSaturation, meanValue];
%         end
%     end
%     centers = hsv2rgb(centers);
    
    [numbers, edges] = histcounts(hueData);
    figure;
    for b = 1 : size(numbers, 2)
        % Plot one single bar as a separate bar series.
        handleToThisBarSeries(b) = bar(edges(b), numbers(b), 'BarWidth', (edges(b+1) - edges(b)));
        % Apply the color to this bar series.
        if edges(b) < 0
            if edges(b) <= -0.1 && edges(b) >= -0.2
                faceColor = hsv2rgb([0, 0, edges(b)*(-10)-1]);
            else
                continue;
            end
        else
            faceColor = hsv2rgb([edges(b), 0.7, 0.7]);
        end
        set(handleToThisBarSeries(b), 'FaceColor', faceColor);
        hold on;
    end
    hold off;
    xlim([min(edges), max(edges)]);
    title('hue');
    figure;histogram(reshape(saturation, [1, height*width]));
    title('saturation');
    figure;histogram(reshape(value, [1, height*width]));
    title('value');
end

