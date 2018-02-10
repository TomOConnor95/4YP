classdef ApplicationDataBlendingInterface < handle
    properties (SetAccess = public, GetAccess = public)
        
        % Program State
        isPaused = true;
        isBlending = true;
        
        markerIndex = 1;
        currentMarkerIndex = 0;
        presetsDoubleClicked = [];
        
        % Preset Structure
        P;
        nameStrings;
        typeStrings;
        
        % Geometry Structure
        G;
        
        % UDP conneection
        u;
        
        pauseButton;
        saveButton;
        % Button Colours
        pauseColour = [0.6, 0.94, 0.6];
        normalButtonColour = [0.94, 0.94, 0.94];
        
        % Freezing UI
        p1;
        p2;
        
        barStruct; 
        % Option parameters
        savePresetsToFile = true;
        displayParameters = true;
        displayBarGraphs = true;
        
        

    end
    
    methods
        % Constructor
        function obj = ApplicationDataBlendingInterface()
            
            % Open UDP connection
            appData.u = udp('127.0.0.1',57120); 
            fopen(appData.u); 

            %----------------------------------------------------------%
            %----------------------Presets-----------------------------%
            %----------------------------------------------------------%
            
            %----------------------------------------------------------%
            %----------------------Figures & Plots---------------------%
            %----------------------------------------------------------%
            
            %----------------------------------------------------------%
            %----------------------Miscellaneous-----------------------%
            %----------------------------------------------------------%
            
            
        end
        
    end
end

%----------------------------------------------------------%
%----------------------Callbacks---------------------------%
%----------------------------------------------------------%

%----------------------------------------------------------%
%----------------------Misc Functions----------------------%
%----------------------------------------------------------%


%----------------------------------------------------------%
%----------------------UI Objects--------------------------%
%----------------------------------------------------------%

