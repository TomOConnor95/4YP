function [img_out] = blendWithAlphaMap(img1,img2, alphaMap)

alphaMap3D = alphaMap;
alphaMap3D(:,:,2) = alphaMap;
alphaMap3D(:,:,3) = alphaMap;


assert(isequal(size(img1),size(img2)),'Images must be of equal size');
assert(isequal(size(img1),size(alphaMap3D)),'Images must be of equal size');

img_out = double(img1).*alphaMap +  double(img2).*(1-alphaMap);
img_out = uint8(img_out);
end