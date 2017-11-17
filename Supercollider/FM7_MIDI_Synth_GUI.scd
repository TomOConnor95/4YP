(
Window.closeAll;
w = Window("nested", Rect(850, 650, 700, 700))
.front
.alwaysOnTop_(true);

//w.view.decorator_(FlowLayout(w.bounds, Point(15, 15), Point (7,7)));
w.view.decorator_(FlowLayout(w.bounds, 30@30, 30@30));

c = Array.fill(4, {
	arg view;
	view = CompositeView(w, 300@300)
	.background_(Color.rand);

	view.decorator_(FlowLayout(view.bounds, 15@15, 5@5));
});

6.do{
	var obj;

	c[0].decorator.gap_(5@5);
	Knob(c[0],40@40); // Coarse Frequency
	c[0].decorator.gap_(30@5);
	Knob(c[0],30@30); // Fine Frequency
	Knob(c[0],40@40); // Env Amount
	Knob(c[0],40@40); // LFO Amount
	c[0].decorator.nextLine;
};

Array.fill(36, {Knob(c[1], 40@40)}); // PM modulation matrix


Array.fill(6, {Slider(c[3], 40@100)}); // Output Levels of operators
	Knob(c[0],40@40); // Stereo Spread


)


c[0].children[2].value_(0.5);
c[1].children.collect(_.value_(0.75));
c[0].decorator.nextLine; 