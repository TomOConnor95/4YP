classdef (Abstract) presetGeneratorParent
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
        
        historyPlot
        P1HistoryPlot
    end
    methods
        % Constructor
        function obj = presetGeneratorParent(presetA_in, presetB_in, presetC_in)
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
                
                obj.presetAHistory = tree(presetA_in);
                obj.presetBHistory = tree(presetB_in);
                obj.presetCHistory = tree(presetC_in);
                
                obj.currentTreeIndex = 1;
                
                obj.presetMix = presetA_in;
            end
            
            % set up history plots
            screenSize = get(0,'Screensize');
            figure(3)
            subplot(1,2,1)
            obj.historyPlot = createHistoryPlot(obj.presetAHistory);
            
            subplot(1,2,2)
            obj.P1HistoryPlot = createPointHistoryPlot();
            
            set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2.4,screenSize(4)/2.5])

        end
        
        function obj = mixPresets(obj,alpha,beta,gamma)
            obj.presetMix = mixPresets(obj.presetA, obj.presetB, obj.presetC,...
                alpha,beta,gamma);
            obj.presetMix = bound(obj.presetMix,0,1);  % return preset values bounded between 0 and 1
            
        end
        
        function obj = iteratePresets(obj, mousePointClicked)
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
            
            % update all trees for point history plot
            obj.P1HistoryPlot = updatePointHistoryPlot(obj.P1HistoryPlot,mousePointClicked, oldIndex, newIndex);
            
            % Update plot to show evolution of parameters
            obj.historyPlot = updatePresetHistoryPlot(obj.historyPlot,obj.presetAHistory);
        end
        
        function obj = switchPresets(obj, switchIndex)
            
            oldIndex = obj.currentTreeIndex;
            
            obj.P1HistoryPlot = resetColourOfOldMarker(obj.P1HistoryPlot, oldIndex);
            obj.P1HistoryPlot = switchColourOfNewMarker(obj.P1HistoryPlot, switchIndex);
            
            obj.currentTreeIndex = switchIndex;

            obj.presetA = obj.presetAHistory.get(switchIndex);
            obj.presetB = obj.presetBHistory.get(switchIndex);
            obj.presetC = obj.presetCHistory.get(switchIndex);
        end

    end
    methods (Abstract)
        generateNewBC(obj)
    end
end