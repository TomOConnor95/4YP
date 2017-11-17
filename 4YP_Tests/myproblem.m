function [x, fval, history] = myproblem(x0)
    history = [];
    options = optimset('OutputFcn', @myoutput);
    [x fval] = fminsearch(@objfun, x0,options);
        
    function stop = myoutput(x,optimvalues,state);
        stop = false;
        if isequal(state,'iter')
          history = [history; x];
        end
    end
    
    function z = objfun(x)
      z = exp(x(1))*(4*x(1)^2+2*x(2)^2+x(1)*x(2)+2*x(2));
    end
end



mousePosInitial = [0,0];
    
    %Call the solver patternsearch with the anonymous function, f: First on small image
    f = @(mousePos)evaluateFitnessUI(imgSmall, imgTargetSmall, mousePos, Ptest.presetA, Ptest.presetB, Ptest.presetC);
    
    [optimumMousePos,~] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options);
    
    