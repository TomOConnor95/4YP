function correctlyEnableDisableEditModeButton(appData)
%Correctly Enable/Disable Edit Mode Button
% Reqire a preset to be selected for button to be enabled

if (length(appData.idxSelected) + length(appData.combinedMarkersSelected)) > 0
    if isequal(appData.editModeButton.Enable, 'off')
        appData.editModeButton.Enable = 'on';
    end
else
    if isequal(appData.editModeButton.Enable, 'on')
        appData.editModeButton.Enable = 'off';
    end
end
end