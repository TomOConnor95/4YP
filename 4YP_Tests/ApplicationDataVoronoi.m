classdef ApplicationDataVoronoi < handle
    properties (SetAccess = public, GetAccess = public)

        selectedColour = [1.0, 0, 0];
        mouseOverColour = [0, 0, 1.0];
        mouseOverSelectedColour = [1.0, 0.4, 0.75];
        
        colours;
        
        patches;
        
        presetStore;
        presetStoreVaried;
        
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
        
        coeffCell;
        
        % UI elements
        leftSliders;
        rightSliders;
        
        leftNumDisplays;
        rightNumDisplays;
    end
    
    methods
        % Constructor
        function obj = ApplicationDataVoronoi()
            
            % Open UDP connection
            obj.u = udp('127.0.0.1',57120);
            fopen(obj.u);
            
            % Get nameStrings and TypeStrings
            [~, obj.nameStrings, obj.typeStrings] = createPresetAforOSC();
            
            
            % Load Presets
            presetRead = matfile('PresetStoreSC.mat');
            obj.presetStore = presetRead.presetStore;
            
            obj.presetStoreVaried = obj.presetStore;
            
        end
        
    end
end