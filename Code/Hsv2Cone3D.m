function [ coneCord ] = Hsv2Cone3D( hsvValue )
% convert hsv 3d coordinate into hsv color cone 3d values
% height z = value
% angle p = hue * 2pi
% radius r = saturation * value
% x = cos(p) * r = cos(hue * 2pi) * saturation * value
% y = sin(p) * r
    coneCord = [(cos(hsvValue(:,1)*2*pi) .* hsvValue(:,2) .* hsvValue(:,3)), ...
        sin(hsvValue(:,1)*2*pi) .* hsvValue(:,2) .* hsvValue(:,3), ...
        hsvValue(:,3)];
end

