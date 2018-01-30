freq = [1, 0.5, 3, 1.5, 5, 6];
outputLevels = [1, 1, 0, 0, 0.5, 0];
mod = [...
    0.0, 0.9, 0.7, 0.5, 0, 0;...
    0, 0, 0, 0, 0.1, 0;...
    0, 0, 0, 0, 1, 0;...
    0, 0, 0, 0, 0, 0;...
    0, 0, 0, 0, 0, 0;...
    2, 0, 0, 0, 0, 0,...
    ];
    

y = phaseModSynth(freq, mod);

output = outputLevels*y;

figure(7)
clf
subplot(2,1,1)
hold on
for i = 1:6
    plot(outputLevels(i)*y(i,:), 'LineWidth',1.5);
end

plot(output, 'b', 'LineWidth', 3)


subplot(2,1,2)

hold on
for i = 1:6
    plot(2*i+y(i,:), 'LineWidth', 3);
end


