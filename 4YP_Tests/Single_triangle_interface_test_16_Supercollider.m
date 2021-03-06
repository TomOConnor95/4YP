% Test script for preset blending interface
%close all
%% Create Initial Presets and related data structures
%Ptest = createPresetsForImageEditing();


%% Option parameters
savePresetsToFile = true;

%% Miscellaneous parameters
MOUSE = [0,0];              % Variable for mouse position to be stored in
isBlending = true;          % Is UI in blending mode?
isPressed = false;          % Has mouse been pressed?
isButtonPressed = false;    % Has push button been pressed?
isSearching = true;
isBeginBlending = false;
currentGeneration = 1;
screenSize = get(0,'Screensize');


%% Open UDP connection
u = udp('127.0.0.1',57120); 
fopen(u); 

%% Choose initial presets
[presetA, nameStrings, typeStrings] = createPresetAforOSC();

presetB = createPresetBforOSC();
presetC = createPresetCforOSC();


% [presetA, presetB, presetC] = loadPresetsFromStore(4,9,7);
 %[presetA, presetB, presetC] = loadPresetsFromStoreRandom();
P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC);

sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
%set(gcf,'Position',[(screenSize(3)/2),0,screenSize(3)/2,screenSize(4)])

%% Create all necessary parameters visualisations
 figure(3)
% [barA, barB, barC, barMix] = createBarGraphs(P.presetA,P.presetB,P.presetC);

barPlotPMparams =  bar3(reshape(P.presetA{1},6,6));
for k = 1:length(barPlotPMparams)
    zdata = barPlotPMparams(k).ZData;
    barPlotPMparams(k).CData = zdata;
    barPlotPMparams(k).FaceColor = 'interp';
    colormap(cool)
end
set(gca,'Xdir','reverse')
zlim([0,5])
%% Create plots to show evolution of parameters and Mouse Points
figure(2) 
subplot(2,7,[4,5,11,12])
%historyPlot = createStructHistoryPlot(P.presetAHistory);

subplot(2,7,[6,7,13,14])
P1HistoryPlot = createPointHistoryPlot(G.P1History);
set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2,screenSize(4)/2.3])

%% Main Loop
figure(1)

pause()
G.pauseText.Visible = 'off';
% Currently if you click during the paused time it will trigger the
% callback and cause a bug

while(isSearching)
    
    pause(0.01)
    %% Press button to save final image and quit program
    if isButtonPressed == true
        %isBlending = false;
        %isPressed = false;
        %isSearching = false;
        isButtonPressed = false;
        
        % Revert to last clicked preset
        
        
        if savePresetsToFile == true
            presetSave = matfile('PresetStore2.mat','Writable',true);
            presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
        end
        % Plot full size final output in new figure
        continue
    end
    %% If mouse is clicked move to the next generation of presets
    if isPressed == true
        currentGeneration = currentGeneration + 1;
        % Generate new presets
        P = P.iteratePresets();
        
        % Update plot to show evolution of parameters
        %historyPlot = updatePresetHistoryPlot(historyPlot,P.presetAHistory);
        
        % Update Plot showing Point History
        G.P1Sum = G.P1Sum + G.P1;
        G.P1History = [G.P1History, G.P1Sum];
        P1HistoryPlot = updatePointHistoryPlot(P1HistoryPlot,G.P1History);
        
        % Update Bar plots
        %[barA, barB, barC] = updateBarPlots(barA,barB,barC,P.presetA,P.presetB,P.presetC);
        
        isPressed = false;
        %isBlending = true;
    end
    %%  Live Preset Blending Step
    if isBlending == true
        G.P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if ~isequal(G.P1,G.P1current)
            
            G = updateGeometry(G);
            
            [alpha,beta,gamma] = calculatePresetRatios(G);
            
            P = P.mixPresets(alpha,beta,gamma);

            %barMix = updateMixBarPLot(barMix, P.presetMix);
            barPlotPMparams =  updateBarPlotPMparams(barPlotPMparams, reshape(P.presetMix{1}, 6, 6));
            
          
            
            sendAllStructParamsOverOSC(P.presetMix, nameStrings, typeStrings, u);
            
            drawnow()
            
        end
    end
    
end

%% Close UDP Connection
fclose(u);
