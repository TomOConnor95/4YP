function G = createImgFreezeButtons(G)

% create a "push button" user interface (UI) object
G.but_freeze_foreground = uicontrol('style', 'pushbutton',...
    'string', 'Freeze Foreground',...
    'units', 'normalized',...
    'position', [0.5 0 0.25 0.11],...
    'callback', {@foregroundButtonCallback},...
    'visible', 'on',...
    'FontSize', 13);

% create a "push button" user interface (UI) object
G.but_freeze_background = uicontrol('style', 'pushbutton',...
    'string', 'Freeze Background',...
    'units', 'normalized',...
    'position', [0.75 0 0.25 0.11],...
    'callback', {@backgroundButtonCallback},...
    'visible', 'on',...
    'FontSize', 13);


set(G.but_freeze_foreground,'HitTest','on')
set(G.but_freeze_background,'HitTest','on')

end

function foregroundButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Freeze Foreground Button Clicked')

assignin('base','isForegroundButtonPressed',true)

end

function backgroundButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Freeze Background Button Clicked')

assignin('base','isBackgroundButtonPressed',true)

end