% writingToFileTest

x = 0:.1:1;
A = [x; exp(x)];

fileID = fopen('SavedPresets.txt','w');
fprintf(fileID,'Saved Presets\n');
fprintf(fileID,'%1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f\n',P.presetA);
fclose(fileID);