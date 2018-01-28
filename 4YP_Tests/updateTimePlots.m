function Tplots = updateTimePlots(Tplots, Tdata)

Tplots.modFill.Vertices(1:5,1) = Tdata.xMod';
Tplots.modFill.Vertices(1:5,2) = Tdata.yMod';

Tplots.ampFill.Vertices(1:5,1) = Tdata.xAmp';
Tplots.ampFill.Vertices(1:5,2) = Tdata.yAmp';

Tplots.vibratoWavePlot.XData = Tdata.xVib;
Tplots.vibratoWavePlot.YData = Tdata.yVib;

Tplots.triWavePlot.XData = Tdata.xA;
Tplots.triWavePlot.YData = Tdata.yA;

Tplots.squareWavePlot.XData = Tdata.xB;
Tplots.squareWavePlot.YData = Tdata.yB;
end