classdef presetGeneratorSCRandom < presetGeneratorSCParent
    % Generates new presets B & C based on past values of chosen presets

    properties(Access = private)
    end
    methods
        % Constructor
        function obj = presetGeneratorSCRandom(presetA_in, presetB_in, presetC_in)
            obj@presetGeneratorSCParent(presetA_in, presetB_in, presetC_in);
        end
   
    end
    methods 
        function obj = generateNewBC(obj)  
           % completely ramdoly generate B & C
            for i = 1: length(obj.presetA)
                obj.presetB{i} = rand(1,length(obj.presetA{i}));
                obj.presetC{i} = rand(1,length(obj.presetA{i}));
            end
        end
        
    end

end