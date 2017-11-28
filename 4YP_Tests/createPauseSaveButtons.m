function G = createPauseSaveButtons(G)

% create a "push button" user interface (UI) object
G.but_save = uicontrol('style', 'pushbutton',...
    'string', 'Save Last Preset',...
    'units', 'normalized',...
    'position', [0.0 0 0.25 0.11],...
    'callback', {@saveButtonCallback},...
    'visible', 'on',...
    'FontSize', 13);

% create a "push button" user interface (UI) object
G.but_pause = uicontrol('style', 'pushbutton',...
    'string', 'Pause On Last Preset',...
    'units', 'normalized',...
    'position', [0.25 0 0.25 0.11],...
    'callback', {@pauseButtonCallback},...
    'visible', 'on',...
    'FontSize', 13);

set(G.but_save,'HitTest','on')
set(G.but_pause,'HitTest','on')


% Initilally the program is in pause mode
G.but_pause.String = 'Begin Searching';    
G.but_pause.BackgroundColor = [0.94, 0.6, 0.6];

end


function saveButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Save Button Clicked')

assignin('base','isSaveButtonPressed',true)

end

function pauseButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Pause Button Clicked')

assignin('base','isPauseButtonPressed',true)

end