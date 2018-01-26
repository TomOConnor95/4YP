presetRead = matfile('PresetStoreSC.mat');

presetStoreFlattened = cell2mat(presetRead.presetStore);

presetStoreFlattened = presetStoreFlattened(1:17,:);

Y = tsne(presetStoreFlattened)