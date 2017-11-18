function [newIndex, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree]...
    = addNewNodeToTrees(index, value, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree)

% Add a new data point and update all trees
[vector_tree, newIndex] = vector_tree.addnode(index, value);
sum_tree = sum_tree.addnode(index, sum_tree.get(index) + vector_tree.get(newIndex));
P1 = sum_tree.get(index);
P2 = sum_tree.get(newIndex);
plot_tree = plot_tree.addnode(index, plot([P1(1), P2(1)], [P1(2), P2(2)],'LineWidth',3, 'PickableParts','none'));
plot_markers_tree = plot_markers_tree.addnode(index, plot(P2(1), P2(2), 'ro','MarkerSize',12,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback, newIndex}, 'PickableParts','all'));
value_tree = value_tree.addnode(index, rand());
text_tree = text_tree.addnode(index, text(P2(1), P2(2), ['  ', num2str(value_tree.get(newIndex))], 'PickableParts','none'));
end