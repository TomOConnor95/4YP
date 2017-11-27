function [pointHistoryPlot] = createPointHistoryPlot()
% Creates plot showing the history of the positions clicked on

pointHistoryPlot.vector_tree = tree([0,0]);
pointHistoryPlot.sum_tree = tree([0,0]);

hold off
pointHistoryPlot.plot_tree = tree('clear');
pointHistoryPlot.plot_markers_tree = tree(plot(0,0, 'ro','MarkerSize',25,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback2, 1}, 'PickableParts','all'));

title('Selection Location History')
set(gca,'color',[0.7 0.9 1])
hold on

pointHistoryPlot.but_select_presets = uicontrol('style', 'pushbutton',...
    'string', 'Select 3 Presets to Blend',...
    'units', 'normalized',...
    'position', [0.4 0 0.3 0.12],...
    'callback', {@selectPresetsButtonCallback},...
    'visible', 'on');

end


function selectPresetsButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Select Presets Button Clicked')

assignin('base','isSelectPresetsButtonPressed',true)

end
