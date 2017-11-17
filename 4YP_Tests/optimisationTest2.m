% Optimisation Toolbox test
% Using a simpler Image editer

% user params
selectedImageNumber = 2;
selectedPresetNumber = 7;

% Load and resize image
img = loadSelectedImage(selectedImageNumber);
imgSmall = imresize(img,0.02);
imgLarger = imresize(img,0.2);

% Read preset to use as taget
presetRead = matfile('PresetStore.mat');
targetParams = presetRead.presetStore(selectedPresetNumber,:);

% Randomly Generate Preset as Starting Point
initialParams = rand(1,length(targetParams));
initialParams = checkLowInHighIn(initialParams);

 %Render Presets
imgInitialSmall = renderPreset(imgSmall, initialParams);
imgInitialLarger = renderPreset(imgLarger, initialParams);
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
A = zeros(3,length(initialParams));
A(1,1) = 1.001;
A(1,4) = -1;
A(2,2) = 1.001;
A(2,5) = -1;
A(3,3) = 1.001;
A(3,6) = -1;
b = [0; 0; 0];
% Options
options = optimoptions('patternsearch','PlotFcn', @psplotbestfLogScale);
%options.Display = 'iter';

%Call the solver patternsearch with the anonymous function, f: First on small image
f = @(inputParams)evaluateFitness(inputParams,imgSmall, imgTargetSmall);
[optimumParamsSmall,fval1] = patternsearch(f,initialParams,A,b,[],[],zeros(1,length(initialParams)),ones(1,length(initialParams)),options);

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

%pause()

% Render Larger Initial and Target Images
imgTargetLarger = renderPreset(imgLarger, targetParams);
imgMidwayLarger = renderPreset(imgLarger, optimumParamsSmall);

[~, diff2] = calculateSquaredErrorSum(imgTargetLarger,imgMidwayLarger);
diff2n = normaliseDiff(diff2);

figure(9)
subplot(2,2,1)
imshow(imgInitialLarger)
title('Starting Preset - Full Size')
subplot(2,2,4)
imshow(imgMidwayLarger)
title('Small Optimised Preset - Full Size')
subplot(2,2,3)
imshow(imgTargetLarger)
title('Target Preset - Full Size')
subplot(2,2,2)
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
    subplot(2,2,2)
    imshow(uint8(diff2n))
    title('Squared Error - Normalised')
    subplot(2,2,4)
    imshow(imgOptimum)
    title('Optimum Preset - Full Size')


function squaredErrorSum = evaluateFitness(inputParams,img, imgTarget)
    imgEdited = renderPreset(img, inputParams);
    squaredErrorSum = calculateSquaredErrorSum(imgEdited,imgTarget);
end

function imgEdited = renderPreset(img, params)
imgEdited = updateEditedImage2(img, params);
end

function diff2n = normaliseDiff(diff2)
% normalise the error image so that it is visible on a plot
diff2n = diff2 * 255/(max(max(max(diff2))));
end