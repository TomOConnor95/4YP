function markerClickedCallback(src,~, index)
   src.Color = rand(1,3);
   disp(['Index: ',num2str(index), ' CLICKED']);
end