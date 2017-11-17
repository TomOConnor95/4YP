function [img_out] = convertToGreyscale(img, blendGreyscale, blendCoefficients)

if nargin < 3
   blendCoefficients = 1;  % Value from 0 - 1: 1 for Luminosity technique 
end
if nargin < 2
    blendGreyscale = 1; % Value from 0 - 1: 1 for Greyscale 
end

% Coefficients for R G B
greyscaleCoefficientsAverage = [1/3, 1/3, 1/3];
greyscaleCoefficientsLuminosity = [0.21, 0.72, 0.07];

greyscaleCoefficients = (1-blendCoefficients)*greyscaleCoefficientsAverage ...
                        + blendCoefficients*greyscaleCoefficientsLuminosity;

% create greyscaled image                    
imgGreyscale = (greyscaleCoefficients(1)*img(:,:,1)...
              + greyscaleCoefficients(2)*img(:,:,2)...
              + greyscaleCoefficients(3)*img(:,:,3));


% blend between colour and greyScale

img_out = img;
img_out(:,:,1) = (1-blendGreyscale) * img_out(:,:,1)...
                  + blendGreyscale * imgGreyscale;
              
img_out(:,:,2) = (1-blendGreyscale) * img_out(:,:,2)...
                  + blendGreyscale * imgGreyscale;
              
img_out(:,:,3) = (1-blendGreyscale) * img_out(:,:,3)...
                  + blendGreyscale * imgGreyscale;

end
