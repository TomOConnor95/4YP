function barPlotPMparams =  updateBarPlotPMparams(barPlotPMparams, PMparams)

% Bar3d stores its data weirldly, need to edit each of the vertives
% individually

for i = 1:6
    zdata = barPlotPMparams(i).ZData;
    for j = 1:6
    zdata((2:3) + 6*(j-1), (2:3)) = ones(2,2)*PMparams(i,j);
    end
    barPlotPMparams(i).ZData = zdata;
    barPlotPMparams(i).CData = zdata;
end

end