function [freqCoarse] = mapToFreqCoarse( freqCoarse)

for i = 1:length(freqCoarse)

    if freqCoarse(i) < 1.0

        freqCoarse(i) = 0.5;
    else
       freqCoarse(i) = freqCoarse(i) - rem(freqCoarse(i),1); 

    end

    
end
end