function [imageEdited, imageBW] = updateEditedImage(img, imageEdited, imageBW, presetMix)

low_in = presetMix(1:3);
high_in = presetMix(4:6);
low_out = presetMix(7:9);
high_out = presetMix(10:12);
gamma = presetMix(13:15);

posRatio = presetMix(16);
radius = presetMix(17);
blackAndWhiteAmmount = presetMix(18);

%ensure low_in & low_out are smaller than high_in & high_out
low_in = min(low_in,high_in*0.95);
high_in = max(low_in*1.05,high_in);
%low_out = min(low_out,high_out*0.95);  only necesary for in

% remap gamma so it goes from 0 to infinity
gamma = tan(gamma*pi/2);

enhanced = imadjust(img,[low_in; high_in],[low_out; high_out], gamma);
% enhanced2 = imsharpen(enhanced,'Radius',2,'Amount',1,'Threshold',0.0);
% sharpening filter too slow!
%enhanced2 = imgaussfilt(enhanced, gaussianRadius);
% didn't add gaussian as it slowed it down a bit, and doesn't
% work well with a zero value
imageEdited.CData = enhanced;
drawnow();



alphaMap =  alphaMapGaussian(img, radius, posRatio);

% Vignettte the edited image
set(imageEdited, 'AlphaData', alphaMap);

% Blend between Black and White vs Original Background
set(imageBW, 'AlphaData', blackAndWhiteAmmount);

end