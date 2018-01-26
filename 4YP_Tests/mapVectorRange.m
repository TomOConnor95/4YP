function [mappedVector] = mapVectorRange(vector, low, high)
% Map the range of a vector to fit inbetween min & max
mappedVector = mapRange(vector, min(vector), max(vector), low, high);

end