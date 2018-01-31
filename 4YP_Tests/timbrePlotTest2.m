% Parameters
freqCoarse = [1, 2, 0.5, 6, 2, 4];
freqFine = [0.01, 0.01, 0.02, 0.1, 0.0, 0.1];

outputLevels = [1,0.0, 1.0, 0, 0.0, 0];

freq = freqCoarse.*(1+freqFine);

mod = [...
    0.0, 0.6, 0.0, 0.7, 0, 0;...
    0, 0, 0, 0, 0.1, 0;...
    0, 0, 0, 0, 1, 0;...
    0, 2, 0, 0, 0, 0;...
    0, 0, 0, 0, 0, 0;...
    2, 0, 0, 0, 0, 0,...
    ];
    
%Calculate Data to plot
yPM = phaseModSynth(freq, mod);
output = outputLevels*yPM;

x =linspace(0,2,2000);

freqInData = cell(1,6);
for i = 1:6
    freqInData{i} = 1*i + 0.5* sin(x*2*pi*freqCoarse(i)*(freqFine(i)+1));
end

routingData = repmat({[0,0;0,0]},6,6);
for i = 1:6
    nonZeroIndeces = find(mod(i,:));
    for j = nonZeroIndeces
        routingData{i,j} = [0, 1; j, i];
    end   
end

freqOutData = cell(1,6);
for i = 1:6
    freqOutData{i} = i + 0.5*yPM(i,:);
end

% Create plots for timbre visualisation


% Default colourorder
colours = get(gca,'colororder');

figure(6), clf 
subplot(2,3,1)
title('Input Frequencies', 'FontSize', 15)
ylim([0.5, 6.5]);
set(gca, 'XTick',[])
hold on
freqInPlot = cell(1,6);
for i = 1:6
    freqInPlot{i} = plot(freqInData{i}, 'LineWidth', 3);
end


subplot(2,3,2)
title('Modulaton Routing', 'FontSize', 15)
ylim([0.5, 6.5]);
set(gca, 'XTick',[])
hold on

routingPlot = cell(6,6);
for i = 1:6
    for j = 1:6
        routingPlot{i,j} = plot(routingData{i,j}(1,:), routingData{i,j}(2,:), 'Color', colours(i,:));
        if mod(i,j) > 0.001
        	routingPlot{i,j}.LineWidth = 2*mod(i,j);
        end
    end
end

subplot(2,3,3)
title('Modulation Output', 'FontSize', 15)
ylim([0.5, 6.5]);
set(gca, 'XTick',[])
hold on
freqOutPlot = cell(1,6);
for i = 1:6
    freqOutPlot{i} = plot(freqOutData{i}, 'LineWidth', 3);
end

subplot(2,3,4:6)
title('Modulation Output Post-Mixing', 'FontSize', 15)
hold on
freqCombinedPlot = cell(1,6);
set(gca, 'XTick',[])
set(gca, 'YTick',[])
for i = 1:6
    freqCombinedPlot{i} = plot(outputLevels(i)*yPM(i,:), 'LineWidth',1.5);
end
freqOutputPlot = plot(output, 'Color', 'b', 'LineWidth', 3);


%% Change parameters and update plots
% Parameters
freqCoarse = [1, 3, 2, 0.5, 2, 4];
freqFine = [0.0, 0.01, 0.03, 0.1, 0.0, 0.1];

outputLevels = [1,0.5, 0.8, 0, 0.3, 1.0];

freq = freqCoarse.*(1+freqFine);

mod = [...
    0.0, 0.2, 0.0, 0.1, 0.0, 0.0;...
    0.0, 0.0, 0.3, 0.2, 0.1, 0.0;...
    0.0, 0.0, 0.0, 0.0, 1.0, 0.0;...
    0.0, 2.0, 0.0, 0.0, 0.0, 0.9;...
    0.0, 0.0, 1.0, 0.0, 0.0, 1.0;...
    2.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
    ];

%Calculate Data to plot
yPM = phaseModSynth(freq, mod);
output = outputLevels*yPM;

x =linspace(0,2,2000);

freqInData = cell(1,6);
for i = 1:6
    freqInData{i} = 1*i + 0.5* sin(x*2*pi*freqCoarse(i)*(freqFine(i)+1));
end

routingData = repmat({[0,0;0,0]},6,6);
for i = 1:6
    nonZeroIndeces = find(mod(i,:));
    for j = nonZeroIndeces
        routingData{i,j} = [0, 1; j, i];
    end   
end

freqOutData = cell(1,6);
for i = 1:6
    freqOutData{i} = i + 0.5*yPM(i,:);
end

% Update Plots
% Frequency In Plot
for i = 1:6
    freqInPlot{i}.YData = freqInData{i};
end
% Routing Plot
for i = 1:6
    for j = 1:6
        routingPlot{i,j}.XData = routingData{i,j}(1,:);
        routingPlot{i,j}.YData = routingData{i,j}(2,:);
        if mod(i,j) > 0.001
        	routingPlot{i,j}.LineWidth = 2*mod(i,j);
        end
    end
end
% Frequency Out Plot
for i = 1:6
    freqOutPlot{i}.YData = freqOutData{i};
end

% Frequency Combined Plot
for i = 1:6
    freqCombinedPlot{i}.YData = outputLevels(i)*yPM(i,:);
end
freqOutputPlot.YData = output;

