function [imgEdited] = updateEditedImage2(img, presetMix)

low_in = presetMix(1:3);
high_in = presetMix(4:6);
low_out = presetMix(7:9);
high_out = presetMix(10:12);
gamma = presetMix(13:15);

posRatio = presetMix(16);
radius = presetMix(17);
blackAndWhiteAmmountBackground = presetMix(18);
blackAndWhiteAmmountForeground = presetMix(19);

% limit range of low_in and high in to avoid bug when both equal zero
safetyBand = 0.02;
low_in = low_in*(1-safetyBand);
high_in = high_in*(1-safetyBand) + safetyBand;

%ensure low_in is smaller than high_in 
low_in_temp = min(low_in,high_in*0.98);
high_in_temp = max(low_in*1.02,high_in);

low_in_temp = max(low_in_temp,0);
high_in_temp = min(high_in_temp,1);

low_in = low_in_temp;
high_in = high_in_temp;
 

% remap gamma so it goes from 0 to infinity
gamma = tan(gamma*pi/2);

enhanced = imadjust(img,[low_in; high_in],[low_out; high_out], gamma);
% enhanced2 = imsharpen(enhanced,'Radius',2,'Amount',1,'Threshold',0.0);
% sharpening filter too slow!
%enhanced2 = imgaussfilt(enhanced, gaussianRadius);
% didn't add gaussian as it slowed it down a bit, and doesn't
% work well with a zero value


alphaMap =  alphaMapGaussian(img, radius, posRatio);



% Blend between Black and White vs Original 
enhanced = convertToGreyscale(enhanced,blackAndWhiteAmmountForeground);
background = convertToGreyscale(img,blackAndWhiteAmmountBackground);

%set(imageBW, 'AlphaData', blackAndWhiteAmmount);

% Vignettte the edited image

imgVignette = blendWithAlphaMap(enhanced, background, alphaMap);
%set(imageEdited, 'AlphaData', alphaMap);

imgEdited = imgVignette;

end