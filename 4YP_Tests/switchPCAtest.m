function switchPCAtest(score_in)
figure(19), clf

numPresets = length(score_in(1,:));

% score_in is a set of PCA scores 
%(histogram normalise first for better results)
score = score_in;
score(isnan(score)) = 0;

pcaSums = zeros(1,numPresets-1);
pcaDiffs = zeros(1,numPresets-1);

for i = 1:(numPresets-1)
pcaSums(i) = sum(abs(score(i,:) + score(i+1,:)));
pcaDiffs(i) = sum(abs(score(i,:) - score(i+1,:)));
end

subplot(3,1,1), hold on
plot(log(pcaSums))
plot(log(pcaDiffs))
xlim([0,numPresets])
xlabel('Number of Presets')
ylabel('log Sum & log Diff')

signTest = pcaDiffs>pcaSums;

signTestNaN = signTest.*log(pcaDiffs);
signTestNaN(signTestNaN == 0) = NaN;
plot(signTestNaN, 'r+')


% for i = 1:35
%    if signTest == 1
%        
% end

signs = [1, mod((cumsum(signTest)+1),2)*(2)-1];

signsNaN = signs;
signsNaN(signsNaN == 1) = NaN;

plot(signsNaN, 'r-+', 'LineWidth', 3)

score_flipped =  score_in.*repmat(signs, numPresets, 1)';

legend('log sum', 'log diff', 'sum < diff', 'Presets to Flip Sign')

subplot(3,1,2)
hold on,
for idx = 1:numPresets
plot(1:numPresets, score_in(:,idx))
end
xlabel('Number of Presets')
ylabel('PCA 3 - Histogram Eq.')
xlim([0,numPresets])
subplot(3,1,3)
hold on,
for idx = 1:numPresets
plot(1:numPresets, score_flipped(:,idx))
end

xlim([0,numPresets])
xlabel('Number of Presets')
ylabel('PCA 3 - Corrected')
end