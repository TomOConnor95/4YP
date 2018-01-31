function [Tplots] = updateTimbrePlots(Tplots, Tdata)


for i = 1:6
    Tplots.freqInPlot{i}.YData = Tdata.freqInData{i};
end
% Routing Plot
for i = 1:6
    for j = 1:6
        Tplots.routingPlot{i,j}.XData = Tdata.routingData{i,j}(1,:);
        Tplots.routingPlot{i,j}.YData = Tdata.routingData{i,j}(2,:);
        if Tdata.mod(i,j) > 0.001
        	Tplots.routingPlot{i,j}.LineWidth = 2*Tdata.mod(i,j);
        end
    end
end
% Frequency Out Plot
for i = 1:6
    Tplots.freqOutPlot{i}.YData = Tdata.freqOutData{i};
end

% Frequency Combined Plot
for i = 1:6
    Tplots.freqCombinedPlot{i}.YData = Tdata.outputLevels(i)*Tdata.yPM(i,:);
end
Tplots.freqOutputPlot.YData = Tdata.output;


end