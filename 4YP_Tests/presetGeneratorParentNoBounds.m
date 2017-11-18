classdef (Abstract) presetGeneratorParentNoBounds
    % Generates new presets B & C based on past values of chosen presets
    properties
        presetA
        presetB
        presetC
    end
    properties(GetAccess=public,SetAccess=private)
        presetAHistory
        presetBHistory
        presetCHistory
        presetMix
    end
    methods
        % Constructor
        function obj = presetGeneratorParentNoBounds(presetA_in, presetB_in, presetC_in)
            if nargin < 3
            error('Not enough Input Presets')
            end
            
            if nargin == 3
                
                assert(isequal(length(presetA_in), length(presetB_in), length(presetC_in))...
                    ,'Presets A, B, C must be of equal Length');
                
                assert(isnumeric(presetA_in),'Value must be numeric')
                
                obj.presetA = presetA_in;
                obj.presetB = presetB_in;
                obj.presetC = presetC_in;
                
                obj.presetAHistory = presetA_in;
                obj.presetBHistory = presetB_in;
                obj.presetCHistory = presetC_in;
                
                obj.presetMix = presetA_in;
            end
        end
        
        function obj = mixPresets(obj,alpha,beta,gamma)
            obj.presetMix = mixPresets(obj.presetA, obj.presetB, obj.presetC,...
                alpha,beta,gamma);
        end
        
        function obj = iteratePresets(obj)
            % Update preset A value
            obj.presetA = obj.presetMix;
            
            % Call Virtual method to generate new B and C
            obj = obj.generateNewBC();
            
            % Save presets to history
            obj.presetAHistory = [obj.presetAHistory; obj.presetA];
            obj.presetBHistory = [obj.presetBHistory; obj.presetB];
            obj.presetCHistory = [obj.presetCHistory; obj.presetC];
        end

    end
    methods (Abstract)
        generateNewBC(obj)
    end
end