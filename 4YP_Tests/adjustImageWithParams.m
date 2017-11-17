function enhanced = adjustImageWithParams(img, currentParams, changeVector)

    currentParams = currentParams + changeVector;
currentParams = min(currentParams,1);
currentParams = max(currentParams,0);
    
low_in = currentParams(1:3);
high_in = currentParams(4:6);
low_out = currentParams(7:9);
high_out = currentParams(10:12);
gamma = currentParams(13:15);

enhanced = imadjust(img,[low_in; high_in],[low_out; high_out], gamma);

end