function [freqCoarse] = mapToFreqCoarse( freqCoarse)

if freqCoarse < 0.8
    
    freqCoarse = 0.5;
else
   freqCoarse = floor(freqCoarse); 
    
end

end