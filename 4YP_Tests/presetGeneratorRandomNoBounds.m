classdef presetGeneratorRandomNoBounds < presetGeneratorParentNoBounds
    % Generates new presets B & C based on past values of chosen presets

    properties(Access = private)
    end
    methods
        % Constructor
        function obj = presetGeneratorRandomNoBounds(presetA_in, presetB_in, presetC_in)
            obj@presetGeneratorParentNoBounds(presetA_in, presetB_in, presetC_in);
        end
   
    end
    methods 
        function obj = generateNewBC(obj)  
           % Alternate version is to completely ramdoly generate B & C
                    presetBtemp = rand(1,length(obj.presetA));
                    presetCtemp = rand(1,length(obj.presetA));
                    
                    obj.presetB = presetBtemp;
                    obj.presetC = presetCtemp;
                    
                    %obj.presetB = checkLowInHighIn(presetBtemp);
                    %obj.presetC = checkLowInHighIn(presetCtemp);
            
        end
    end

end