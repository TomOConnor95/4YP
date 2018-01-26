figure(2)

clf
hold on
appData = ApplicationDataUITest();

f1 = fill([0,0,1,1,0],[0,1,1,0,0],'r');
f2 = fill([1,1,2,2,1],[1,2,2,1,1],'b');
set(f1, 'ButtonDownFcn', {@f1Test,appData});
set(f2, 'ButtonDownFcn', {@f2Test,appData});
%f2.ButtonDownFcn = @f2Test(appData);

ax = gca;
fig = gcf;
ax.Position = [0.1300 0.2100 0.7750 0.7150];


% Slider
slider = uicontrol('style', 'slider',...
    'string', 'Knob1',...
    'units', 'normalized',...
    'position', [0.75 0 0.25 0.11],...
    'callback', {@sliderCallback},...
    'visible', 'on',...
    'FontSize', 13);



knob1 = uiknob(fig, 'continuous');
knob1.Limits = [0 1];
knob1.ValueChangingFcn = createCallbackFcn(app, @Osc1Knob_2ValueChanging, true);
knob1.Position = [40 538 46 46];


function f1Test (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('f1 Clicked')

appData.f1Pressed = true;


end

function f2Test (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('f2 Clicked')

appData.f2Pressed = true;

end

function sliderCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('slider')

appData.f2Pressed = true;

end


