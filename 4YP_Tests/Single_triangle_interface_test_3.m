
% Construct Equilateral triangle
sideLength = 10;

A = [0;0];
B = [-sideLength/2;sideLength*(sqrt(3)/2)];
C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [A,B,C,A];





while(true)
     pause(0.05)  
    MOUSE = get (gca, 'PointerLocation')
    P1 = [MOUSE(1,1);MOUSE(1,2)];
%Redraw Triangle and lines
figure(1)
hold off
plot(A(1),A(2), 'r+')
hold on
plot(B(1),B(2), 'r+')
plot(C(1),C(2), 'r+')
plot(sides(1,:),sides(2,:))
axis([-14,14,-9,17])
axis equal
plot(0,sideLength*(sqrt(3)/2)*(2/3),'b+')

% guide lines outside of triangle
plot([-1/2,0,1/2]*sideLength,[-(sqrt(3)/2),0,-(sqrt(3)/2)]*sideLength,'r')
plot([1,1/2,3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r')
plot([-1,-1/2,-3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r')

% test point
%P1 = [0;sideLength*(sqrt(3)/3)];
%[mouseX, mouseY] = ginput(1);
%P1 = [mouseX;mouseY];
plot(P1(1),P1(2), 'r+')

% test presets
presetA = [0.5,0.5,0.5,0.5,0.5,0.5];
presetB = [0.1,0.2,0.3,0.4,0.5,0.6];
presetC = [1 0 1 0 1 0];


% lines from corners to point
lines = [P1,A,P1,B,P1,C];
plot(lines(1,:),lines(2,:))

%find vectors
vecA = [P1-A];
vecB = [P1-B];
vecC = [P1-C];



% matrix equation for no orthogonal basis vectors https://math.stackexchange.com/questions/148199/equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing

M = [B,C];
Y = (M'*M)\M'*P1;
beta = Y(1);
gamma = Y(2);
alpha = 1-beta-gamma;

% plot(0,sideLength*alpha,'r+')
% plot(B(1)*beta,B(2)*beta, 'r+')
% plot(C(1)*gamma,C(2)*gamma, 'r+')
figure(2)
subplot(1,2,1)
bar([alpha,beta,gamma]);
ylim([-2,2])

subplot(1,2,2)
presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
bar(presetMix,'r');
hold on
bar([(presetA' * alpha),(presetB'*beta),(presetC'*gamma)])
hold off

ylim([-2,2])
figure(1)
end
