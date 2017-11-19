(
s.boot;
// Get the local server's options
o = Server.local.options;
// specify a device
//o.device ="JackRouter";     // use a JackOSX for audio output
o.device ="Built-In Output";
// reboot server
s.reboot;

// Create Control busses containing all of the default paramerters
~freqCoarse_B = Bus.control(s, 6);
~freqFine_B = Bus.control(s,6);

~outputLevels_B = Bus.control(s,6);

~op1PM_B = Bus.control(s,6);
~op2PM_B = Bus.control(s,6);
~op3PM_B = Bus.control(s,6);
~op4PM_B = Bus.control(s,6);
~op5PM_B = Bus.control(s,6);
~op6PM_B = Bus.control(s,6);

~envAmt_B = Bus.control(s,6);
~lfoADepth_B = Bus.control(s,6);

~envAmpADSR_B = Bus.control(s,4);
~envAmpCurve_B = Bus.control(s,1);
~stereoSpread_B = Bus.control(s,1);

~env1ADSR_B = Bus.control(s,4);
~env1Curve_B = Bus.control(s,1);

~lfo1Rate_B = Bus.control(s,1);
~lfo1Amp_B = Bus.control(s,1);
~lfo1PhaseSpread_B = Bus.control(s,1);
)

(
SynthDef(\FM7_Synth, {
	arg out = 0, freq = 440, gate = 1,  amp = 1,  bend = 0,

	//---------------------------------------------------------
	// Input Parameters
	//---------------------------------------------------------

	// Operator frequency ratios
	// FreqCoarse is multiple of base frequency, [0.5, 1, 2, 3, 4, 5 ,...]
	// FreqFine ranges continuously from 0 to 1, and maps to [*1, *2] ??
	freqCoarse = #[1.0, 0.5, 2.0, 2.0, 3.0, 3.0],
	freqFine = #[0.0, 0.1, 0.0, 0.0, 0.0, 0.0],

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
	envAmpADSR = #[0.3, 0.05, 0.9, 0.44],
	envAmpCurve = 0,
	stereoSpread = 0.2,

	// Envelope Parameters
	env1ADSR = #[2, 0.45, 0.9, 0.54],
	env1Curve = 0,

	envAmt = #[0.00, 0.70, 0.40, 0.00, 0.00, 0.00],
	lfoADepth = #[0.50, 0.40, 0.30, 0.50, 0.00, 0.00],

	// LFO parameters
	lfo1Rate = 2, lfo1Amp = 0.2, lfo1PhaseSpread = 0.2; // Would be cool to have RateSpread

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

		[freq * freqCoarse[0] * freqFine[0].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[0], (1-envAmt[0])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[0],1), 0)],
		[freq * freqCoarse[1] * freqFine[1].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[1], (1-envAmt[1])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[1],1), 0)],
		[freq * freqCoarse[2] * freqFine[2].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[2], (1-envAmt[2])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[2],1), 0)],
		[freq * freqCoarse[3] * freqFine[3].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[3], (1-envAmt[3])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[3],1), 0)],
		[freq * freqCoarse[4] * freqFine[4].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[4], (1-envAmt[4])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[4],1), 0)],
		[freq * freqCoarse[5] * freqFine[5].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[5], (1-envAmt[5])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[5],1), 0)]

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

~outputLevels_B.index


(
x = Synth(\FM7_Synth, [ \freq, 200.0, \gate, 1, ]).register;

x.map(
	\freqCoarse, ~freqCoarse_B,
	\freqFine, ~freqFine_B,
	\outputLevels, ~outputLevels_B,

	\op1PM, ~op1PM_B,
	\op2PM, ~op2PM_B,
	\op3PM, ~op3PM_B,
	\op4PM, ~op4PM_B,
	\op5PM, ~op5PM_B,
	\op6PM, ~op6PM_B,

	\envAmt, ~envAmt_B,
	\lfoADepth, ~lfoADepth_B,

	\envAmpADSR, ~envAmpADSR_B,
	\envAmpCurve, ~envAmpCurve_B,
	\stereoSpread, ~stereoSpread_B,

	\env1ADSR, ~env1ADSR_B,
	\env1Curve, ~env1Curve_B,

	\lfo1Rate, ~lfo1Rate_B,
	\lfo1Amp, ~lfo1Amp_B,
	\lfo1PhaseSpread, ~lfo1PhaseSpread_B
);

// Set default params for busses
~freqCoarse_B.set(1.0, 0.5, 2.0, 2.0, 3.0, 3.0);
~freqFine_B.set(0.0, 0.1, 0.0, 0.0, 0.0, 0.0);
~outputLevels_B.set(0.5,0.5,0.0,0.0,0.0,0.0);

	~op1PM_B.set(0.0, 1.0, 1.0, 0.0, 4.0, 0.2);
	~op2PM_B.set(0.0, 0.0, 0.0, 1.0, 0.0, 1.0);
	~op3PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 1.0);
	~op4PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	~op5PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	~op6PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

	// Amp Envelope Parameters
	~envAmpADSR_B.set(0.3, 0.05, 0.9, 0.44);
	~envAmpCurve_B.set(0);
	~stereoSpread_B.set(0.2);

	// Envelope Parameters
	~env1ADSR_B.set(2, 0.45, 0.9, 0.54);
~env1Curve_B.set(0);

	~envAmt_B.set(0.00, 0.70, 0.40, 0.00, 0.00, 0.00);
~lfoADepth_B.set(0.50, 0.40, 0.30, 0.50, 0.00, 0.00);

	// LFO parameters
~lfo1Rate_B.set(1);
~lfo1Amp_B.set(0.2);
~lfo1PhaseSpread_B.set(0.2);
)



x.set(\gate, 0);

x.set(\stereoSpread, 0.2);
x.set(\stereoSpread, 0.9);

x.set(\lfo1Rate, 1, \lfo1Amt, 0.3);
{
	var count;

x.set(\outputLevels, [0.5, 0.5, 0.1, 0.1, 0.5, 0.5]);


/*
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
