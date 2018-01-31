function [Tdata] = timbrePlotDataFromPreset(preset)
% Load timbre parameter data from a given preset
Tdata.mod = reshape(preset{1},6,6);

Tdata.freqCoarse = preset{2};
Tdata.freqFine = preset{3};

Tdata.outputLevels = preset{3};

Tdata.freq = Tdata.freqCoarse.*(1+Tdata.freqFine);


%Calculate Data to plot
Tdata.yPM = phaseModSynth(Tdata.freq, Tdata.mod);
Tdata.output = 1.1*Tdata.outputLevels*Tdata.yPM;

x =linspace(0,2,2000);

Tdata.freqInData = cell(1,6);
for i = 1:6
    Tdata.freqInData{i} = 1*i + 0.5* sin(x*2*pi*Tdata.freqCoarse(i)*(Tdata.freqFine(i)+1));
end

Tdata.routingData = repmat({[0,0;0,0]},6,6);
for i = 1:6
    nonZeroIndeces = find(Tdata.mod(i,:));
    for j = nonZeroIndeces
        Tdata.routingData{i,j} = [0, 1; j, i];
    end   
end

Tdata.freqOutData = cell(1,6);
for i = 1:6
    Tdata.freqOutData{i} = i + 0.5*Tdata.yPM(i,:);
end

end