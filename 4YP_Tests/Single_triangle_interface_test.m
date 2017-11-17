% Construct Equilateral triangle
sideLength = 10;

A = [0;0];
B = [-sideLength/2;sideLength*(sqrt(3)/2)];
C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [A,B,C,A];

hold off
plot(A(1),A(2), 'r+')
hold on
plot(B(1),B(2), 'r+')
plot(C(1),C(2), 'r+')
plot(sides(1,:),sides(2,:))
axis([-7,7,-2,8])
axis equal



% test point
%P1 = [0;sideLength*(sqrt(3)/3)];
[mouseX, mouseY] = ginput(1);
P1 = [mouseX;mouseY]
plot(P1(1),P1(2), 'r+')


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
beta = Y(1)
gamma = Y(2)
alpha = 1-beta-gamma

plot(0,sideLength*alpha,'r+')
plot(B(1)*beta,B(2)*beta, 'r+')
plot(C(1)*gamma,C(2)*gamma, 'r+')