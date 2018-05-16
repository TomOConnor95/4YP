function [alpha,beta,gamma] = calculatePresetRatios(G, point)
%Point must be a 2d column vector

% matrix equation for no orthogonal basis vectors
%https://math.stackexchange.com/questions/148199/
% equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing
if nargin ==1
    point = G.P1;
end

M = [G.B,G.C];
Y = (M'*M)\M'*point;
beta = Y(1);
gamma = Y(2);
alpha = 1-beta-gamma;

end