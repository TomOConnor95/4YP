
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
~lfoBDepth_B = Bus.control(s,6);

~envAmpADSR_B = Bus.control(s,4);
~envAmpCurve_B = Bus.control(s,1);

~env1ADSR_B = Bus.control(s,4);
~env1Curve_B = Bus.control(s,1);

~lfoARate_B = Bus.control(s,1);
~lfoAAmp_B = Bus.control(s,1);
~lfoAPhaseSpread_B = Bus.control(s,1);

~lfoBRate_B = Bus.control(s,1);
~lfoBAmp_B = Bus.control(s,1);
~lfoBPulseWidth_B = Bus.control(s,1);

~stereoSpread_B = Bus.control(s,1);
~vibratoFreqStart_B = Bus.control(s,1);
~vibratoFreqEnd_B = Bus.control(s,1);
~vibratoAmtStart_B = Bus.control(s,1);
~vibratoAmtEnd_B = Bus.control(s,1);
~vibratoEnvTime_B = Bus.control(s,1);

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

	// Envelope Parameters
	env1ADSR = #[2, 0.45, 0.9, 0.54],
	env1Curve = 0,

	envAmt = #[0.00, 0.70, 0.40, 0.00, 0.00, 0.00],
	lfoADepth = #[0.50, 0.40, 0.30, 0.50, 0.00, 0.60],
	lfoBDepth = #[0.50, 0.40, 0.50, 0.50, 0.90, 0.00],

	// LFO parameters
	lfoARate = 2, lfoAAmp = 0.2, lfoAPhaseSpread = 0.2, // Would be cool to have RateSpread
	lfoBRate = 4, lfoBAmp = 0.2, lfoBPulseWidth = 0.5, // Would be cool to have RateSpread

	// Global Modifier Parameters
	stereoSpread = 0.2,
	vibratoFreqStart = 0.4,
	vibratoFreqEnd = 6.4,
	vibratoAmtStart = 0.5,
	vibratoAmtEnd = 4.0,
	vibratoEnvTime = 3.0;
	// Tri LFOs usually have range -1 - 1, but I've included offset of 1. therefore max LFOamp = 1

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

	// bend base frequency with pitchbend data
	freq = SinOsc.kr(
				XLine.kr(vibratoFreqStart, vibratoFreqEnd, vibratoEnvTime),
				0,
				XLine.kr(vibratoAmtStart, vibratoAmtEnd, vibratoEnvTime),
				freq * bend.midiratio);

	//---------------------------------------------------------
	// FM7 Ugen
	//---------------------------------------------------------

	ctls = Array.fill(6, { arg op;
		[freq * Lag2.kr(freqCoarse[op],lagTime) * freqFine[op].linlin(0,1,1,2),
		0,
		MulAdd(
			MulAdd(
				envA, envAmt[op], (1-envAmt[op])
				),
			MulAdd(
				LFTri.kr(
					lfoARate,
					rand(0,lfoAPhaseSpread),
					lfoAAmp*lfoADepth[op],1
					),
				LFPulse.kr(
					lfoBRate, 0, lfoBPulseWidth,
					2*((lfoBAmp*lfoBDepth[op]).clip(0,0.99)),
					(1-((lfoBAmp*lfoBDepth[op]).clip(0,0.99)))
					),
				0),
			0)
		]
	});

   	mods = [op1PM, op2PM, op3PM, op4PM, op5PM, op6PM];

	fmChannels = FM7.ar(ctls, mods) ;

	//---------------------------------------------------------
	// Mix Output Channels
	//---------------------------------------------------------

	6.do{
		arg op;
		fmChannels[op] = fmChannels[op] * outputLevels[op]
	};

	snd = Splay.ar(fmChannels, Lag2.kr(stereoSpread, lagTime)) * (-12.dbamp) * amp * envAmp;

	DetectSilence.ar(snd, doneAction:2);
	Out.ar(out, snd);
}).add;

// Set default params for busses
~freqCoarse_B.set(1.0, 0.5, 1.0, 2.0, 3.0, 3.0);
~freqFine_B.set(0.0, 0.01, 0.01, 0.0, 0.0, 0.0);
~outputLevels_B.set(0.6,0.5,0.0,0.2,0.0,0.0);

