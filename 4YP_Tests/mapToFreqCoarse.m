function [freqCoarse] = mapToFreqCoarse(freqCoarse)

for i = 1:length(freqCoarse)

    if freqCoarse(i) < 0.75
        
        freqCoarse(i) = 0.5;
        
    elseif freqCoarse(i) < 1.5
        
        freqCoarse(i) = 1;
        
    else
       freqCoarse(i) = freqCoarse(i) + 0.5 - rem(freqCoarse(i) + 0.5, 1); 

    end

    
end
end