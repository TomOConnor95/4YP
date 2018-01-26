classdef ApplicationDataVoronoi < handle
    properties (SetAccess = public, GetAccess = public)
        patchesPressed = [];
        
        x = [];
        y = [];
        
        selectedColour = [1.0, 0.2, 0.7];
        mouseOverColour = [0.9, 0.6, 0.6];
        mouseOverSelectedColour = [1.0, 0.4, 0.75];
        
        colours
        
        patches;
        
        presetStore;
        
        presetPositions;
        
        idxCurrent = 1;
        
        idxSelected = [];
        
        %currentSelectedPatch;
        
        
        u;      % UDP adress
        
        nameStrings;
        typeStrings;
        
        
        % PCA
        coeff;
        score;
        latent;
    end
end