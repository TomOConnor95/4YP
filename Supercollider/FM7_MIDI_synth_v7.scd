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

~env1ADSR_B = Bus.control(s,4);
~env1Curve_B = Bus.control(s,1);

~lfo1Rate_B = Bus.control(s,1);
~lfo1Amp_B = Bus.control(s,1);
~lfo1PhaseSpread_B = Bus.control(s,1);

~lfo2Rate_B = Bus.control(s,1);
~lfo2Amp_B = Bus.control(s,1);
~lfo2PulseWidth_B = Bus.control(s,1);

~stereoSpread_B = Bus.control(s,1);


SynthDef(\FM7_Synth, {
	arg out = 0, freq = 440, gate = 1,  amp = 1,  bend = 0,

	//---------------------------------------------------------
	// Input ParameterS
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


	// Envelope Parameters
	env1ADSR = #[2, 0.45, 0.9, 0.54],
	env1Curve = 0,

	envAmt = #[0.00, 0.70, 0.40, 0.00, 0.00, 0.00],
	lfoADepth = #[0.50, 0.40, 0.30, 0.50, 0.00, 0.00],

	// LFO parameters
	lfo1Rate = 2, lfo1Amp = 0.2, lfo1PhaseSpread = 0.2, // Would be cool to have RateSpread
	lfo2Rate = 4, lfo2Amp = 0.2, lfo2PulseWidth = 0.5, // Would be cool to have RateSpread

	// Global Modifier Parameters
	stereoSpread = 0.2,
	lowPassCutOff = 20000,
	lowPassRes = 0.1;

	// LFOs usually have range -1 - 1, but I've included offset of 1. therefore max LFOamp = 1

	//---------------------------------------------------------
	// Set-up
	//---------------------------------------------------------
	// Variables
	var envA, envAmp;
	var env1, env2, env3, env4, env5, env6;
	var lfo1;
	var lagTime = 0.1;
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

		[freq * Lag2.kr(freqCoarse[0],lagTime) * freqFine[0].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[0], (1-envAmt[0])), MulAdd(LFPulse.kr(lfo2Rate, 0, lfo2PulseWidth, 2*((lfo2Amp*lfoADepth[0]).clip(0,0.99)),(1-((lfo2Amp*lfoADepth[0]).clip(0,0.99)))),LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[1],1), 0), 0)],

		[freq * Lag2.kr(freqCoarse[1],lagTime) * freqFine[1].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[1], (1-envAmt[1])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[1],1), 0)],
		[freq * Lag2.kr(freqCoarse[2],lagTime) * freqFine[2].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[2], (1-envAmt[2])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[2],1), 0)],
		[freq * Lag2.kr(freqCoarse[3],lagTime) * freqFine[3].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[3], (1-envAmt[3])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[3],1), 0)],
		[freq * Lag2.kr(freqCoarse[4],lagTime) * freqFine[4].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[4], (1-envAmt[4])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[4],1), 0)],
		[freq * Lag2.kr(freqCoarse[5],lagTime) * freqFine[5].linlin(0,1,1,2), 0, MulAdd(MulAdd(envA, envAmt[5], (1-envAmt[5])), LFTri.kr(lfo1Rate, rand(0,lfo1PhaseSpread), lfo1Amp*lfoADepth[5],1), 0)]

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

	snd = Splay.ar(fmChannels, Lag2.kr(stereoSpread, lagTime)) * (-12.dbamp) * amp * envAmp;

	DetectSilence.ar(snd, doneAction:2);
	Out.ar(out, snd);
}).add;
)

(
// Set default params for busses
~freqCoarse_B.set(1.0, 0.5, 2.0, 2.0, 3.0, 3.0);
~freqFine_B.set(0.0, 0.01, 0.0, 0.0, 0.0, 0.0);
~outputLevels_B.set(0.5,0.3,0.0,0.0,0.0,0.0);

	~op1PM_B.set(0.0, 0.2, 0.2, 0.3, 0.0, 0.0);
	~op2PM_B.set(0.0, 0.0, 0.0, 1.0, 0.0, 0.0);
	~op3PM_B.set(0.0, 0.0, 0.0, 0.0, 1.0, 1.0);
	~op4PM_B.set(0.0, 0.0, 1.0, 0.0, 0.0, 0.0);
	~op5PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	~op6PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

	// Amp Envelope Parameters
	~envAmpADSR_B.set(0.1, 0.05, 0.9, 0.44);
	~envAmpCurve_B.set(0);
	~stereoSpread_B.set(0.0);

	// Envelope Parameters
	~env1ADSR_B.set(0.1, 0.1, 0.9, 0.1);
~env1Curve_B.set(0);

	~envAmt_B.set(0.00, 0.70, 0.40, 0.00, 0.00, 0.00);
~lfoADepth_B.set(0.2, 0.40, 0.30, 0.50, 1.00, 1.00);

	// LFO parameters
~lfo1Rate_B.set(2);
~lfo1Amp_B.set(0.99);
~lfo1PhaseSpread_B.set(0.0);

~lfo2Rate_B.set(1.5);
~lfo2Amp_B.set(0.6);
~lfo2PulseWidth_B.set(0.5);
)

{ var depth = 0.4; LFPulse.ar(200, 0, 0.2, LFPulse.kr(1, 0, 0.5, 2*depth, (1-depth))) }.play;

{var lfo2Amp =0.9; var envAmp = 1.0; var freq = 10; SinOsc.ar(500, 0, MulAdd(MulAdd(EnvGen.ar(Env.perc), envAmp, (1-envAmp)), LFPulse.kr(freq, 0, 0.5, 2*lfo2Amp,(1-lfo2Amp)), 0))}.play;



//{ LFSaw.ar(500, 1, 0.1) }.play

// used as both Oscillator and LFO:
//{ LFSaw.ar(LFSaw.kr(4, 0, 200, 400), 0, 0.1) }.play
