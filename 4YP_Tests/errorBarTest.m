mean_velocity = [0.2574, 0.1225, 0.1787]; % mean velocity
std_velocity = [0.3314, 0.2278, 0.2836];  % standard deviation of velocity
figure
hold on
bar(1:3,mean_velocity)
errorbar(1:3,mean_velocity,std_velocity,'.')