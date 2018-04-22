figure
clf
hold on
for i = 0:0.2:1
sigmoidWeights(20, i)
plot(ans, 'Color', colours(i*5+1,:), 'LineWidth', 2)
end
xticks([1, 2     4     6     8    10    12    14    16    18    20])
xlim([1,20])
legend({'CenterRatio = 0.0', 'CenterRatio = 0.2', 'CenterRatio = 0.4', 'CenterRatio = 0.6', 'CenterRatio = 0.8', 'CenterRatio = 1.0'}, 'FontSize', 14)
xlabel('\fontsize{14}Preset Number')
ylabel('\fontsize{14}Weighting')