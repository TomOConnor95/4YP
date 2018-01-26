function [isOutOfRange] = mousePosOutOfRange(mousePos)
    A = mousePos > 1;
    B = mousePos < 0;
    if isempty(A(A==1)) && isempty(B(B==1))
        isOutOfRange = false;
    else
        isOutOfRange = true;
    end
end