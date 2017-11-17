
function pushButtonCallback (object, eventdata)
% writes continuous mouse position to base workspace
disp('Button Clicked')
assignin('base','isButtonPressed',1)
end