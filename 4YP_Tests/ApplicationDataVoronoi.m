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
        
        idxPopupSelected = [];
        
        %currentSelectedPatch;
        
        
        u;      % UDP adress
        
        nameStrings;
        typeStrings;
        
        
        % PCA
        coeff;
        score;
        latent;
        
        coeffCell;
        
        presetPCAParams;
        
        variedPresetMarkers;
        variedPresetLines;
        
        % UI elements
        leftSliders;
        rightSliders;
        
        leftNumDisplays;
        rightNumDisplays;
        
        popup;
        
        timeData; % Time plots data
        timePlots;
        
        timbreData; % Timbre plots data
        timbrePlots;
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
            
            obj.presetPCAParams = repmat({zeros(2,4)},1,length(obj.presetStore(:,1)));
            
            obj.variedPresetMarkers = cell(1,length(obj.presetStore(:,1)));
            obj.variedPresetLines = cell(1,length(obj.presetStore(:,1)));
        end
        
    end
end