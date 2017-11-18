% Tree test - see http://tinevez.github.io/matlab-tree/index.html

figure(5);
clf
set(gca,'color',[0.7 0.9 1])
hold on

vector_tree = tree([0,0]);
sum_tree = tree([0,0]);
value_tree = tree(rand());
text_tree = tree(text(0.0 + 0.1, 0.0, num2str(value_tree.get(1)), 'PickableParts','none'));

plot_tree = tree('clear');
plot_markers_tree = tree(plot(0,0, 'ro','MarkerSize',12,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback, 1, value_tree.get(1)}, 'PickableParts','all'));

%% Add a new random data point and update all trees using function
for i = 1:15
    
[newIndex, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree]...
    = addNewNodeToTrees(randi(nnodes(vector_tree)), (randn(1,2) + [0,0.9]), vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree);

end

%% Hide all labels
for i = 1:nnodes(value_tree)
   label = text_tree.get(i);
   label.Visible = 'off';
   text_tree = text_tree.set(i, label);
    
end

%% Show all labels
for i = 1:nnodes(value_tree)
   label = text_tree.get(i);
   label.Visible = 'on';
   text_tree = text_tree.set(i, label);
    
end

%% Add a new data point and update all trees using function
[newIndex, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree]...
    = addNewNodeToTrees(newIndex, [-1,1.5], vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree);

