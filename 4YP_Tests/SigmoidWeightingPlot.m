figure
clf
hold on
for i = 0:0.2:1
sigmoidWeights(20, i)
plot(ans, 'Color', colours(i*5+1,:), 'LineWidth', 2)
end
xticks([1, 2     4     6     8    10    12    14    16    18    20])
xlim([1,20])
legend({'c = 0.0', 'c = 0.2', 'c = 0.4', 'c = 0.6', 'c = 0.8', 'c = 1.0'}, 'FontSize', 14)
xlabel('\fontsize{14}Preset Number')
ylabel('\fontsize{14}Weighting')