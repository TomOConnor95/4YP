classdef presetGeneratorSCMonteCarloMV < presetGeneratorSCParent
    % Generates new presets B & C based on past values of chosen presets

    properties(Access = private)
        % Generator Parameters
        initialTempOffset;
        tempOffset;
        tempScaling;
        stdExponent
        sigmoidCenterRatio;
        lastValueWeighting; % Between 0 and 1
        presetStoreCovariance;
    end
    methods
        % Constructor
        function obj = presetGeneratorSCMonteCarloMV(presetA_in, presetB_in, presetC_in, appData_in, initialTempOffset_in, tempScaling_in, lastValueWeighting_in)
            obj@presetGeneratorSCParent(presetA_in, presetB_in, presetC_in, appData_in);
            
            if nargin < 5
            % Set Generator Parameters
            obj.initialTempOffset = 0.01;
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
            
            for i=1:12
                presetStore = obj.appData.pcaAppData.presetStore;
                obj.presetStoreCovariance{i} = cov(presetStore{i});
            end
        end
   
    end
    methods 
        function obj = generateNewBC(obj)  
            % Generate new B & C with multivariate normal distribution
            
            for i = 1:length(obj.presetA)
                
                if i == 1
                weights = sigmoidWeights(length(obj.presetAHistory{1}.Node(:,1)), obj.sigmoidCenterRatio);
                end
            
                historyArray = cell2mat(obj.presetAHistory{i}.Node);
                
                newPresetsMean = (obj.lastValueWeighting*obj.presetA{i} + (1-obj.lastValueWeighting)*weights*historyArray);

                % Covariance matrix
                sigma = diag(zeros(1,length(historyArray(1,:)))+std(historyArray).^obj.stdExponent + obj.tempOffset)...
                            + 0.2*(obj.presetStoreCovariance{i});

                sigma = obj.tempScaling * sigma;         %.*randn(1,length(obj.presetA));
                % Multivarite Normal distrubution samples
                obj.presetB{i} = mvnrnd(newPresetsMean,sigma);
                obj.presetC{i} = mvnrnd(newPresetsMean,sigma);

            end
             % Decay tempOffset
            obj.tempOffset = obj.tempOffset*0.9;
            %disp(obj.tempOffset)
      
        end
    end
end