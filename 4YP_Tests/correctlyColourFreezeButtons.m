function G = correctlyColourFreezeButtons(G, P)
    % Corretly Colour blending UI Buttons based on frozen state
    
    if P.isForegroundFrozen
        G.but_freeze_foreground.BackgroundColor =  P.foregroundColour; 
    else
        G.but_freeze_foreground.BackgroundColor =  G.normalButtonColour; 
    end

    if P.isBackgroundFrozen
        G.but_freeze_background.BackgroundColor =  P.backgroundColour; 
    else
        G.but_freeze_background.BackgroundColor =  G.normalButtonColour; 
    end
end