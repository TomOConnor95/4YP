
(
SynthDef(\FM7_Synth, {
	arg out = 0, freq = 440, gate = 1,  amp = 1,  bend = 0, stereoSpread = 0.2,

	//---------------------------------------------------------
	// Input Parameters
	//---------------------------------------------------------

	// Operator frequency ratios
	// FreqCoarse is multiple of base frequency, [0.5, 1, 2, 3, 4, 5 ,...]
	// FreqFine ranges continuously from 0 to 100, and maps to [*1, *2] ??
	op1freqCoarse = 1.0, op1freqFine = 0.0,
	op2freqCoarse = 0.5, op2freqFine = 0.1,
	op3freqCoarse = 2.0, op3freqFine = 0.0,
	op4freqCoarse = 2.0, op4freqFine = 0.0,
	op5freqCoarse = 3.0, op5freqFine = 0.0,
	op6freqCoarse = 3.0, op6freqFine = 0.0,

	// Operator amplitudes post Modulation
	outputLevels = #[0.5,0.5,0.0,0.0,0.0,0.0],


	// Phase Modulation Parameters
	// [x->1, x->2, x->3, x->4, x->5, x->6]
	op1PM = #[0.0, 1.0, 1.0, 0.0, 4.0, 0.2],
	op2PM = #[0.0, 0.0, 0.0, 1.0, 0.0, 1.0],
	op3PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 1.0],
	op4PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	op5PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	op6PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],

	// Amp Envelope Parameters
	envAmpADSR = #[0.3, 0.05, 0.9, 0.44], envAmpCurve = 0,

	// Envelope Parameters
	env1ADSR = #[2, 0.45, 0.9, 0.54], env1Curve = 0,

	envAmt1 = 0.00,  lfoADepth1 = 0.50,
	envAmt2 = 0.70,  lfoADepth2 = 0.40,
	envAmt3 = 0.40,  lfoADepth3 = 0.30,
	envAmt4 = 0.00,  lfoADepth4 = 0.50,
	envAmt5 = 0.00,  lfoADepth5 = 0.00,
	envAmt6 = 0.00,  lfoADepth6 = 0.00,

	// LFO parameters
	lfo1Rate = 2, lfo1Amp = 0.2 ,lfo1RateSpread = 0.1, lfo1PhaseSpread = 0.2;

	// LFOs usually have range -1 - 1, but I've included offset of 1. therefore max LFOamp = 1

	//---------------------------------------------------------
	// Set-up
	//---------------------------------------------------------
	// Variables
	var envA, envAmp;
	var env1, env2, env3, env4, env5, env6;
	var lfo1;
	var lagTime = 0.03;
	var amp1, amp2, amp3, amp4, amp5, amp6;
    var ctls, mods, snd, fmChannels;


	// Envelopes         // amp.linlin(0,1,1,0.5)* use this for making the attack dependant on input velocity
	//envAmpADSR[0] = envAmpADSR[0].linlin(0,1,1,0.5);
	envAmp = EnvGen.ar(Env.adsr(envAmpADSR[0], envAmpADSR[1], envAmpADSR[2], envAmpADSR[3], curve: envAmpCurve), gate);

	envA = EnvGen.kr(Env.adsr(env1ADSR[0], env1ADSR[1], env1ADSR[2], env1ADSR[3], curve: env1Curve), gate);

	/*  // Cant get mixing between multiple envelopes to work. But maybe not necessary
	env1 = MulAdd(Mix([MulAdd(envA, (1-envBlend1)), MulAdd(envB, envBlend1)]), envAmt1, (1-envAmt1));
	env2 = MulAdd(Mix([MulAdd(envA, (1-envBlend2)), MulAdd(envB, envBlend2)]), envAmt2, (1-envAmt2));
	env3 = MulAdd(Mix([MulAdd(envA, (1-envBlend3)), MulAdd(envB, envBlend3)]), envAmt3, (1-envAmt3));
	env4 = MulAdd(Mix([MulAdd(envA, (1-envBlend4)), MulAdd(envB, envBlend4)]), envAmt4, (1-envAmt4));
	env5 = MulAdd(Mix([MulAdd(envA, (1-envBlend5)), MulAdd(envB, envBlend5)]), envAmt5, (1-envAmt5));
	env6 = MulAdd(Mix([MulAdd(envA, (1-envBlend6)), MulAdd(envB, envBlend6)]), envAmt6, (1-envAmt6));
	*/

	// bend base frequency with pitchbend data
	freq = freq * bend.midiratio;

	//---------------------------------------------------------
	// FM7 Ugen
	//---------------------------------------------------------


   ctls = [
        // freq, phase, amp

		[freq * op1freqCoarse * op2freqFine.linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt1, (1-envAmt1)), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth1,1), 0)],
		[freq * op2freqCoarse * op2freqFine.linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt2, (1-envAmt2)), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth2,1), 0)],
		[freq * op3freqCoarse * op3freqFine.linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt3, (1-envAmt3)), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth3,1), 0)],
		[freq * op4freqCoarse * op4freqFine.linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt4, (1-envAmt4)), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth4,1), 0)],
		[freq * op5freqCoarse * op5freqFine.linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt5, (1-envAmt5)), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth5,1), 0)],
		[freq * op6freqCoarse * op6freqFine.linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt6, (1-envAmt6)), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth6,1), 0)]

    ];
   mods = [
		op1PM,
		op2PM,
		op3PM,
		op4PM,
		op5PM,
		op6PM
    ];

    fmChannels = FM7.ar(ctls, mods) ;

	fmChannels[0] = fmChannels[0] * outputLevels[0];
	fmChannels[1] = fmChannels[1] * outputLevels[1];
	fmChannels[2] = fmChannels[2] * outputLevels[2];
	fmChannels[3] = fmChannels[3] * outputLevels[3];
	fmChannels[4] = fmChannels[4] * outputLevels[4];
	fmChannels[5] = fmChannels[5] * outputLevels[5];

	snd = Splay.ar(fmChannels, stereoSpread) * (-12.dbamp) * amp * envAmp;

	DetectSilence.ar(snd, doneAction:2);
	Out.ar(out, snd);
}).add;
)

s.boot;
s.plotTree;
s.quit;

x = Synth(\FM7_Synth, [ \freq, 200.0, \gate, 1, ]);

x.set(\stereoSpread, 0.2)
x.set(\stereoSpread, 0.9)
x.set(\gate, 0)
x.set(\lfo1Rate, 1, \lfo1Amt, 0.3)



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
