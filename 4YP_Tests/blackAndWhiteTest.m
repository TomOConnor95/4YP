selectedImageNumber = 1;
imgFullSize = loadSelectedImage(selectedImageNumber);

img = imresize(imgFullSize,0.2); 


% Coefficients for R G B
greyscaleCoefficientsAverage = [1/3, 1/3, 1/3];
greyscaleCoefficientsLuminosity = [0.21, 0.72, 0.07];
blendCoefficients = 1;  % Value from 0 - 1: 1 for Luminosity technique
greyscaleCoefficients = (1-blendCoefficients)*greyscaleCoefficientsAverage ...
                        + blendCoefficients*greyscaleCoefficientsLuminosity;

% create greyscaled image                    
imgGreyscale = (greyscaleCoefficients(1)*img(:,:,1)...
              + greyscaleCoefficients(2)*img(:,:,2)...
              + greyscaleCoefficients(3)*img(:,:,3));


% blend between colour and greyScale
blendGreyscale = 1;

image_bw = img;
image_bw(:,:,1) = (1-blendGreyscale) * image_bw(:,:,1)...
                  + blendGreyscale * imgGreyscale;
              
image_bw(:,:,2) = (1-blendGreyscale) * image_bw(:,:,2)...
                  + blendGreyscale * imgGreyscale;
              
image_bw(:,:,3) = (1-blendGreyscale) * image_bw(:,:,3)...
                  + blendGreyscale * imgGreyscale;
% display result
figure(8)
subplot(1,2,1)
imshow(img,[])
title('original image')
subplot(1,2,2)
imshow(image_bw,[])
title('greyscale image')