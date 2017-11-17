% Optimisation Toolbox test
% Using a more complicated Image editer

% user params
targetGreyBlend = 0.4;
selectedImageNumber = 3;
selectedPresetNumber = 5;

% misc params
initialParams = rand(1,16);
initialParams = checkLowInHighIn(initialParams);

% Load and resize image
img = loadSelectedImage(selectedImageNumber);
imgSmall = imresize(img,0.02);
imgLarger = imresize(img,0.2);

% Read preset to use as taget
presetRead = matfile('PresetStore.mat');
preset = presetRead.presetStore(selectedPresetNumber,:);
preset = preset(1:15);

low_in = preset(1:3);
high_in = preset(4:6);
low_out = preset(7:9);
high_out = preset(10:12);
gamma = preset(13:15);

targetParams = [preset(1:15), targetGreyBlend];

% Render Presets
imgInitialSmall = renderPreset(imgSmall, initialParams);
imgTargetSmall = renderPreset(imgSmall, targetParams);

figure(10)
clf
subplot(4,1,1)
imshow(imgInitialSmall)
title('Random Initial Preset')
subplot(4,1,2)
imshow(imgTargetSmall)
title('Target Preset')

drawnow()


% Constaints: x(1)< x(4), , 
A = [1.001 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0;
     0 1.001 0 0 -1 0 0 0 0 0 0 0 0 0 0 0;
     0 0 1.001 0 0 -1 0 0 0 0 0 0 0 0 0 0];
b = [0; 0; 0];
% Options
options = optimoptions('patternsearch','PlotFcn', @psplotbestfLogScale);
%options.Display = 'iter';

%Call the solver patternsearch with the anonymous function, f: First on small image
f = @(inputParams)evaluateFitness(inputParams,imgSmall, imgTargetSmall);
[optimumParamsSmall,~] = patternsearch(f,initialParams,A,b,[],[],zeros(1,length(initialParams)),ones(1,length(initialParams)),options);

% Render output
imgOptimumSmall = renderPreset(imgSmall, optimumParamsSmall);
[~, diff2] = calculateSquaredErrorSum(imgOptimumSmall,imgTargetSmall);

figure(10)
subplot(4,1,3)
imshow(imgOptimumSmall)
title('Optimum Found Preset')
subplot(4,1,4)
imshow(uint8(diff2))
title('Squared Error')

pause()

% Render Larger Initial and Target Images
imgTargetLarger = renderPreset(imgLarger, targetParams);
imgInitialLarger = renderPreset(imgLarger, optimumParamsSmall);

[~, diff2] = calculateSquaredErrorSum(imgTargetLarger,imgInitialLarger);
diff2n = normaliseDiff(diff2);

figure(9)
subplot(3,1,1)
imshow(imgInitialLarger)
title('Starting Preset - Full Size')
subplot(3,1,2)
imshow(imgTargetLarger)
title('Target Preset - Full Size')
subplot(3,1,3)
imshow(uint8(diff2n))
title('Squared Error - Normalised')
drawnow()
pause(0.05)

% Next call solver on larger scale image
f = @(inputParams)evaluateFitness(inputParams,imgLarger, imgTargetLarger);
[optimumParams,~] = patternsearch(f,optimumParamsSmall,A,b,[],[],zeros(1,length(initialParams)),ones(1,length(initialParams)),options);

% Render Output
imgOptimum = renderPreset(imgLarger, optimumParams);
[squaredErrorSum, diff2] = calculateSquaredErrorSum(imgOptimum,imgTargetLarger);
diff2n = normaliseDiff(diff2);

figure (9)
subplot(3,1,3)
imshow(uint8(diff2n))
title('Squared Error - Normalised')
subplot(3,1,1)
imshow(imgOptimum)
title('Optimum Preset - Full Size')


function squaredErrorSum = evaluateFitness(inputParams,img, imgTarget)
    imgEdited = renderPreset(img, inputParams);
    squaredErrorSum = calculateSquaredErrorSum(imgEdited,imgTarget);
end

function imgEdited = renderPreset(img, params)
enhanced = adjustImageWithParams(img, params, zeros(1,16));
imgEdited = convertToGreyscale(enhanced,params(16));
end

function diff2n = normaliseDiff(diff2)
% normalise the error image so that it is visible on a plot
diff2n = diff2 * 255/(max(max(max(diff2))));
end