(
SynthDef(\FM7_Synth, {
	arg out = 0, freq = 440, gate = 1,  amp = 1,

	outputLevels = #[1,1,1,1,1,1],
	bend;

	var env1, env2, env3, env4, env5, env6;
    var ctls, mods, snd, fmChannels;

	// amp.linlin(0,1,1,0.5)* use this for making the attack dependant on input velocity
	env1 = EnvGen.ar(Env.adsr(0.101, 1.25, 0.9, 1.54, curve: \lin), gate);
    env2 = EnvGen.ar(Env.adsr(0.101, 1.00, 0.9, 0.77, curve: \lin), gate);
    env3 = EnvGen.ar(Env.adsr(0.101, 1.50, 0.9, 0.54, curve: \lin), gate);
    env4 = EnvGen.ar(Env.adsr(0.101, 1.50, 0.9, 0.44, curve: \lin), gate);
	env5 = EnvGen.ar(Env.adsr(0.101, 1.25, 0.9, 0.54, curve: \lin), gate);
    env6 = EnvGen.ar(Env.adsr(0.101, 1.00, 0.9, 0.54, curve: \lin), gate);


		// delay to use should be the maximum value of release of any of the operators
		// Ie [R1, R2, R3...].maxItem

	freq = freq * bend.midiratio;

    ctls = [
        // freq, phase, amp
        [freq, 0, env1],
        [1.001*freq, 0, env2],
        [0.501*freq, 0, env3],
        [0.5*freq, 0, env4],
        [2*freq, 0, env5],
        [4*freq, 0, env6]
    ];
    mods = [
        [0, 1, 4, 0, 3, -3],    //MouseY.kr(0, 6)
        [0.1, 0, 3, 0, 3, -3],
        [0, 0, 0, 0, 0, 0],
        [0 , 2, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1]
    ];

    fmChannels = FM7.ar(ctls, mods) ;


	fmChannels[0] = fmChannels[0] * outputLevels[0];
	fmChannels[1] = fmChannels[1] * outputLevels[1];
	fmChannels[2] = fmChannels[2] * outputLevels[2];
	fmChannels[3] = fmChannels[3] * outputLevels[3];
	fmChannels[4] = fmChannels[4] * outputLevels[4];
	fmChannels[5] = fmChannels[5] * outputLevels[5];

	snd = Mix(fmChannels)!2 * (-24.dbamp) * amp;

	//snd = Mix(fmChannels)* (-24.dbamp);
	//snd = Pan2.ar(snd, pan, amp);

	DetectSilence.ar(snd, doneAction:2);
	Out.ar(out, snd);
}).add;
)

s.boot;
x = Synth(\FM7_Synth, [ \freq, 200.0, \gate, 1, \outputLevels, #[0.5,1,0.5,2,0.3,0]]);
x.set(\gate, 0);

(

MIDIClient.init;
MIDIIn.connect(0);
// how to deal with midi polyphony
~notes = Array.newClear(128);
~bend = 8192;


MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn,].postln;
	~notes[nn] = Synth.new(
		\FM7_Synth,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.2,1),
			\gate, 1,
			\bend, ~bend.linlin(0,16383, -2, 2),
			\outputLevels, #[1,1,0,0,0,0]
	]
	);
});

MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	[vel, nn,].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});


MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0,16383,-2,2))}
});
)

s.plotTree;