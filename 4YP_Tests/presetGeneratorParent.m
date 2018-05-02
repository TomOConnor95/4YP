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
        
        isForegroundFrozen
        isBackgroundFrozen
        
        foregroundFrozenNode
        backgroundFrozenNode
        
        foregroundIndexMask
        backgroundIndexMask
        
        lineColour
        foregroundColour
        backgroundColour
        normalColour
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
%             figure(3)
%             subplot(1,2,1)
%             obj.historyPlot = createHistoryPlot(obj.presetAHistory);
%             
%             subplot(1,2,2)
%             obj.P1HistoryPlot = createPointHistoryPlot();
            
            set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2.4,screenSize(4)/2.5])

            % Set up freezing (fore/back)ground
            obj.isForegroundFrozen = false;
            obj.isBackgroundFrozen = false;
            obj.foregroundFrozenNode = 0; 
            obj.backgroundFrozenNode = 0;
            
            obj.foregroundIndexMask = [ones(1,15), zeros(1,3), 1];
            obj.backgroundIndexMask = 1 - obj.foregroundIndexMask;
            
            obj.foregroundColour = [0.94, 0.6, 0.6];
            obj.backgroundColour = [0.94, 0.94, 0.6];
            obj.normalColour = [0.4,0.5,0.9];
            
            obj.lineColour = obj.normalColour;
        end
        
        function obj = mixPresets(obj,alpha,beta,gamma)
            presetMixTemp = mixPresets(obj.presetA, obj.presetB, obj.presetC,...
                alpha,beta,gamma);
            presetMixTemp = bound(presetMixTemp,0,1);  % return preset values bounded between 0 and 1
            
            if obj.isForegroundFrozen
                obj.presetMix = obj.presetA.*obj.foregroundIndexMask + ...
                                presetMixTemp.*obj.backgroundIndexMask;
            elseif obj.isBackgroundFrozen
                obj.presetMix = obj.presetA.*obj.backgroundIndexMask + ...
                                presetMixTemp.*obj.foregroundIndexMask;
            else
                obj.presetMix = presetMixTemp;
            end
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
            
%             % update all trees for point history plot
%             obj.P1HistoryPlot = updatePointHistoryPlot(obj.P1HistoryPlot,mousePointClicked, oldIndex, newIndex, obj.lineColour);
%             
%             % Update plot to show evolution of parameters
%             obj.historyPlot = updatePresetHistoryPlot(obj.historyPlot,obj.presetAHistory);
        end
        
        function obj = switchPresets(obj, switchIndex)
            
            assert(switchIndex <= nnodes(obj.presetAHistory), 'Invalid Index');
            
            oldIndex = obj.currentTreeIndex;
            
            obj.P1HistoryPlot = resetColourOfOldMarker(obj.P1HistoryPlot, oldIndex);
            obj.P1HistoryPlot = switchColourOfNewMarker(obj.P1HistoryPlot, switchIndex);
            
            obj.currentTreeIndex = switchIndex;
            
            if obj.isForegroundFrozen
                obj.presetA = obj.presetAHistory.get(obj.foregroundFrozenNode).*obj.foregroundIndexMask + ...
                               obj.presetAHistory.get(switchIndex).*obj.backgroundIndexMask;
                           
                obj.P1HistoryPlot = drawDottedLineBetweenNodes(obj.P1HistoryPlot,...
                        obj.foregroundFrozenNode, switchIndex, obj.foregroundColour);
                
            elseif obj.isBackgroundFrozen
                obj.presetA = obj.presetAHistory.get(obj.backgroundFrozenNode).*obj.backgroundIndexMask + ...
                               obj.presetAHistory.get(switchIndex).*obj.foregroundIndexMask;
                
                obj.P1HistoryPlot = drawDottedLineBetweenNodes(obj.P1HistoryPlot,...
                        obj.backgroundFrozenNode, switchIndex, obj.backgroundColour);
                    
            else
                obj.presetA = obj.presetAHistory.get(switchIndex);
            end
            
            obj.presetB = obj.presetBHistory.get(switchIndex);
            obj.presetC = obj.presetCHistory.get(switchIndex);
        end
        
        function obj = combineSelectedPresets(obj, presetsDoubleClicked)
            
            % Branch the tree from the first node double clicked
            oldIndex = presetsDoubleClicked(1);
            
            obj.presetA = obj.presetAHistory.get(presetsDoubleClicked(1));
            obj.presetB = obj.presetAHistory.get(presetsDoubleClicked(2));
            obj.presetC = obj.presetAHistory.get(presetsDoubleClicked(3));
            
            [obj.presetAHistory, newIndex] = obj.presetAHistory.addnode(oldIndex, obj.presetA);
            [obj.presetBHistory] = obj.presetBHistory.addnode(oldIndex, obj.presetB);
            [obj.presetCHistory] = obj.presetCHistory.addnode(oldIndex, obj.presetC);
            
            obj.currentTreeIndex = newIndex;
            
%             % update all trees for point history plot - Specialised 
%             obj.P1HistoryPlot = updatePointHistoryPlotCombinePresets(obj.P1HistoryPlot, oldIndex, newIndex, presetsDoubleClicked);
%             
%             % Update plot to show evolution of parameters
%             obj.historyPlot = updatePresetHistoryPlot(obj.historyPlot,obj.presetAHistory);
        end
        
        %-----Functions to freeze Foreground/Background -------------------
        
        function obj = freezeForeground(obj)
            obj.isForegroundFrozen = true;
            
            if obj.isBackgroundFrozen
                obj.isBackgroundFrozen = false;
            end
            
            obj.lineColour = obj.foregroundColour;
            
            obj.foregroundFrozenNode = obj.currentTreeIndex;
            % Potential bug here if foreground unfrozen then refrozen
            % Could solve by keeping a tree syaing whether each node was
            % frozen or not
            
        end
        
        function obj = freezeBackground(obj)
            obj.isBackgroundFrozen = true;
            
            if obj.isForegroundFrozen
                obj.isForegroundFrozen = false;
            end
            
            obj.lineColour = obj.backgroundColour;
            
            obj.backgroundFrozenNode = obj.currentTreeIndex;
            % Potential bug here if foreground unfrozen then refrozen
            
        end
        
        function obj = unfreezeForeground(obj)
            obj.isForegroundFrozen = false;
            
            obj.lineColour = obj.normalColour;
            obj.P1HistoryPlot.frozenLine.Visible = 'off';
            obj.presetA = obj.presetAHistory.get(obj.currentTreeIndex);
        end
        
        function obj = unfreezeBackground(obj)
            obj.isBackgroundFrozen = false;
            
            obj.lineColour = obj.normalColour;
            obj.P1HistoryPlot.frozenLine.Visible = 'off';
            obj.presetA = obj.presetAHistory.get(obj.currentTreeIndex);

        end
        
        function obj = toggleForegroundState(obj)
            if obj.isForegroundFrozen
                obj = obj.unfreezeForeground();
            else
                obj = obj.freezeForeground();
            end
        end
        
        function obj = toggleBackgroundState(obj)
            if obj.isBackgroundFrozen
                obj = obj.unfreezeBackground();
            else
                obj = obj.freezeBackground();
            end
        end
        
        
    end
    methods (Abstract)
        generateNewBC(obj)
    end
end