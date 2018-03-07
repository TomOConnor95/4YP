function [Tdata] = timePlotDataFromPreset(preset)

% LFO A - A triangle wave
rateA = preset{8}(1);
ampA = preset{8}(2);

[Tdata.xA,Tdata.yA] = triangleWave(rateA, ampA);

% LFO B - a square wave
rateB = preset{9}(1);
ampB = preset{9}(2);
pulseWidth = preset{9}(3);

[Tdata.xB,Tdata.yB] = squareWave(rateB, ampB, pulseWidth);

% ADSR 

ampA = preset{10}(1);
ampD = preset{10}(2);
ampS = preset{10}(3);
ampR = preset{10}(4);
ampC = preset{10}(5);

modA = preset{11}(1);
modD = preset{11}(2);
modS = preset{11}(3);
modR = preset{11}(4);
modC = preset{11}(5);

[Tdata.xAmp, Tdata.yAmp] = ADSR(ampA, ampD, ampS, ampR, ampC);
[Tdata.xMod, Tdata.yMod] = ADSR(modA, modD, modS, modR, modC);

% VibratoPlot - A sine wave wave changing in amplitude and frequency

startRate = preset{12}(2);
endRate = preset{12}(3);

startAmp = preset{12}(4);
endAmp = preset{12}(5);

envTime = preset{12}(6);

[Tdata.xVib,Tdata.yVib] = vibratoWave(startRate, endRate, startAmp, endAmp, envTime);
end