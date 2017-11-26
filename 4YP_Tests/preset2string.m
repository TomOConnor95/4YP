function [string] = preset2string(preset, nameStrings)


string = [nameStrings{1},':\n'];
PMparams = reshape(preset{1},[6,6]);

for i = 1:6
   string = [string, mat2str(PMparams(i,:),3), '\n'];    
end

for i = 2:length(preset)
string = [string, [nameStrings{i},': ',mat2str(preset{i},3), '\n']];
end


end