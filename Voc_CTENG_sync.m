% Synchronous recovery mode

clear;
chargeD = 20e-6; % charge density unit c/m^2
xmax = 25e-3; % max distance of air gap
n = 50; % repeat for n times
f1 = 2; % movement frequency of TENG
interval1 = 1000; % interval for the non-compression state
T1 = 1/f1; % one period
Tcpr = 0.01*T1; % time of compression
interval2 = 1000; % interval for the compression state
Cinitial = 50e-12; % initial capacitance of tribo-material 
Cfinal = 150e-12; % final capacitance of tribo-material

eps0 = 8.854e-12; % vaccum permittivity

[t, x, c, torigin, xorigin, corigin] = airgapANDcap_sync(xmax, f1, interval1, Tcpr, interval2, Cinitial, Cfinal, n);

%plot(t,x,'.')
%plot(t,c,'.')

Voc = chargeD*x/eps0;
Voco = chargeD*xorigin/eps0;
%plot(t,Voc,'.')

S = 25e-4; %TENG size 5cm*5cm unit m^2

%it should be noted that tribo-material is the ionic layer, which has a
%variable capacitance under cyclic load

Cair = eps0*S./x; %capacitance of air
Cairo = eps0*S./xorigin;

C2 = c; %capacitance of ionic layer
C2o = corigin;

CTENG = 1./(1./Cair+1./C2);
%CTENGo = 1./(1./Cairo+1./C2o);
%plot(t,CTENG)

Voct = [t' Voc'];
CTENGt = [t' CTENG'];

Vocot = [torigin' Voco'];
%CTENGot = [torigin' CTENGo'];
