classdef ApplicationDataBlendingInterface < handle
    properties (SetAccess = public, GetAccess = public)
        MOUSE = [0,0];
        isPaused = true;
        isBlending = true;
        
        nameStrings;
        typeStrings;
        
        P;
        
        G;
        
        
        u;
        
        pauseButton;
        saveButton;
        
        p1;
        p2;
        % Button Colours
        pauseColour = [0.6, 0.94, 0.6];
        normalButtonColour = [0.94, 0.94, 0.94];
        
        
        barStruct; 
        % Option parameters
        savePresetsToFile = true;
        displayParameters = true;
        displayBarGraphs = false;
        
        markerIndex = 1;
        currentMarkerIndex = 0;
        presetsDoubleClicked = [];

    end
    
    methods
        % Constructor
        function obj = ApplicationDataBlendingInterface()
            
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

