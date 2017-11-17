clear all

% user params
targetGreyBlend = 0.1;
selectedImageNumber = 1;

selectedPresetNumber = 1;

trainingRate = 0.00000000002;

% misc params
initialParams = rand(1,16);
if initialParams(1) > initialParams(4)
    temp = initialParams(1);
    initialParams(1) = initialParams(4);
    initialParams(4) = temp;
end
if initialParams(2) > initialParams(5)
    temp = initialParams(2);
    initialParams(2) = initialParams(5);
    initialParams(5) = temp;
end
if initialParams(3) > initialParams(6)
    temp = initialParams(3);
    initialParams(3) = initialParams(6);
    initialParams(6) = temp;
end

currentParams = initialParams;

img = loadSelectedImage(selectedImageNumber);
imgSmall = imresize(img,0.1);
gradientHistory = [];
paramsHistory = [];
squaredErrorSumHistory = [];

presetRead = matfile('PresetStore.mat');
preset = presetRead.presetStore(selectedPresetNumber,:);
preset = preset(1:15);

low_in = preset(1:3);
high_in = preset(4:6);
low_out = preset(7:9);
high_out = preset(10:12);
gamma = preset(13:15);


squaredErrorSumPlus = zeros(1,length(preset)+1);
squaredErrorSumMinus = zeros(1,length(preset)+1);
% target for optimiser to aim for

enhancedTarget = imadjust(imgSmall,[low_in; high_in],[low_out; high_out], gamma);
imgGreyTarget = convertToGreyscale(enhancedTarget,targetGreyBlend);


enhanced = adjustImageWithParams(imgSmall, currentParams, zeros(1,16));
imgGrey = convertToGreyscale(enhanced,currentParams(16));

initialSquaredErrorSum = calculateSquaredErrorSum(imgGrey,imgGreyTarget);
squaredErrorSum = 1e20;

% optimisation Loop
iteration = 0;
while iteration< 200    %squaredErrorSum > initialSquaredErrorSum/10000
    iteration = iteration + 1;
    % calculate gradient
    for i = 1:(length(currentParams)-1)
        changeVector = zeros(1,length(currentParams));
        
        changeVector(i) = 0.01;
        enhanced = adjustImageWithParams(imgSmall, currentParams, changeVector);
        imgGrey = convertToGreyscale(enhanced,currentParams(16));
        squaredErrorSumPlus(i) = calculateSquaredErrorSum(imgGrey,imgGreyTarget);
        
        changeVector(i) = -0.01;
        enhanced = adjustImageWithParams(imgSmall, currentParams, changeVector);
        imgGrey = convertToGreyscale(enhanced,currentParams(16));
        squaredErrorSumMinus(i) = calculateSquaredErrorSum(imgGrey,imgGreyTarget);
        
        changeVector(i) = 0;
    end
    
    enhanced = adjustImageWithParams(imgSmall, currentParams, zeros(1,16));
    imgGrey = convertToGreyscale(enhanced,currentParams(16)+0.01);
    squaredErrorSumPlus(length(currentParams)) = calculateSquaredErrorSum(imgGrey,imgGreyTarget);
    imgGrey = convertToGreyscale(enhanced,currentParams(16)-0.01);
    squaredErrorSumMinus(length(currentParams)) = calculateSquaredErrorSum(imgGrey,imgGreyTarget);
    
    currentGradient = (squaredErrorSumPlus - squaredErrorSumMinus)/0.02;
    gradientHistory = [gradientHistory; currentGradient];
    % Update params & recompute error
    deltaParams = (trainingRate * currentGradient);
    if abs(deltaParams) < 0.001
        break
    end
    currentParams = currentParams - deltaParams;
    currentParams = min(currentParams,1);
    currentParams = max(currentParams,0);
    paramsHistory = [paramsHistory; currentParams];
    
    enhanced = adjustImageWithParams(imgSmall, currentParams, zeros(1,16));
    imgGrey = convertToGreyscale(enhanced,currentParams(16));
    [squaredErrorSum, diff2] = calculateSquaredErrorSum(imgGrey,imgGreyTarget);
    squaredErrorSumHistory = [squaredErrorSumHistory, squaredErrorSum];
    
%     figure (9)
%     subplot(3,1,1)
%     imshow(uint8(diff2))
%     
%     subplot(3,1,2)
%     imshow(imgGreyTarget)
%     subplot(3,1,3)
%     imshow(imgGrey)
%     
    pause(0.01)
end

    figure (9)
    subplot(3,1,1)
    imshow(uint8(diff2))
    
    subplot(3,1,2)
    imshow(imgGreyTarget)
    subplot(3,1,3)
    imshow(imgGrey)

figure(10)
subplot(3,1,1)
semilogy(abs(gradientHistory));
title('Gradient History')
subplot(3,1,2);
semilogy(squaredErrorSumHistory)
title('Squared Error Sum History')
subplot(3,1,3)
plot(paramsHistory)
title('Parameters History')
ylim([0,1])



