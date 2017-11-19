classdef (Abstract) presetGeneratorSCParent
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
                obj.presetAHistory{i} = tree(presetA_in{i});
                obj.presetBHistory{i} = tree(presetB_in{i});
                obj.presetCHistory{i} = tree(presetC_in{i});
                end
                
                obj.currentTreeIndex = 1;
                
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
            oldIndex = obj.currentTreeIndex;
            [obj.presetAHistory, newIndex] = obj.presetAHistory.addnode(obj.currentTreeIndex, obj.presetA);
            [obj.presetBHistory] = obj.presetBHistory.addnode(oldIndex, obj.presetB);
            [obj.presetCHistory] = obj.presetCHistory.addnode(oldIndex, obj.presetC);
            obj.currentTreeIndex = newIndex;
            
            % Save presets to history
            oldIndex = obj.currentTreeIndex;
            for i = 1: length(obj.presetA)
                if i == 1
                    [obj.presetAHistory{i}, newIndex] = obj.presetAHistory{i}.addnode(obj.currentTreeIndex, obj.presetA{i});
                else
                    obj.presetAHistory{i} = obj.presetAHistory{i}.addnode(oldIndex, obj.presetA{i});
                end
                obj.presetBHistory{i} = obj.presetBHistory{i}.addnode(oldIndex, obj.presetB{i});
                obj.presetCHistory{i} = obj.presetCHistory{i}.addnode(oldIndex, obj.presetC{i});
            end
            obj.currentTreeIndex = newIndex;
            
        end

    end
    methods (Abstract)
        generateNewBC(obj)
    end
end