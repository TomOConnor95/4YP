classdef presetGeneratorMonteCarloMVNoBounds < presetGeneratorParentNoBounds
    % Generates new presets B & C based on past values of chosen presets

    properties(Access = private)
        % Generator Parameters
        initialTempOffset;
        tempOffset;
        tempScaling;
        stdExponent
        sigmoidCenterRatio;
        lastValueWeighting; % Between 0 and 1
    end
    methods
        % Constructor
        function obj = presetGeneratorMonteCarloMVNoBounds(presetA_in, presetB_in, presetC_in, initialTempOffset_in, tempScaling_in, lastValueWeighting_in)
            obj@presetGeneratorParentNoBounds(presetA_in, presetB_in, presetC_in);
            
            if nargin < 4
            % Set Generator Parameters
            obj.initialTempOffset = 0.1;
            obj.tempOffset = obj.initialTempOffset;
            obj.tempScaling = 0.4;
            obj.lastValueWeighting = 0.5;

            else 
            obj.initialTempOffset = initialTempOffset_in;
            obj.tempOffset = obj.initialTempOffset;
            obj.tempScaling = tempScaling_in;
            assert(lastValueWeighting_in >= 0 && lastValueWeighting_in <= 1);
            obj.lastValueWeighting = lastValueWeighting_in;
            end 
            obj.stdExponent = 1.5;
            obj.sigmoidCenterRatio = 0.5;
        end
   
    end
    methods 
        function obj = generateNewBC(obj)  
            % Generate new B & C
            
            historyArray = cell2mat(obj.presetAHistory.Node);
            
            weights = sigmoidWeights(length(historyArray(:,1)), obj.sigmoidCenterRatio);
            
            newPresetsMean = (obj.lastValueWeighting*obj.presetA + (1-obj.lastValueWeighting)*weights*historyArray);
            
            % Covariance matrix
            sigma = diag(zeros(1,length(historyArray(1,:)))+std(historyArray).^obj.stdExponent + obj.tempOffset);
            sigma = obj.tempScaling * sigma;         %.*randn(1,length(obj.presetA));
            % Multivarite Normal distrubution samples
            tempPresetB = mvnrnd(newPresetsMean,sigma);
            tempPresetC = mvnrnd(newPresetsMean,sigma);
%             % Try to make C somehow orthogonal to B
%             tempPresetC = tempPresetC - (obj.presetA - tempPresetB);
            
            obj.presetB = tempPresetB;
            obj.presetC = tempPresetC;
            
             % Decay tempOffset
            obj.tempOffset = obj.tempOffset*0.9;
            disp(obj.tempOffset)
      
        end
    end
end