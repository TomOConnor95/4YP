// Using set for a particular synth doesnt work wel wilth Polyphony,
// Maybe better to have all params(Except the midi inputs) for the synth as global variables

(

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
	\receiveLfoAParams,
	{
		arg msg, time, addr, port;
		msg.postln;
		~lfo1Rate_B.set(msg[1]);
		~lfo1Amt_B.set(msg[2]);
		~lfo1PhaseSpread_B.set(msg[3]);
	},
	'/LfoAParams'
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
		//~lowPassCutOff.set(msg[2].clip(100,20000));
		//~lowPassRes.set(msg[3].clip(0.001, 10));
	},
	'/misc'
);


)
