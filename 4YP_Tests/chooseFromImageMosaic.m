function selectedPresetNumber = chooseFromImageMosaic(img, mosaicWidth, mosaicHeight)

img = imresize(img,0.5);
%imgBW = imresize(imgBW,0.5);
figure(5)

% User Parameters
if nargin < 3
mosaicWidth = 3;
mosaicHeight = 3;
end
% Create Image Mosaics
mosaicRow = img;
for i = 1:(mosaicWidth-1)
mosaicRow = horzcat(mosaicRow,img);
end
imgMosaic = mosaicRow;
for i = 1:(mosaicHeight-1)
imgMosaic = vertcat(imgMosaic,mosaicRow);
end

imageEditedMosaic = imshow(imgMosaic);

% Read presets from .mat file 
presetRead = matfile('PresetStore.mat');

imgWidth = length(img(1,:,1));
imgHeight = length(img(:,1,1));

% Render the an edited image for each preset, and place them in the
% imageMosaic
for i= 1:mosaicWidth*mosaicHeight
    try
imgEditedTemp = updateEditedImage2(img, presetRead.presetStore(i,:));
imageRange = {(fix((i-1)/mosaicWidth) * imgHeight + 1):((fix((i-1)/mosaicWidth)+1) * imgHeight),...
                (mod((i-1),mosaicWidth) * imgWidth + 1):((mod((i-1),mosaicWidth)+1) * imgWidth)};
imageEditedMosaic.CData(imageRange{1},imageRange{2} ,:) = imgEditedTemp;
    catch
        break
    end
end
title('Choose your favourite 3 presets','FontSize',20);
hold on
numberOfSelectedPresets = 0;
selectedPresetNumber = zeros(1,3);
while numberOfSelectedPresets < 3
    [x,y] = ginput(1);
    selectedX = fix(x/imgWidth) + 1;
    selectedY = fix(y/imgHeight) + 1;
    
    selectedPresetNumber(numberOfSelectedPresets + 1) = selectedX + (mosaicWidth * (selectedY - 1));
    if length(nonzeros(unique(selectedPresetNumber))) == numberOfSelectedPresets + 1
        numberOfSelectedPresets = numberOfSelectedPresets + 1;
        
        plot(x,y,'ro','MarkerSize',20, 'MarkerFaceColor',[1,0.5,0.5])
    end
    
end
% Select 3 images!
pause(0.2)
close figure 5

end