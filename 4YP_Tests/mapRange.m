function numOut = mapRange(numIn, startLow, startHigh, endLow, endHigh)
       numOut = ((numIn-startLow)/(startHigh-startLow))*(endHigh-endLow) + endLow;

end