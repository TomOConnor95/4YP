classdef presetGeneratorMonteCarlo < presetGeneratorParent
    % Generates new presets B & C based on past values of chosen presets

    properties(Access = private)
        % Generator Parameters
        initialTempOffset;
        tempOffset;
        tempScaling;
    end
    methods
        % Constructor
        function obj = presetGeneratorMonteCarlo(presetA_in, presetB_in, presetC_in, initialTempOffset_in, tempScaling_in)
            obj@presetGeneratorParent(presetA_in, presetB_in, presetC_in);
            
            if nargin < 4
            % Set Generator Parameters
            obj.initialTempOffset = 0.3;
            obj.tempOffset = obj.initialTempOffset;
            obj.tempScaling = 0.5;
            else 
            obj.initialTempOffset = initialTempOffset_in;
            obj.tempOffset = obj.initialTempOffset;
            obj.tempScaling = tempScaling_in;
            end 
        end
   
    end
    methods 
        function obj = generateNewBC(obj)  
            
            % Generate new B & C
            presetBtemp = (2*obj.presetA + mean(obj.presetAHistory))/3 + obj.tempScaling * (obj.tempOffset + std(obj.presetAHistory).^1.5).*randn(1,length(obj.presetA));
            presetCtemp = (2*obj.presetA + mean(obj.presetAHistory))/3 + obj.tempScaling * (obj.tempOffset + std(obj.presetAHistory).^1.5).*randn(1,length(obj.presetA));
            
            obj.presetB = bound(presetBtemp,0,1);
            obj.presetC = bound(presetCtemp,0,1);
            
             % Decay tempOffset
            obj.tempOffset = obj.tempOffset*0.9;
            disp(obj.tempOffset)
      
        end
    end
end