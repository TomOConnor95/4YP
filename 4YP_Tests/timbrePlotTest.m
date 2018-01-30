figure(5), clf , hold on

x =linspace(0,2,2000);

freqCoarse = [1, 2, 0.5, 6, 2, 4];
freqFine = [0.1, 0.01, 0.02, 0.1, 0.0, 0.1];

outputLevels = [1, 0.6, 0.3, 0.5, 0.1, .4];


seperation = 1.0;
y = cell(1,6);
for i = 1:6
    y{i} = seperation*i + outputLevels(i)*sin(x*2*pi*freqCoarse(i)*(freqFine(i)+1));
    plot(x, y{i}, 'LineWidth', 3)
end

figure(6), clf 
subplot(2,2,[1,3])
ylim([0.5, 6.5]);
hold on
y2 = cell(1,6);
for i = 1:6
    y2{i} = seperation*i + 0.5* sin(x*2*pi*freqCoarse(i)*(freqFine(i)+1));
    plot(x, y2{i}, 'LineWidth', 3)
end

subplot(2,2,[2,4])
hold on

modEnvAmt = [0.0, 0.5, 1.0, 0.6, 0.2, 0.1];
modA = 0.5;
modD = 0.4;
modS = 0.7;
modR = 8;

[modX, modY] = ADSR(modA, modD, modS, modR);

% Default colourorder
colours = get(gca,'colororder');

y3 = cell(1,6);
for i = 1:6
    y2{i} = seperation*i + 0.5* sin(x*2*pi*freqCoarse(i)*(freqFine(i)+1));
    fill([0, modX, modX(5), 0], ((i)*1 + [0, ((1-modEnvAmt(i)) + modEnvAmt(i)*modY),0, 0]), colours(i,:), 'FaceAlpha', 0.5, 'LineWidth', 2, 'EdgeColor', colours(i,:))
    
end



