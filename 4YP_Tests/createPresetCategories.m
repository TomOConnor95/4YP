function [presetCategories, categoryIndeces] = createPresetCategories()

% divide the presets into categories

% Categories: Piano/Keys, Mallet/Plucked, Bass, Synth Lead, Synth Pad,
% Rhythmic
numPresets = 32;

pianoKeys = [14, 15, 17, 19, 26];
pluckedMallet = [4, 6, 7, 8, 21, 28, 29];
bass = [1, 11, 12, 15, 25];
synthLead = [1, 2, 9, 13, 20, 21, 24, 30, 31, 32];
synthPad = [3, 5, 10, 16, 17, 18, 22, 23, 25, 26, 27];
rhythmic = [7, 17, 22, 23, 25, 27, 31];

presetCategories = repmat({zeros(1,6)}, 1, numPresets);

presetCategories = toggleGroupIndeces(presetCategories, 1, pianoKeys);
presetCategories = toggleGroupIndeces(presetCategories, 2, pluckedMallet);
presetCategories = toggleGroupIndeces(presetCategories, 3, bass);
presetCategories = toggleGroupIndeces(presetCategories, 4, synthLead);
presetCategories = toggleGroupIndeces(presetCategories, 5, synthPad);
presetCategories = toggleGroupIndeces(presetCategories, 6, rhythmic);

function presetGroups = toggleGroupIndeces(presetGroups, index, group)
    for i = 1:length(group)
        presetGroups{group(i)}(index) = 1;
    end
end

categoryIndeces = {pianoKeys, pluckedMallet, bass, synthLead, synthPad, rhythmic};
end