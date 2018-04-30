
% % read continuous mouse position
% set (gcf, 'WindowButtonMotionFcn', @mouseMove);

% function mouseMove (object, eventdata)
% MOUSE = get (gca, 'CurrentPoint')
% P1 = [MOUSE(1,1);MOUSE(1,2)];

% Construct Equilateral triangle
sideLength = 10;

A = [0;0];
B = [-sideLength/2;sideLength*(sqrt(3)/2)];
C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [A,B,C,A];



% test points
P1{1} = B;
P1{2} = (B+C)/2;
P1{3} = C;
P1{4} = (B+A)/2;
P1{5} = (A+B+C)/3;
P1{6} = (C+A)/2;
P1{7} = 0.3*C + 0.7*(B-C);
P1{8} = A;
P1{9} = 0.3*B -0.7*(B-C);

figure(2),clf
subplot(5,3,1:6)

% plot(A(1),A(2), 'r+')
% plot(B(1),B(2), 'r+')
% plot(C(1),C(2), 'r+')
plot(sides(1,:),sides(2,:)), hold on
axis([-10,10,-4,12])
axis equal
% plot(0,sideLength*(sqrt(3)/2)*(2/3),'b+')
% guide lines outside of triangle
plot([-1/2,0,1/2]*sideLength,[-(sqrt(3)/2),0,-(sqrt(3)/2)]*sideLength,'r')
plot([1,1/2,3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r')
plot([-1,-1/2,-3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r')

text(A(1)-0.8, A(2)-0.0, 'A','Color', 'red', 'FontSize', 15) 
text(B(1)+0.3, B(2)+0.5, 'B','Color', 'red', 'FontSize', 15) 
text(C(1)-0.8, C(2)+0.5, 'C','Color', 'red', 'FontSize', 15) 

title('\fontsize{15}Blended Preset Positions')
for i = 1:9
subplot(5,3,1:6)
plot(P1{i}(1), P1{i}(2), 'bo', 'MarkerSize', 8)
text(P1{i}(1)+0.3, P1{i}(2)-0.3, num2str(i), 'FontSize', 15) 
 
% test presets
presetA = [0.5,0.5,0.5,0.5,0.5,0.5];
presetB = [0.1,0.2,0.3,0.4,0.5,0.6];
presetC = [1 0 1 0 1 0];


% % lines from corners to point
%  lines = [P1{i},A,P1,B,P1,C];
% % plot(lines(1,:),lines(2,:))

%find vectors
vecA = [P1{i}-A];
vecB = [P1{i}-B];
vecC = [P1{i}-C];



% matrix equation for no orthogonal basis vectors https://math.stackexchange.com/questions/148199/equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing

M = [B,C];
Y = (M'*M)\M'*P1{i};
beta = Y(1);
gamma = Y(2);
alpha = 1-beta-gamma;

% plot(0,sideLength*alpha,'r+')
% plot(B(1)*beta,B(2)*beta, 'r+')
% plot(C(1)*gamma,C(2)*gamma, 'r+')

subplot(5,3,i+6)
% bar([alpha,beta,gamma]);
presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
bar(presetMix,'r');
hold on
bar([(presetA' * alpha),(presetB'*beta),(presetC'*gamma)])

ylim([-0.0,1.1])
xlim([0.5, 6.5])
title(['\fontsize{14}Position ', num2str(i)], 'Color', 'blue')
% subplot(1,2,2)
% presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
% bar(presetMix,'r');
% hold on
% bar([(presetA' * alpha),(presetB'*beta),(presetC'*gamma)])
% hold off

% ylim([-2,2])
% figure(1)
end
subplot(5,3,7)
legend('Blended Preset', 'Preset A', 'Preset B', 'Preset C', 'Location',  'NorthWest')

subplot(5,3,13)
ylim([-0.5,1.1])
subplot(5,3,14)
ylim([-0.5,1.1])
subplot(5,3,15)
ylim([-0.5,1.1])


subplot(5,3,7)
title(['\fontsize{14}Position ', num2str(1), ' - B'], 'Color', 'red')
subplot(5,3,9)
title(['\fontsize{14}Position ', num2str(3), ' - C'], 'Color', 'red')
subplot(5,3,14)
title(['\fontsize{14}Position ', num2str(8), ' - A'], 'Color', 'red')