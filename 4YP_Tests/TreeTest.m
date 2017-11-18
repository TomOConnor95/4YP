% Tree test - see http://tinevez.github.io/matlab-tree/index.html

vectorTree = tree([0,0]);

%% Layer 1
[vectorTree, n1] = vectorTree.addnode(1, [1,2]);
[vectorTree, n2] = vectorTree.addnode(1, [-1,3]);
[vectorTree, n3] = vectorTree.addnode(1, [2,1]);
disp(vectorTree.tostring)

%% Layer 2

[vectorTree, n11] = vectorTree.addnode(n1, [1,2]);
[vectorTree, n12] = vectorTree.addnode(n1, [0,1]);
[vectorTree, n13] = vectorTree.addnode(n1, [-1,1]);

[vectorTree, n21] = vectorTree.addnode(n2, [-1,2]);
[vectorTree, n22] = vectorTree.addnode(n2, [1,-1]);
[vectorTree, n23] = vectorTree.addnode(n2, [2,1]);

[vectorTree, n31] = vectorTree.addnode(n3, [1,2]);
[vectorTree, n32] = vectorTree.addnode(n3, [-1,0.5]);
[vectorTree, n33] = vectorTree.addnode(n3, [2,1]);

disp(vectorTree.tostring)

%% Breadth first iterator
bf_order = tree(vectorTree, 'clear');
iterator = vectorTree.breadthfirstiterator;
index = 1;
for i = iterator
    bf_order = bf_order.set(i, index);
    index = index + 1;
end
disp(bf_order.tostring)

%% create tree of vector sums 
sum_tree = tree(vectorTree, [0,0]);
iterator = vectorTree.breadthfirstiterator;
for i = iterator(2:length(iterator))
    sum_tree = sum_tree.set(i,...
        sum_tree.get(sum_tree.getparent(i)) + vectorTree.get(i));
end
disp(sum_tree.tostring)

%% Create plot of tree
figure(5);
clf
hold on
plot_tree = tree(vectorTree, 'clear');
iterator = vectorTree.breadthfirstiterator;
for i = iterator(2:length(iterator))
    P1 = sum_tree.get(sum_tree.getparent(i));
    P2 = sum_tree.get(i);
    plot_tree = plot_tree.set(i, plot([P1(1), P2(1)], [P1(2), P2(2)]));
end

%% Add markers to tree plot
plot_markers_tree = tree(vectorTree, 'clear');
child_handles = allchild(gca);
set(child_handles,'HitTest','off')

iterator = vectorTree.breadthfirstiterator;
for i = iterator
    P = sum_tree.get(i);
    plot_markers_tree = plot_markers_tree.set(i, plot(P(1), P(2), 'ro','MarkerSize',7,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback, i}, 'PickableParts','all'));
end

%% values to store in tree
value_tree = tree(vectorTree, 0);
text_tree = tree(vectorTree, 0);
iterator = vectorTree.breadthfirstiterator;

for i = iterator
    value_tree = value_tree.set(i, rand());
    P = sum_tree.get(i);
    text_tree = text_tree.set(i, text(P(1) + 0.1, P(2), num2str(value_tree.get(i)), 'PickableParts','none'));
end

%% Add a new data point and update all trees
[vectorTree, n111] = vectorTree.addnode(n11, [0,2]);
sum_tree = sum_tree.addnode(n11, sum_tree.get(n11) + vectorTree.get(n111));
P1 = sum_tree.get(n11);
P2 = sum_tree.get(n111);
plot_tree = plot_tree.addnode(n11, plot([P1(1), P2(1)], [P1(2), P2(2)]));
plot_markers_tree = plot_markers_tree.addnode(n11, plot(P2(1), P2(2), 'ro','MarkerSize',7,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback, n111}, 'PickableParts','all'));
value_tree = value_tree.addnode(n11, rand());
text_tree = text_tree.addnode(n11, text(P2(1), P2(2), ['  ', num2str(value_tree.get(n111))], 'PickableParts','none'));
