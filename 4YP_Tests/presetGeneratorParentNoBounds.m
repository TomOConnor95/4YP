classdef (Abstract) presetGeneratorParentNoBounds
    % Generates new presets B & C based on past values of chosen presets
    properties
        presetA
        presetB
        presetC
        currentTreeIndex
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
                
                obj.currentTreeIndex = 1;
                
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
            oldIndex = obj.currentTreeIndex;
            [obj.presetAHistory, newIndex] = obj.presetAHistory.addnode(obj.currentTreeIndex, obj.presetA);
            [obj.presetBHistory] = obj.presetBHistory.addnode(oldIndex, obj.presetB);
            [obj.presetCHistory] = obj.presetCHistory.addnode(oldIndex, obj.presetC);
            obj.currentTreeIndex = newIndex;
        end

    end
    methods (Abstract)
        generateNewBC(obj)
    end
end