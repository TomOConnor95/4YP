function [freqCoarse] = mapToFreqCoarse( freqCoarse)

for i = 1:length(freqCoarse)

    if freqCoarse(i) < 0.8

        freqCoarse(i) = 0.5;
    else
       freqCoarse(i) = freqCoarse(i) - mod(freqCoarse(i),2); 

    end

    
end
end