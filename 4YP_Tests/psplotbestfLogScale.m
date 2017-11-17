function stop = psplotbestfLogScale(optimvalues,flag)
%PSPLOTBESTF PlotFcn to plot best function value.
%   STOP = PSPLOTBESTF(OPTIMVALUES,FLAG) where OPTIMVALUES is a structure
%   with the following fields:
%              x: current point X
%      iteration: iteration count
%           fval: function value
%       meshsize: current mesh size
%      funccount: number of function evaluations
%         method: method used in last iteration
%         TolFun: tolerance on function value in last iteration
%           TolX: tolerance on X value in last iteration
%
%   FLAG: Current state in which PlotFcn is called. Possible values are:
%           init: initialization state
%           iter: iteration state
%           done: final state
%
%   STOP: A boolean to stop the algorithm.
%
%   See also PATTERNSEARCH, GA, OPTIMOPTIONS.


%   Copyright 2003-2015 The MathWorks, Inc.

stop = false;
switch flag
    case 'init'
        plotBest = semilogy(optimvalues.iteration,optimvalues.fval, 'ob', 'MarkerSize', 5, 'MarkerFaceColor', [0,0.2,0.5]);
        set(plotBest,'Tag','psplotbestf');
        xlabel('Iteration','interp','none'); 
        ylabel('Function value','interp','none')
        title(sprintf('Best Function Value: %g',optimvalues.fval),'interp','none');
    case 'iter'
        plotBest = findobj(get(gca,'Children'),'Tag','psplotbestf');
        newX = [get(plotBest,'Xdata') optimvalues.iteration];
        newY = [get(plotBest,'Ydata') optimvalues.fval];
        set(plotBest,'Xdata',newX, 'Ydata',newY);
        set(get(gca,'Title'),'String',sprintf('Best Function Value: %g',optimvalues.fval));
        
end
