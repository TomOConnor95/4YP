function doodle
hf = figure;
ha = axes('units','normalized','position',[0,0,1,1],...
        'XLim',[0,1],'XTick',[],'YLim',[0,1],'YTick',[]);
set(hf,'WindowButtonDownFcn',@startdraw)
uiwait(hf)
      function startdraw(src,~)
          set(src,'pointer','crosshair')
          cp = get(ha,'CurrentPoint');
          xinit = cp(1,1); yinit = cp(1,2);
          hl = line('XData',xinit,'YData',yinit,...
              'color','k','linewidth',2);
          set(src,'WindowButtonMotionFcn',@movedraw)
          set(src,'WindowButtonUpFcn',@enddraw)
          function movedraw(~,~)
              cp = get(ha,'CurrentPoint');
              xdat = [get(hl,'XData'),cp(1,1)];
              ydat = [get(hl,'YData'),cp(1,2)];
              set(hl,'XData',xdat,'YData',ydat);
              drawnow
          end
          function enddraw(src,~)
              set(src,'Pointer','arrow')
              set(src,'WindowButtonMotionFcn',[])
              set(src,'WindowButtonUpFcn',[])
              uiresume(hf)
          end
      end
end