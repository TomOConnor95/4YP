function squaredErrorSum = evaluateFitness(inputParams,img, imgTarget)
    imgEdited = updateEditedImage2(img, inputParams);
    squaredErrorSum = calculateSquaredErrorSum(imgEdited,imgTarget);
end