~op1PM_B.set(0.0, 0.9, 1.2, 0.3, 0.0, 0.0);
~op2PM_B.set(0.0, 0.0, 1.0, 1.0, 0.0, 0.0);
~op3PM_B.set(0.0, 0.0, 0.0, 0.0, 1.0, 1.0);
~op4PM_B.set(0.0, 0.0, 1.0, 0.0, 1.0, 0.0);
~op5PM_B.set(0.0, 0.0, 0.0, 0.0, 0.4, 0.0);
~op6PM_B.set(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

// Amp Envelope Parameters
~envAmpADSR_B.set(0.1, 0.05, 0.9, 0.44);
~envAmpCurve_B.set(0);
~stereoSpread_B.set(0.0);

// Envelope Parameters
~env1ADSR_B.set(0.1, 0.1, 0.9, 0.1);
~env1Curve_B.set(0);

~envAmt_B.set(0.00, 0.70, 0.40, 0.00, 0.00, 0.00);
~lfoADepth_B.set(0.0, 0.90, 0.90, 0.00, 0.80, 0.00);
~lfoBDepth_B.set(0.3, 0.40, 0.20, 0.50, 0.10, 0.90);

	// LFO parameters
~lfoARate_B.set(4);
~lfoAAmp_B.set(0.49);
~lfoAPhaseSpread_B.set(0.0);

~lfoBRate_B.set(5.0);
~lfoBAmp_B.set(0.9);
~lfoBPulseWidth_B.set(0.7);

// Global parameters
~vibratoFreqStart_B.set(0.4);
~vibratoFreqEnd_B.set(5.0);
~vibratoAmtStart_B.set(0.5);
~vibratoAmtEnd_B.set(3.0);
~vibratoEnvTime_B.set(1.5);


// MIDI setup ---------------------



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
	]
	).register;
	~notes[nn].map(
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
	\lfoBDepth, ~lfoBDepth_B,

	\envAmpADSR, ~envAmpADSR_B,
	\envAmpCurve, ~envAmpCurve_B,

	\env1ADSR, ~env1ADSR_B,
	\env1Curve, ~env1Curve_B,

	\lfoARate, ~lfoARate_B,
	\lfoAAmp, ~lfoAAmp_B,
	\lfoAPhaseSpread, ~lfoAPhaseSpread_B,

	\lfoBRate, ~lfoBRate_B,
	\lfoBAmp, ~lfoBAmp_B,
	\lfoBPulseWidth, ~lfoBPulseWidth_B,

	\stereoSpread, ~stereoSpread_B,
	\vibratoFreqStart, ~vibratoFreqStart_B,
	\vibratoFreqEnd, ~vibratoFreqEnd_B,
	\vibratoAmtStart, ~vibratoAmtStart_B,
	\vibratoAmtEnd, ~vibratoAmtEnd_B,
	\vibratoEnvTime, ~vibratoEnvTime_B

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



// OSC setup
// Using set for a particular synth doesnt work wel wilth Polyphony,
// Maybe better to have all params(Except the midi inputs) for the synth as global variables



OSCdef.new(
	\receiveFreqCoarse,
	{
		arg msg, time, addr, port;
		msg.postln;

			~freqCoarse_B.set(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6]
			);
	},
	'/freqCoarse'
);

OSCdef.new(
	\receiveFreqFine,
	{
		arg msg, time, addr, port;
		msg.postln;
		~freqFine_B.set(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6]);
	},
	'/freqFine'
);

OSCdef.new(
	\receivePMparams,
	{
		arg msg, time, addr, port;
		msg.postln;
		~op1PM_B.set(msg[1],   msg[2],   msg[3],   msg[4],   msg[5],   msg[6]);
		~op2PM_B.set(msg[7],   msg[8],   msg[9],   msg[10], msg[11], msg[12]);
		~op3PM_B.set(msg[13], msg[14], msg[15], msg[16], msg[17], msg[18]);
		~op4PM_B.set(msg[19], msg[20], msg[21], msg[22], msg[23], msg[24]);
		~op5PM_B.set(msg[25], msg[26], msg[27], msg[28], msg[29], msg[30]);
		~op6PM_B.set(msg[31], msg[32], msg[33], msg[34], msg[35], msg[36]);
	},
	'/PMparams'
);



OSCdef.new(
	\receiveOutputLevels,
	{
		arg msg, time, addr, port;
		msg.postln;
		~outputLevels_B.set(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6]);
	},
	'/outputLevels'
);

OSCdef.new(
	\receiveEnvAmt,
	{
		arg msg, time, addr, port;
		msg.postln;
		~envAmt_B.set(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6]);
	},
	'/envAmt'
);

OSCdef.new(
	\receiveLfoADepth,
	{
		arg msg, time, addr, port;
		msg.postln;
		~lfoADepth_B.set(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6]);
	},
	'/lfoADepth'
);

OSCdef.new(
	\receiveLfoBDepth,
	{
		arg msg, time, addr, port;
		msg.postln;
		~lfoBDepth_B.set(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6]);
	},
	'/lfoBDepth'
);

OSCdef.new(
	\receiveLfoAParams,
	{
		arg msg, time, addr, port;
		msg.postln;
		~lfoARate_B.set(msg[1]);
		~lfoAAmp_B.set(msg[2]);
		~lfoAPhaseSpread_B.set(msg[3]);
	},
	'/lfoAParams'
);

OSCdef.new(
	\receiveLfoBParams,
	{
		arg msg, time, addr, port;
		msg.postln;
		~lfoBRate_B.set(msg[1]);
		~lfoBAmp_B.set(msg[2]);
		~lfoBPulseWidth_B.set(msg[3]);
	},
	'/lfoBParams'
);

OSCdef.new(
	\receiveEnvAmpParams,
	{
		arg msg, time, addr, port;
		msg.postln;
		~envAmpADSR_B.set(msg[1], msg[2], msg[3], msg[4]);
		~envAmpCurve_B.set(msg[5]);
	},
	'/envAmpParams'
);

OSCdef.new(
	\receiveEnv1Params,
	{
		arg msg, time, addr, port;
		msg.postln;
		~env1ADSR_B.set(msg[1], msg[2], msg[3], msg[4]);
		~env1Curve_B.set(msg[5]);
	},
	'/env1Params'
);

OSCdef.new(
	\receiveMisc,
	{
		arg msg, time, addr, port;
		msg.postln;
		~stereoSpread_B.set(msg[1]);
		~vibratoFreqStart_B.set(msg[2]);
		~vibratoFreqEnd_B.set(msg[3]);
		~vibratoAmtStart_B.set(msg[4]);
		~vibratoAmtEnd_B.set(msg[5]);
		~vibratoEnvTime_B.set(msg[6]);
	},
	'/misc'
);
