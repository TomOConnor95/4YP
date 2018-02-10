function [Tplots] = createAllTimbrePlots(Tdata)
% Create plots for timbre visualisation

%subplot(1,6,1)
ax1 = axes('position',[0.025,0.05,0.15,0.85],...
        'Units','Normalized',...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[],...
        'Ylim', [0.5,6.5]);
hold on
title('Input Frequencies', 'FontSize', 15)

Tplots.freqInPlot = cell(1,6);
for i = 1:6
    Tplots.freqInPlot{i} = plot(ax1, Tdata.freqInData{i}, 'LineWidth', 3);
end

% Default colourorder
colours = get(gca,'colororder');

%subplot(1,6,2)
ax2 = axes('position',[0.2,0.05,0.15,0.85],...
        'Units','Normalized',...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[],...
        'Xlim', [0,1],...
        'Ylim', [0.5,6.5]);
hold on
title('Modulaton Routing', 'FontSize', 15)
%ylim([0.5, 6.5]);
%set(gca, 'XTick',[])


Tplots.routingPlot = cell(6,6);
for i = 1:6
    for j = 1:6
        Tplots.routingPlot{i,j} = plot(ax2, Tdata.routingData{i,j}(1,:), Tdata.routingData{i,j}(2,:), 'Color', colours(j,:));
        if Tdata.mod(i,j) > 0.001
        	Tplots.routingPlot{i,j}.LineWidth = 2*Tdata.mod(i,j);
        end
    end
end

% subplot(1,6,3)
ax3 = axes('position',[0.375,0.05,0.15,0.85],...
        'Units','Normalized',...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[],...
        'Ylim', [0.5,6.5]);
hold on    
title('Modulation Output', 'FontSize', 15)

Tplots.freqOutPlot = cell(1,6);
for i = 1:6
    Tplots.freqOutPlot{i} = plot(ax3, Tdata.freqOutData{i}, 'LineWidth', 3);
end

%subplot(1,6,4:6)
ax4 = axes('position',[0.55,0.05,0.4,0.85],...
        'Units','Normalized',...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[]);
hold on
title('Modulation Output Post-Mixing', 'FontSize', 15)

Tplots.freqCombinedPlot = cell(1,6);

for i = 1:6
    Tplots.freqCombinedPlot{i} = plot(ax4,Tdata.outputLevels(i)*Tdata.yPM(i,:), 'LineWidth',1.5);
end
Tplots.freqOutputPlot = plot(ax4,Tdata.output, 'Color', 'b', 'LineWidth', 3);

end