ServerOptions.outDevices
ServerOptions.devices


// Get the local server's options

o = Server.local.options;

// specify a device

o.device ="Soundflower (2ch)";     // use a specific soundcard
o.device = nil;            // use the system default soundcard
// reboot server
s.reboot


(
{
var modulator, carrier;
modulator = SinOsc.kr(MouseX.kr(2,20), 0, 0.4);
carrier = SinOsc.ar(333, 0, modulator);
carrier!2 // the output
}.play
)
 