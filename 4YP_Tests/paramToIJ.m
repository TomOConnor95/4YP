function [i,j] = paramToIJ(paramNum, presetLengthSum)   
    i = find(presetLengthSum < paramNum,1,'Last');
    if i>1
    j = paramNum - presetLengthSum(i);
    else
    j = paramNum;
    end
end