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
        
        historyPlot
        P1HistoryPlot
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
            
            % set up history plots
            screenSize = get(0,'Screensize');
            figure(3)
            clf
            subplot(1,2,1)
            obj.historyPlot = createStructHistoryPlot(obj.presetAHistory);
            
            subplot(1,2,2)
            obj.P1HistoryPlot = createPointHistoryPlot();
            
            set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2.4,screenSize(4)/2.5])

            
        end
        
        function obj = mixPresets(obj,alpha,beta,gamma)
            for i = 1: length(obj.presetA)
                obj.presetMix{i} = mixPresets(obj.presetA{i}, obj.presetB{i}, obj.presetC{i},...
                    alpha,beta,gamma);
            end
            
            % Apply any necessary parameter constraints
            obj.presetMix{2} = mapToFreqCoarse(obj.presetMix{2});
            
        end
        
        function obj = iteratePresets(obj, mousePointClicked, lineColour)
            % Update preset A value
            obj.presetA = obj.presetMix;
            
            % Call Virtual method to generate new B and C
            obj = obj.generateNewBC();
            
            
            % Save presets to history
            oldIndex = obj.currentTreeIndex;
            for i = 1:length(obj.presetA)
                if i == 1
                    [obj.presetAHistory{i}, newIndex] = obj.presetAHistory{i}.addnode(obj.currentTreeIndex, obj.presetA{i});
                else
                    obj.presetAHistory{i} = obj.presetAHistory{i}.addnode(oldIndex, obj.presetA{i});
                end
                obj.presetBHistory{i} = obj.presetBHistory{i}.addnode(oldIndex, obj.presetB{i});
                obj.presetCHistory{i} = obj.presetCHistory{i}.addnode(oldIndex, obj.presetC{i});
            end
            obj.currentTreeIndex = newIndex;
            
            % update all trees for point history plot
            if nargin <3
                obj.P1HistoryPlot = updatePointHistoryPlot(obj.P1HistoryPlot,mousePointClicked, oldIndex, newIndex);
            else
                obj.P1HistoryPlot = updatePointHistoryPlot(obj.P1HistoryPlot,mousePointClicked, oldIndex, newIndex, lineColour);
            end
            % Update plot to show evolution of parameters
            obj.historyPlot = updateStructPresetHistoryPlot(obj.historyPlot,obj.presetAHistory);

        end

        function obj = switchPresets(obj, switchIndex)
            
            assert(switchIndex <= nnodes(obj.presetAHistory{1}), 'Invalid Index');
            
            oldIndex = obj.currentTreeIndex;
            
            obj.P1HistoryPlot = resetColourOfOldMarker(obj.P1HistoryPlot, oldIndex);
            obj.P1HistoryPlot = switchColourOfNewMarker(obj.P1HistoryPlot, switchIndex);
            
            obj.currentTreeIndex = switchIndex;
            
            for i = 1:length(obj.presetA)
                obj.presetA{i} = obj.presetAHistory{i}.get(switchIndex);
                obj.presetB{i} = obj.presetBHistory{i}.get(switchIndex);
                obj.presetC{i} = obj.presetCHistory{i}.get(switchIndex);
            end
        end
        
        function obj = combineSelectedPresets(obj, presetsDoubleClicked)
            
            % Branch the tree from the first node double clicked
            oldIndex = presetsDoubleClicked(1);
            
            for i = 1:length(obj.presetA)
                obj.presetA{i} = obj.presetAHistory{i}.get(presetsDoubleClicked(1));
                obj.presetB{i} = obj.presetAHistory{i}.get(presetsDoubleClicked(2));
                obj.presetC{i} = obj.presetAHistory{i}.get(presetsDoubleClicked(3));
                
                if i == 1
                    [obj.presetAHistory{i}, newIndex] = obj.presetAHistory{i}.addnode(oldIndex, obj.presetA{i});
                else
                    obj.presetAHistory{i} = obj.presetAHistory{i}.addnode(oldIndex, obj.presetA{i});
                end
                
                obj.presetBHistory{i} = obj.presetBHistory{i}.addnode(oldIndex, obj.presetB{i});
                obj.presetCHistory{i} = obj.presetCHistory{i}.addnode(oldIndex, obj.presetC{i});
            end
            obj.currentTreeIndex = newIndex;
            
            % update all trees for point history plot - Specialised 
            obj.P1HistoryPlot = updatePointHistoryPlotCombinePresets(obj.P1HistoryPlot, oldIndex, newIndex, presetsDoubleClicked);
            
            % Update plot to show evolution of parameters
            obj.historyPlot = updateStructPresetHistoryPlot(obj.historyPlot,obj.presetAHistory);
        end
    end
    
    methods (Abstract)
        generateNewBC(obj)
    end
end