selectedImageNumber = 2;

% generate Random target Preset & load all presets
presetRead = matfile('PresetStore.mat');
presetArray = presetRead.presetStore;

targetParams = rand(1,length(presetArray(1,:)));
targetParams = checkLowInHighIn(targetParams);

% Load image and render Target Image from target Preset
img = loadSelectedImage(selectedImageNumber);
imgLarger = imresize(img,0.2);
imgTargetLarger = updateEditedImage2(imgLarger, targetParams);


% Find closest 3 Images to target
[selectedPresetNumbers] = findClosestImages(imgLarger, imgTargetLarger, presetArray, 3);


% Display Results
figure

subplot(2,2,1)
imshow(imgTargetLarger)
title('Target Image')
subplot(2,2,2)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
title('1st Closest Match')
subplot(2,2,3)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(2),:)));
title('2nd Closest Match')
subplot(2,2,4)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(3),:)));
title('3rd Closest Match')