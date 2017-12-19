
ampA = 0.1;
ampD = 0.5;
ampS = 0.1;
ampR = 0.9;

modA = 0.5;
modD = 0.4;
modS = 0.7;
modR = 8;

[ampX, ampY] = ADSR(ampA, ampD, ampS, ampR);
[modX, modY] = ADSR(modA, modD, modS, modR);

ampColour = [70, 130, 220]/256;
modColour = [220, 70, 70]/256;

figure(2)
fill([modX,0], [modY,0], modColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', modColour)
hold on
%plot(modX, modY, 'LineWidth', 3, 'Color', modColour);

fill([ampX,0], [ampY,0], ampColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', ampColour)
%plot(ampX, ampY, 'LineWidth', 3, 'Color', ampColour);
hold off

xlim([0, 8])
ylim([0, 1])


