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
        
        isTimeFrozen
        isTimbreFrozen
        
        timeFrozenNode
        timbreFrozenNode
        
        toggledIndeces
        
        timeIndeces
        timbreIndeces
        allIndeces
        unfrozenIndeces
        
        lineColour
        timeColour
        timbreColour
        normalColour
        
        nameStrings
        typeStrings
        
        appData
    end
    methods
        % Constructor
        function obj = presetGeneratorSCParent(presetA_in, presetB_in, presetC_in, appData_in)
            if nargin < 4
            error('Not enough Input Presets')
            end
            
            if nargin == 4
                
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
            
            obj.appData = appData_in;

            % set up history plots
            %screenSize = get(0,'Screensize');
            figure(1)
%             set(figure(3), 'MenuBar', 'none', 'ToolBar' ,'none')
%             clf
            %subplot(1,2,1)
            %obj.historyPlot = createStructHistoryPlot(obj.presetAHistory);
            
            %subplot(1,2,2)
            obj.P1HistoryPlot = createPointHistoryPlot(obj.appData);
            
            %set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2.4,screenSize(4)/2.5])

            % Set up freezing time/timbre
            obj.isTimeFrozen = false;
            obj.isTimbreFrozen = false;
            obj.timeFrozenNode = 0; 
            obj.timbreFrozenNode = 0;
            
            obj.timbreIndeces = 1:7;
            obj.timeIndeces = 8:12;
            obj.allIndeces = 1:12;
            
            obj.unfrozenIndeces = obj.allIndeces;
            
            obj.toggledIndeces = [];
            
            obj.timeColour = [0.94, 0.6, 0.6];
            obj.timbreColour = [0.94, 0.94, 0.6];
            obj.normalColour = [0.4,0.5,0.9];
            
            obj.lineColour = obj.normalColour;
        end
        
        function obj = mixPresets(obj,alpha,beta,gamma)
            for i = obj.unfrozenIndeces
                obj.presetMix{i} = mixPresets(obj.presetA{i}, obj.presetB{i}, obj.presetC{i},...
                    alpha,beta,gamma);
            end
            
            % Apply any necessary parameter constraints
            % Should make a function out of this!!!
            obj.presetMix{1} = bound(obj.presetMix{1}, 0, 10);
            obj.presetMix{2} = mapToFreqCoarse(obj.presetMix{2});
            obj.presetMix{3} = bound(obj.presetMix{3}, 0, 10);
            obj.presetMix{4} = bound(obj.presetMix{4}, 0, 10);
            obj.presetMix{5} = bound(obj.presetMix{5}, 0, 10);
            obj.presetMix{6} = bound(obj.presetMix{6}, 0, 10);
            obj.presetMix{7} = bound(obj.presetMix{7}, 0, 10);
            obj.presetMix{8}(1:2) = bound(obj.presetMix{8}(1:2), 0.001, 40);
            obj.presetMix{8}(3) = bound(obj.presetMix{8}(3), 0, 1);
            obj.presetMix{9}(1:2) = bound(obj.presetMix{9}(1:2), 0.001, 40);
            obj.presetMix{9}(3) = bound(obj.presetMix{9}(3), 0, 1);
            obj.presetMix{10}(1:4) = bound(obj.presetMix{10}(1:4), 0, 40);
            obj.presetMix{11}(1:4) = bound(obj.presetMix{11}(1:4), 0, 40);
            obj.presetMix{12} = bound(obj.presetMix{12}, 0.001, 40);
        end
        
        function obj = iteratePresets(obj, mousePointClicked)
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
            
            % Update blending plot, to show change
            set(obj.appData.G.ax,'color',[0.7 0.9 1] + [(rand(1,2)*0.2)-0.1,0] )
            
            % update all trees for point history plot
            obj.P1HistoryPlot = updatePointHistoryPlot(obj.P1HistoryPlot,mousePointClicked, oldIndex, newIndex, obj.lineColour, obj.appData);
            
            % Update plot to show evolution of parameters
            %obj.historyPlot = updateStructPresetHistoryPlot(obj.historyPlot,obj.presetAHistory);
              
            
        end

        function obj = switchPresets(obj, switchIndex)
            
            assert(switchIndex <= nnodes(obj.presetAHistory{1}), 'Invalid Index');
            
            oldIndex = obj.currentTreeIndex;
            
            obj.P1HistoryPlot = resetColourOfOldMarker(obj.P1HistoryPlot, oldIndex);
            obj.P1HistoryPlot = switchColourOfNewMarker(obj.P1HistoryPlot, switchIndex);
            
            obj.currentTreeIndex = switchIndex;
            
            for i = obj.unfrozenIndeces
                obj.presetA{i} = obj.presetAHistory{i}.get(switchIndex);
            end
            if obj.isTimeFrozen
                for i = obj.timeIndeces
                obj.presetA{i} = obj.presetAHistory{i}.get(obj.timeFrozenNode);
                end
                
                obj.P1HistoryPlot = drawDottedLineBetweenNodes(obj.P1HistoryPlot,...
                        obj.timeFrozenNode, switchIndex, obj.timeColour);
            end
            
            if obj.isTimbreFrozen
                for i = obj.timbreIndeces
                obj.presetA{i} = obj.presetAHistory{i}.get(obj.timbreFrozenNode);
                end
                
                obj.P1HistoryPlot = drawDottedLineBetweenNodes(obj.P1HistoryPlot,...
                        obj.timbreFrozenNode, switchIndex, obj.timbreColour);
                
            end    
            
            for i = obj.allIndeces
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
            obj.P1HistoryPlot = updatePointHistoryPlotCombinePresets(obj.P1HistoryPlot, oldIndex, newIndex, presetsDoubleClicked, obj.appData);
            
            % Update plot to show evolution of parameters
            %obj.historyPlot = updateStructPresetHistoryPlot(obj.historyPlot,obj.presetAHistory);
        end
        
        %-----Functions to freeze Time/Timbre -----------------------------
        function obj = setFreezeSectionsToggled(obj, toggledSections)

            obj.toggledIndeces = nonzeros((toggledSections).*(1:12))';
            
            obj = setUnfrozenIndeces(obj);
            %obj.unfrozenIndeces = setdiff(obj.unfrozenIndeces, toggledIndeces);
            
        end
        
        function obj = setUnfrozenIndeces(obj)
           
            % Account for time/timbre buttons
            if obj.isTimbreFrozen
                obj.unfrozenIndeces = obj.timeIndeces;
            elseif obj.isTimeFrozen
                obj.unfrozenIndeces = obj.timbreIndeces;
            else
                obj.unfrozenIndeces = obj.allIndeces;
            end
            
            % Account for toggle Buttons
            obj.unfrozenIndeces = setdiff(obj.unfrozenIndeces, obj.toggledIndeces);
            
            
        end
        
        function obj = freezeTime(obj)
            obj.isTimeFrozen = true;
            
            if obj.isTimbreFrozen
                obj.isTimbreFrozen = false;
            end
                        
            obj = setUnfrozenIndeces(obj);
            
            %obj.unfrozenIndeces = obj.timbreIndeces;
            
            
            % ensure time is set to that of presetA
            for i = obj.timeIndeces
                obj.presetMix{i} = obj.presetA{i};
            end
            
            obj.lineColour = obj.timeColour;
            obj.timeFrozenNode = obj.currentTreeIndex;
            % Potential bug here if time unfrozen then refrozen
            
        end
        
        function obj = freezeTimbre(obj)
            obj.isTimbreFrozen = true;
            
            if obj.isTimeFrozen
                obj.isTimeFrozen = false;
            end
            
            obj = setUnfrozenIndeces(obj);
            %obj.unfrozenIndeces = obj.timeIndeces;
            
            % ensure timbre is set to that of presetA
            for i = obj.timbreIndeces
                obj.presetMix{i} = obj.presetA{i};
            end
            
            obj.lineColour = obj.timbreColour;
            obj.timbreFrozenNode = obj.currentTreeIndex;
            % Potential bug here if timbre unfrozen then refrozen
            
        end
        
        function obj = unfreezeTime(obj)
            obj.isTimeFrozen = false;
            
            obj = setUnfrozenIndeces(obj);
            %obj.unfrozenIndeces = obj.allIndeces;
            
            for i = obj.timeIndeces
                obj.presetMix{i} = obj.presetA{i};
            end
            
            obj.lineColour = obj.normalColour;
            obj.P1HistoryPlot.frozenLine.Visible = 'off';
        end
        
        function obj = unfreezeTimbre(obj)
            obj.isTimbreFrozen = false;
            
            obj = setUnfrozenIndeces(obj);
            %obj.unfrozenIndeces = obj.allIndeces;
            
            for i = obj.timbreIndeces
                obj.presetMix{i} = obj.presetA{i};
            end
            
            obj.lineColour = obj.normalColour;
            obj.P1HistoryPlot.frozenLine.Visible = 'off';
        end
        
        function obj = toggleTimeState(obj)
            if obj.isTimeFrozen
                obj = obj.unfreezeTime();
            else
                obj = obj.freezeTime();
            end
        end
        
        function obj = toggleTimbreState(obj)
            if obj.isTimbreFrozen
                obj = obj.unfreezeTimbre();
            else
                obj = obj.freezeTimbre();
            end
        end
        
    end
    
    methods (Abstract)
        generateNewBC(obj)
    end
end