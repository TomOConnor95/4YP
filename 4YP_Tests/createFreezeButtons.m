function G = createFreezeButtons(G)

% create a "push button" user interface (UI) object
G.but_freeze_timbre = uicontrol('style', 'pushbutton',...
    'string', 'Freeze Timbre',...
    'units', 'normalized',...
    'position', [0.5 0 0.25 0.11],...
    'callback', {@timbreButtonCallback},...
    'visible', 'on',...
    'FontSize', 13);

% create a "push button" user interface (UI) object
G.but_freeze_time = uicontrol('style', 'pushbutton',...
    'string', 'Freeze Time',...
    'units', 'normalized',...
    'position', [0.75 0 0.25 0.11],...
    'callback', {@timeButtonCallback},...
    'visible', 'on',...
    'FontSize', 13);


set(G.but_freeze_timbre,'HitTest','on')
set(G.but_freeze_time,'HitTest','on')

end

function timbreButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Freeze Timbre Button Clicked')

assignin('base','isTimbreButtonPressed',true)

end

function timeButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Freeze Time Button Clicked')

assignin('base','isTimeButtonPressed',true)

end