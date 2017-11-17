
% Options for Optimisation
% options = optimoptions('patternsearch','PlotFcn', {@psplotbestfLogScale, @psplotbestx});
%options.Display = 'iter';


mousePosInitial = [0,0];

%Call the solver patternsearch with the anonymous function, f: First on small image
f = @(mousePos)evaluateFitnessUI(imgSmall, imgTargetSmall, mousePos, Ptest.presetA, Ptest.presetB, Ptest.presetC);

%[optimumMousePos,~] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options);



[optimumMousePos, mouseHistory, squarredErrorSumHistory] = OptimFunction1(f, mousePosInitial);


function [optimumMousePos, mouseHistory, squaredErrorSumHistory] = OptimFunction1(f, mousePosInitial)
    mouseHistory = [];
    options = optimoptions('patternsearch','PlotFcn', {@psplotbestfLogScale, @psplotbestx}, 'OutputFcn', @myoutput);

    [optimumMousePos,~] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options);

    function stop = myoutput(optimvalues,state)
        stop = false;
        if isequal(state,'iter')
            mouseHistory = [mouseHistory; optimvalues.x];
            squaredErrorSumHistory = [squaredErrorSumHistory; optimvalues.fval];
        end
    end
end




% 
% 
% function [x, fval, history] = OptimFunction2(x0)
%     history = [];
%     options = optimset('OutputFcn', @myoutput);
%     [x fval] = fminsearch(@objfun, x0,options);
% 
%     function stop = myoutput(x,optimvalues,state);
%         stop = false;
%         if isequal(state,'iter')
%             history = [history; x];
%         end
%     end
% 
%     function z = objfun(x)
%         z = exp(x(1))*(4*x(1)^2+2*x(2)^2+x(1)*x(2)+2*x(2));
%     end
% end
% 
% [x fval history] = myproblem([-1 1]);
