function G = correctlyColourFreezeButtons(G, P)
    % Corretly Colour blending UI Buttons based on frozen state
    
    if P.isTimeFrozen
        G.but_freeze_time.BackgroundColor =  P.timeColour; 
    else
        G.but_freeze_time.BackgroundColor =  G.normalButtonColour; 
    end

    if P.isTimbreFrozen
        G.but_freeze_timbre.BackgroundColor =  P.timbreColour; 
    else
        G.but_freeze_timbre.BackgroundColor =  G.normalButtonColour; 
    end
end