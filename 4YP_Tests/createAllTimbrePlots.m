function [Tplots] = createAllTimbrePlots(Tdata)
% Create plots for timbre visualisation

% Default colourorder
colours = get(gca,'colororder');

subplot(2,3,1)
title('Input Frequencies', 'FontSize', 15)
ylim([0.5, 6.5]);
set(gca, 'XTick',[])
hold on
Tplots.freqInPlot = cell(1,6);
for i = 1:6
    Tplots.freqInPlot{i} = plot(Tdata.freqInData{i}, 'LineWidth', 3);
end


subplot(2,3,2)
title('Modulaton Routing', 'FontSize', 15)
ylim([0.5, 6.5]);
set(gca, 'XTick',[])
hold on

Tplots.routingPlot = cell(6,6);
for i = 1:6
    for j = 1:6
        Tplots.routingPlot{i,j} = plot(Tdata.routingData{i,j}(1,:), Tdata.routingData{i,j}(2,:), 'Color', colours(j,:));
        if Tdata.mod(i,j) > 0.001
        	Tplots.routingPlot{i,j}.LineWidth = 2*Tdata.mod(i,j);
        end
    end
end

subplot(2,3,3)
title('Modulation Output', 'FontSize', 15)
ylim([0.5, 6.5]);
set(gca, 'XTick',[])
hold on
Tplots.freqOutPlot = cell(1,6);
for i = 1:6
    Tplots.freqOutPlot{i} = plot(Tdata.freqOutData{i}, 'LineWidth', 3);
end

subplot(2,3,4:6)
title('Modulation Output Post-Mixing', 'FontSize', 15)
hold on
Tplots.freqCombinedPlot = cell(1,6);
set(gca, 'XTick',[])
set(gca, 'YTick',[])
for i = 1:6
    Tplots.freqCombinedPlot{i} = plot(Tdata.outputLevels(i)*Tdata.yPM(i,:), 'LineWidth',1.5);
end
Tplots.freqOutputPlot = plot(Tdata.output, 'Color', 'b', 'LineWidth', 3);

end