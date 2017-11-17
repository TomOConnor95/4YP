% Sends a Open Sound Control (OSC) message through a UDP connection
% 
% oscsend(u,path) 
% oscsend(u,path,types,arg1,arg2,...) 
% oscsedn(u,path,types,[args])
% 
% u = UDP object with open connection. 
% path = path-string 
% types = string with types of arguments, 
% supported: 
% i = integer 
% f = float 
% s = string 
% N = Null (ignores corresponding argument) 
% I = Impulse (ignores corresponding argument) 
% T = True (ignores corresponding argument) 
% F = False (ignores corresponding argument) 
% B = boolean (not official: converts argument to T/F in the type) 
% not supported: 
% b = blob
% 
% args = arguments as specified by types.

% %% EXAMPLE 1
% u = udp('127.0.0.1',57120); 
% fopen(u); 
% oscsend(u,'/main','ifsINBTF', 1, 3.14, 'hello',[],[],false,[],[]); 
% fclose(u);

% EXAMPLE 2
u = udp('127.0.0.1',57120); 
fopen(u); 
oscsend(u,'/main','fff', 2,0.0,0); 
fclose(u);

