% sigmoid function test

figure(10)
subplot(1,2,1)
maxVal = 10;

x = 1:maxVal;
y = sigmf(x,[10/maxVal, 1*maxVal]);
y = y/sum(y);
plot(x,y)
xlabel('sigmf, P = [2 4]')
%ylim([-0.05 1.05])

% Beta function test
subplot(1,2,2)

X = 0:.01:1;
y1 = betapdf(X,0.75,0.75);
y2 = betapdf(X,1,1);
y3 = betapdf(X,4,4);
y4 = betapdf(X,1,1.5);

plot(X,y1,'Color','r','LineWidth',2)
hold on
plot(X,y2,'LineStyle','-.','Color','b','LineWidth',2)
plot(X,y3,'LineStyle',':','Color','g','LineWidth',2)
plot(X,y4,'LineStyle',':','Color','r','LineWidth',2)
legend({'a = b = 0.75','a = b = 1','a = b = 4'},'Location','NorthEast');
hold off