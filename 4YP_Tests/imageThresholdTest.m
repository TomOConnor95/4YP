selectedImageNumber = 1;
imgFullSize = loadSelectedImage(selectedImageNumber);

img = imresize(imgFullSize,0.2); 


%img = img(:,:,1);
% allocate space for thresholded image
% perform thresholding by logical indexing
image_thresholded = img;
image_thresholded(img>150) = 256;
image_thresholded(img<50) = 0;
% display result
figure(8)
subplot(1,2,1)
imshow(img,[])
title('original image')
subplot(1,2,2)
imshow(image_thresholded,[])
title('thresholded image')