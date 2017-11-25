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

	\envAmpADSR, ~envAmpADSR_B,
	\envAmpCurve, ~envAmpCurve_B,

	\env1ADSR, ~env1ADSR_B,
	\env1Curve, ~env1Curve_B,

	\lfo1Rate, ~lfo1Rate_B,
	\lfo1Amp, ~lfo1Amp_B,
	\lfo1PhaseSpread, ~lfo1PhaseSpread_B,

	\lfo2Rate, ~lfo2Rate_B,
	\lfo2Amp, ~lfo2Amp_B,
	\lfo2PulseWidth, ~lfo2PulseWidth_B,


	\stereoSpread, ~stereoSpread_B,
	\lfoMix, ~lfoMix,
	\lfoPulseWidth, ~lfoPulseWidth
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
