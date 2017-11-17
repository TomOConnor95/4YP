(
SynthDef(\FM7_Synth, {
	arg out = 0, freq = 440, gate = 1,  amp = 1,  bend,

	//---------------------------------------------------------
	// Input Parameters
	//---------------------------------------------------------

	// Operator frequency ratios
	// FreqCoarse is multiple of base frequency, [0.5, 1, 2, 3, 4, 5 ,...]
	// FreqFine ranges continuously from -1 to 1, and maps to [*0.5, *1.5] ??
	op1freqCoarse = 1.0, op1freqFine = 0,
	op2freqCoarse = 0.5, op2freqFine = 0,
	op3freqCoarse = 2.0, op3freqFine = 0,
	op4freqCoarse = 2.0, op4freqFine = 0,
	op5freqCoarse = 3.0, op5freqFine = 0,
	op6freqCoarse = 3.0, op6freqFine = 0,

	// Operator amplitudes post Modulation
	outputLevels = #[0.5,0.0,0.0,0.0,0.0,0.0],

	// Amplitude Modulation Parameters
	// [EnvelopeAmmount, EnvelopeBlend, LFO1Depth, LFO2Depth]
	op1AM = #[0.0, 0.0, 0.0, 0.0],
	op2AM = #[0.0, 0.0, 0.0, 0.0],
	op3AM = #[0.0, 0.0, 0.0, 0.0],
	op4AM = #[0.0, 0.0, 0.0, 0.0],
	op5AM = #[0.0, 0.0, 0.0, 0.0],
	op6AM = #[0.0, 0.0, 0.0, 0.0],

	// Phase Modulation Parameters
	// [x->1, x->2, x->3, x->4, x->5, x->6]
	op1PM = #[0.0, 1.0, 1.0, 0.0, 0.0, 0.0],
	op2PM = #[0.0, 0.0, 0.0, 1.0, 0.0, 1.0],
	op3PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 1.0],
	op4PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	op5PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	op6PM = #[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],

	// Amp Envelope Parameters
	envAmpADSR = #[0.05, 0.25, 0.9, 1.54], envAmpCurve = 0,

	// Envelope Parameters
	env1ADSR = #[0.101, 1.25, 0.9, 1.54], env1Curve = 0,
	// env1A = 0.901, env1D = 1.25, env1S = 0.901, env1R = 1.54, env1Curve = 0,
	env2ADSR = #[2.101, 3.25, 0.9, 1.54], env2Curve = 0,

	envAmt1 = 1.0, envBlend1 = 0.9,
	envAmt2 = 0.0, envBlend2 = 0.5,
	envAmt3 = 0.0, envBlend3 = 0.5,
	envAmt4 = 0.0, envBlend4 = 0.5,
	envAmt5 = 0.0, envBlend5 = 0.5,
	envAmt6 = 0.0, envBlend6 = 0.5,

	// LFO parameters
	lfo1Rate = 1, lfo1Amp = 0.9,
	lfo2Rate = 2, lfo2Amp = 0.0;
	// LFOs usually have rabge -1 - 1, but I've included offset of 1. therefore max LFOamp = 1

	//---------------------------------------------------------
	// Set-up
	//---------------------------------------------------------
	// Variables
	var envA, envB, envAmp;
	var env1, env2, env3, env4, env5, env6;
	var lfo1, lfo2;
	var lagTime = 0.03;
	var amp1, amp2, amp3, amp4, amp5, amp6;
    var ctls, mods, snd, fmChannels;

	//
	// var op1Env;
	// op1Env = Array.newClear(4);
	// op1Env[0] = ((1-envBlend1)*env1ADSR[0] + envBlend1*env2ADSR[0]);
	// op1Env[1] = ((1-envBlend1)*env1ADSR[1] + envBlend1*env2ADSR[1]);
	// op1Env[2] = ((1-envBlend1)*env1ADSR[2] + envBlend1*env2ADSR[2]); //+ (1-envAmt1),
	// op1Env[3] = ((1-envBlend1)*env1ADSR[3] + envBlend1*env2ADSR[3]); // +  (1-envAmt1)*4,

	// Envelopes         // amp.linlin(0,1,1,0.5)* use this for making the attack dependant on input velocity
	envAmp = EnvGen.ar(Env.adsr(envAmpADSR[0], envAmpADSR[1], envAmpADSR[2], envAmpADSR[3], curve: envAmpCurve), gate);

	env1 = EnvGen.kr(Env.adsr(env1ADSR[0], env1ADSR[1], env1ADSR[2], env1ADSR[3], curve: env1Curve), gate);
	env2 = EnvGen.kr(Env.adsr(env2ADSR[0], env2ADSR[1], env2ADSR[2], env2ADSR[3], curve: env2Curve), gate);
/*
	env1 = Mix([0.5*envA, 0.5*envB]);
	env2 = Mix([0.5*envA, 0.5*envB]);
	env3 = Mix([0.5*envA, 0.5*envB]);
	env4 = Mix([0.5*envA, 0.5*envB]);
	env5 = Mix([0.5*envA, 0.5*envB]);
	env6 = Mix([0.5*envA, 0.5*envB]);
	*/
/*	env1 = EnvGen.kr(Env.adsr( //envAmt1 *
		op1Env[0],
		op1Env[1],
		op1Env[2],
		op1Env[3],
		curve: ((1-envBlend1)*env1Curve + envBlend1*env2Curve)
	 ), gate);*/


	// LFOs
	// lfo1 = LFSaw.kr(lfo1Rate,0,lfo1Amp);
	//lfo2 = LFTri.ar(lfo2Rate,0,lfo2Amp);

	//lfo1 = Lag2.kr(LFSaw.kr(lfo1Rate), lfo1Amp);
	//lfo2 = Lag2.kr(LFTri.kr(lfo2Rate), lfo2Amp);

	// Apply AM
	 //amp1 = (1-op1AM[0]) + op1AM[0]*(op1AM[1]*env1 + (1-op1AM[1])*env2); + op1AM[2]*lfo1 + op1AM[3]*lfo2;
	// amp2 = (1-op2AM[0]) + op2AM[0]*(op2AM[1]*env1 + (1-op2AM[1])*env2) + op2AM[2]*lfo1 + op2AM[3]*lfo2;
	// amp3 = (1-op3AM[0]) + op3AM[0]*(op3AM[1]*env1 + (1-op3AM[1])*env2) + op3AM[2]*lfo1 + op3AM[3]*lfo2;
	// amp4 = (1-op4AM[0]) + op4AM[0]*(op4AM[1]*env1 + (1-op4AM[1])*env2) + op4AM[2]*lfo1 + op4AM[3]*lfo2;
	// amp5 = (1-op5AM[0]) + op5AM[0]*(op5AM[1]*env1 + (1-op5AM[1])*env2) + op5AM[2]*lfo1 + op5AM[3]*lfo2;
	// amp6 = (1-op6AM[0]) + op6AM[0]*(op6AM[1]*env1 + (1-op6AM[1])*env2) + op6AM[2]*lfo1 + op6AM[3]*lfo2;

	// bend base frequency with pitchbend data
	freq = freq * bend.midiratio;

	//---------------------------------------------------------
	// FM7 Ugen
	//---------------------------------------------------------


   ctls = [
        // freq, phase, amp

		[freq * op1freqCoarse * op2freqFine.linlin(0,1,0.5,1.5),
			0,
			Lag2.kr(
				LFSaw.kr(lfo1Rate,0,lfo1Amp*(
					LFTri.kr(lfo2Rate,0,
						env1
				)),1),


					/*	EnvGen.kr(
							Env.adsr(
								env1A, env1D, env1S, env1R,


								((1-envBlend1)*env1ADSR[0] + envBlend1*env2ADSR[0]),
								((1-envBlend1)*env1ADSR[1] + envBlend1*env2ADSR[1]),
								((1-envBlend1)*env1ADSR[2] + envBlend1*env2ADSR[2]),
								((1-envBlend1)*env1ADSR[3] + envBlend1*env2ADSR[3]),
								curve: env1Curve),
							gate),


						//((1-envAmt1) +(envAmt1*
						//((1-envBlend1)*env1 + envBlend1*env2),

						1)),lfo2Amp),
				*/


				lagTime)
		],



        [freq * op2freqCoarse * op2freqFine.linlin(0,1,0.5,1.5), 0, 1],
		[freq * op3freqCoarse * op3freqFine.linlin(0,1,0.5,1.5), 0, 1],
		[freq * op4freqCoarse * op4freqFine.linlin(0,1,0.5,1.5), 0, 1],
		[freq * op5freqCoarse * op5freqFine.linlin(0,1,0.5,1.5), 0, 1],
		[freq * op6freqCoarse * op6freqFine.linlin(0,1,0.5,1.5), 0, 1],

		//[freq * op1freqCoarse, 0, 1],
        //[freq * op2freqCoarse, 0, 1],
		//[freq * op3freqCoarse, 0, 1],
		//[freq * op4freqCoarse, 0, 1],
		//[freq * op5freqCoarse, 0, 1],
		//[freq * op6freqCoarse, 0, 1],
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

	snd = Mix(fmChannels)!2 * (-12.dbamp) * amp * envAmp;
	//var snd = Splay((fmChannels)!2 * (-12.dbamp) * amp, spreadAmmount);
	//snd = Mix(fmChannels)* (-24.dbamp);
	//snd = Pan2.ar(snd, pan, amp);

	DetectSilence.ar(snd, doneAction:2);
	Out.ar(out, snd);
}).add;
)

s.boot;
s.plotTree;
s.quit;

x = Synth(\FM7_Synth, [ \freq, 200.0, \gate, 1, ]);
x.set(\gate, 0)

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

a = [1,2,3,4,5];
a[0]'

~env1ADSR = #[0.901, 1.25, 0.9, 1.54];
~env1Curve = 0;
~env2ADSR = #[0.167, 1.25, 0.9, 1.54];
~env2Curve = 0;

~envAmt1 = 0.0;
~envBlend1 = 0.5;

(
~op1Env = [
	((1-~envBlend1)*~env1ADSR[0] + (~envBlend1*~env2ADSR[0])),
	5];
)