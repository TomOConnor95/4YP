function [alphaMap] = alphaMapGaussian(img, radiusIN, posRatio)
% create aplha map for vignette effect, see https://thilinasameera.wordpress.com/2011/06/18/photo-effects-using-matlab-1-0/#more-467
% Set Parameters
%radius = 2;
%grade = 2;
imgWidth = length(img(1,:,1));
imgHeight = length(img(:,1,1));

radius = (exp(radiusIN-0.5)^2)/4 * max(imgHeight,imgWidth);

if imgHeight < imgWidth
    gaussian = fspecial('gaussian', [imgHeight,imgWidth*2], radius);
    startIndex = floor(imgWidth*posRatio) + 1;
    stopIndex = startIndex + imgWidth -1;
    gaussian2 = gaussian(:,startIndex:stopIndex);
else
    gaussian = fspecial('gaussian', [imgHeight*2,imgWidth], radius);
    startIndex = floor(imgHeight*posRatio) + 1;
    stopIndex = startIndex + imgHeight -1;
    gaussian2 = gaussian(startIndex:stopIndex,:);
end

gaussian3 = gaussian2/(max(max(gaussian2)));
alphaMap = gaussian3;

end