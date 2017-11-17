function [alphaMap] = alphaMapVignette(img,posRatio,radius,grade)
% create aplha map for vignette effect, see https://thilinasameera.wordpress.com/2011/06/18/photo-effects-using-matlab-1-0/#more-467
% Set Parameters
%radius = 2;
%grade = 2;

radius = 5*atanh(radius);
grade = tan((grade^0.2)*pi/2)^0.6;    % scale [0,1] to suitable range;
% fplot(@(x) tan(x*pi/2)^0.5,[0,1])

% Focal point and processing parameters
[r c d] = size(img);
alphaMap = zeros(r,c);

if c > r
    Xratio = posRatio;
    Yratio = 0.5;
else
    Xratio = 0.5;
    Yratio = posRatio;
end

X = Xratio * c;
Y = Yratio * r;

L = sqrt(r^2 + c^2) / 2;

% Processing
for i = 1:r
  for j = 1:c
    distanceFromCenter = sqrt((Y-i)^2 + (X-j)^2);
    f = (max(L-distanceFromCenter,0))./L;
    f = (radius*f^grade);
    if(f>1)
      f=1;
    end
    alphaMap(i,j) = f;
  end
end
