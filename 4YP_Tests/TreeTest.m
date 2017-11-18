% Tree test - see http://tinevez.github.io/matlab-tree/index.html

vector_tree = tree([0,0]);

%% Layer 1
[vector_tree, n1] = vector_tree.addnode(1, [1,2]);
[vector_tree, n2] = vector_tree.addnode(1, [-1,3]);
[vector_tree, n3] = vector_tree.addnode(1, [2,1]);
disp(vector_tree.tostring)

%% Layer 2

[vector_tree, n11] = vector_tree.addnode(n1, [1,2]);
[vector_tree, n12] = vector_tree.addnode(n1, [0,1]);
[vector_tree, n13] = vector_tree.addnode(n1, [-1,1]);

[vector_tree, n21] = vector_tree.addnode(n2, [-1,2]);
[vector_tree, n22] = vector_tree.addnode(n2, [1,-1]);
[vector_tree, n23] = vector_tree.addnode(n2, [2,1]);

[vector_tree, n31] = vector_tree.addnode(n3, [1,2]);
[vector_tree, n32] = vector_tree.addnode(n3, [-1,0.5]);
[vector_tree, n33] = vector_tree.addnode(n3, [2,1]);

disp(vector_tree.tostring)

%% Breadth first iterator
bf_order = tree(vector_tree, 'clear');
iterator = vector_tree.breadthfirstiterator;
index = 1;
for i = iterator
    bf_order = bf_order.set(i, index);
    index = index + 1;
end
disp(bf_order.tostring)

%% create tree of vector sums 
sum_tree = tree(vector_tree, [0,0]);
iterator = vector_tree.breadthfirstiterator;
for i = iterator(2:length(iterator))
    sum_tree = sum_tree.set(i,...
        sum_tree.get(sum_tree.getparent(i)) + vector_tree.get(i));
end
disp(sum_tree.tostring)

%% Create plot of tree
figure(5);
clf
set(gca,'color',[0.7 0.9 1])
hold on
plot_tree = tree(vector_tree, 'clear');
iterator = vector_tree.breadthfirstiterator;
for i = iterator(2:length(iterator))
    P1 = sum_tree.get(sum_tree.getparent(i));
    P2 = sum_tree.get(i);
    plot_tree = plot_tree.set(i, plot([P1(1), P2(1)], [P1(2), P2(2)],'LineWidth', 3, 'PickableParts','none'));
end

%% Add markers to tree plot
plot_markers_tree = tree(vector_tree, 'clear');
child_handles = allchild(gca);
set(child_handles,'HitTest','off')

iterator = vector_tree.breadthfirstiterator;
for i = iterator
    P = sum_tree.get(i);
    plot_markers_tree = plot_markers_tree.set(i, plot(P(1), P(2), 'ro','MarkerSize',12,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback, i}, 'PickableParts','all'));
end

%% values to store in tree
value_tree = tree(vector_tree, 0);
text_tree = tree(vector_tree, 0);
iterator = vector_tree.breadthfirstiterator;

for i = iterator
    value_tree = value_tree.set(i, rand());
    P = sum_tree.get(i);
    text_tree = text_tree.set(i, text(P(1) + 0.1, P(2), num2str(value_tree.get(i)), 'PickableParts','none'));
end

%% Add a new data point and update all trees
[vector_tree, n111] = vector_tree.addnode(n11, [0,2]);
sum_tree = sum_tree.addnode(n11, sum_tree.get(n11) + vector_tree.get(n111));
P1 = sum_tree.get(n11);
P2 = sum_tree.get(n111);
plot_tree = plot_tree.addnode(n11, plot([P1(1), P2(1)], [P1(2), P2(2)],'LineWidth',3,'PickableParts','none'));
plot_markers_tree = plot_markers_tree.addnode(n11, plot(P2(1), P2(2), 'ro','MarkerSize',12,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback, n111}, 'PickableParts','all'));
value_tree = value_tree.addnode(n11, rand());
text_tree = text_tree.addnode(n11, text(P2(1), P2(2), ['  ', num2str(value_tree.get(n111))], 'PickableParts','none'));

%% Add a new data point and update all trees using function
[newIndex, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree]...
    = addNewNodeToTrees(n11, [-1,1.5], vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree);
