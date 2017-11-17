%eg_fun code ---------------------------------------------------
% %copy paste this code into a file called eg_fun.m
% function eg_fun(object_handle, event)
%     disp('hi')
% end
% %updated eg_fun used to demonstrate passing variables
%copy paste this code into a file called eg_fun.m
function eg_fun(object_handle, event, edit_handle, ellipse_handle)
    str_entered = get(edit_handle, 'string');
     
    if strcmp(str_entered, 'red')
        col_val = [1 0 0];
    elseif strcmp(str_entered, 'green')
        col_val = [0 1 0];
    elseif strcmp(str_entered, 'blue')
         col_val = [0 0 1];
    else
        col_val = [0 0  0];
    end
    set(ellipse_handle, 'facecolor', col_val);
                 
end
%change_size code --------------------------------------------------
%copy paste this code into a file called change_size.m
function  change_size(objHandel, evt, annotation_handle, orig_pos)
    slider_value = get(objHandel,'Value');
    new_pos = orig_pos;
    new_pos(3:4) = orig_pos(3:4)*slider_value;
    set(annotation_handle, 'position', new_pos)
end