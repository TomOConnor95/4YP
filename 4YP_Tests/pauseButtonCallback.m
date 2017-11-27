
function pauseButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Pause Button Clicked')

assignin('base','isPauseButtonPressed',true)

end