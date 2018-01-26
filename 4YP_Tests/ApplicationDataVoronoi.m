classdef ApplicationDataVoronoi < handle
    properties (SetAccess = public, GetAccess = public)
        patchesPressed = [];
        
        x = [];
        y = [];
        
        selectedColour = [1.0, 0, 0];
        mouseOverColour = [0, 0, 1.0];
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