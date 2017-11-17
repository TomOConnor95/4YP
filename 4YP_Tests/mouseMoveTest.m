
function mouseMoveTest (object, eventdata)
% writes continuous mouse position to base workspace
MOUSE = get (gca, 'CurrentPoint');

assignin('base','MOUSE',MOUSE)
end