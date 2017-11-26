function [barStruct] = updateBarGraphsStruct(preset, barStruct)

% stacked bar graph for PM params
for i = 1:6
    barStruct{1}(i).YData = abs(preset{1}((1:6)+(6*(i-1))));
end

% All other bar graphs
for i = 2:length(preset)
    barStruct{i}.YData = preset{i};
end
%drawnow()
end