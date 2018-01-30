

freqCoarse = [1, 2, 0.5, 6, 2, 4];
freqFine = [0.1, 0.01, 0.02, 0.1, 0.0, 0.1];

outputLevels = [1,0.5, 0, 0, 0.3, 0];

freq = freqCoarse.*(1+freqFine);

mod = [...
    0.0, 0.1, 0.2, 0.5, 0, 0;...
    0, 0, 0, 0, 0.1, 0;...
    0, 0, 0, 0, 1, 0;...
    0, 2, 0, 0, 0, 0;...
    0, 0, 0, 0, 0, 0;...
    2, 0, 0, 0, 0, 0,...
    ];
    
yPM = phaseModSynth(freq, mod);
output = outputLevels*yPM;

x =linspace(0,2,2000);

% Default colourorder
colours = get(gca,'colororder');


figure(6), clf 
subplot(2,3,1)
title('Input Frequencies')
ylim([0.5, 6.5]);
hold on
y2 = cell(1,6);
for i = 1:6
    y2{i} = 1*i + 0.5* sin(x*2*pi*freqCoarse(i)*(freqFine(i)+1));
    plot(x, y2{i}, 'LineWidth', 3)
end

subplot(2,3,2)
title('PM Modulaton Routing')
ylim([0.5, 6.5]);
hold on
for i = 1:6
    for j = 1:6
        if mod(i,j) > 0.001
            plot([0,1], [j, i], 'Color', colours(i,:), 'LineWidth', 2*mod(i,j)) 
        end
    end
end

subplot(2,3,3)
title('PM Modulation Output')
ylim([0.5, 6.5]);
hold on
for i = 1:6
    plot(i + 0.5*yPM(i,:), 'LineWidth', 3);
end

subplot(2,3,4:6)
title('PM Modulation Output Post-Mixing')
hold on
for i = 1:6
    plot(outputLevels(i)*yPM(i,:), 'LineWidth',1.5);
end
plot(output, 'Color', 'b', 'LineWidth', 3)




