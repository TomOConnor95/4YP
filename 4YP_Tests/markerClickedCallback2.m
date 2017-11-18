function markerClickedCallback2(src,~, index)

    disp(['Index: ',num2str(index), ' CLICKED']);

%     for i = 1:nnodes(plot_markers_tree)
%         marker = plot_markers_tree.get(i);
%         marker.MarkerFaceColor = 'r';
%         plot_markers_tree = plot_markers_tree.set(i, marker);
%     end

    src.Color = rand(1,3);
    src.MarkerFaceColor = [0, 1, 1];
    %src.MarkerFaceColor = [.8 .6 .6];

    assignin('base','isMarkerClicked',true);
    assignin('base','markerIndex',index);

    
end