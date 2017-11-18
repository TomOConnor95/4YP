classdef (Abstract) presetGeneratorSCParent
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
        function obj = presetGeneratorSCParent(presetA_in, presetB_in, presetC_in)
            if nargin < 3
            error('Not enough Input Presets')
            end
            
            if nargin == 3
                
                assert(isequal(length(presetA_in), length(presetB_in), length(presetC_in))...
                    ,'Presets A, B, C must be of equal Length');
                
                %assert(isnumeric(presetA_in),'Value must be numeric')
                
                obj.presetA = presetA_in;
                obj.presetB = presetB_in;
                obj.presetC = presetC_in;
                
                for i = 1: length(obj.presetA)
                obj.presetAHistory{i} = presetA_in{i};
                obj.presetBHistory{i} = presetB_in{i};
                obj.presetCHistory{i} = presetC_in{i};
                end
                
                obj.presetMix = presetA_in;
            end
        end
        
        function obj = mixPresets(obj,alpha,beta,gamma)
            for i = 1: length(obj.presetA)
                obj.presetMix{i} = mixPresets(obj.presetA{i}, obj.presetB{i}, obj.presetC{i},...
                    alpha,beta,gamma);
            end
            
            % Apply any necessary parameter constraints
            obj.presetMix{2} = mapToFreqCoarse(obj.presetMix{2});
            
        end
        
        function obj = iteratePresets(obj)
            % Update preset A value
            obj.presetA = obj.presetMix;
            
            % Call Virtual method to generate new B and C
            obj = obj.generateNewBC();
            
            % Save presets to history
            for i = 1: length(obj.presetA)
            obj.presetAHistory{i} = [obj.presetAHistory{i}; obj.presetA{i}];
            obj.presetBHistory{i} = [obj.presetBHistory{i}; obj.presetB{i}];
            obj.presetCHistory{i} = [obj.presetCHistory{i}; obj.presetC{i}];
            end
        end

    end
    methods (Abstract)
        generateNewBC(obj)
    end
end