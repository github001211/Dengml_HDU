% Synchronous recovery mode

function [t, x, c, torigin, xorigin, corigin] = airgapANDcap_sync(xmax, f1, interval1, Tcpr, interval2, Cinitial, Cfinal, n)

% f1 = 1; % 1 Hz movement frequency for non-compression state
T1 = 1/f1;


t = [];
x = [];
c = [];
torigin = [];
xorigin = [];
corigin = [];

T = T1 + Tcpr; % total period including non-compression and compression state 

% The motion function curve of x is shown in Figure 1(d)
%and the change in the thickness of the tribo-material is directly reflected by the change in capacitance.


t1 = 0:T1/interval1:T1;
x1 = (xmax/2)*(1-cos(2*pi*f1*t1)); % non-compression state airgap
c1 = t1*0+Cinitial;                % non-compression state ionic layer capacitance

t2 = t1(end)+Tcpr/interval2:Tcpr/interval2:t1(end)+Tcpr-Tcpr/interval2;
x2 = t2*0;                         % compression state airgap

torigin1 = 0:T1/interval1:T1-T1/interval1;
% xorigin1 = (xmax/2)*(1+cos(2*pi*f1*torigin1)); % starts from gap = xmax/2
xorigin1 = (xmax/2)*(1-cos(2*pi*f1*torigin1)); % starts from gap = 0
corigin1 = torigin1*0+Cinitial;

t2_1th = t2(1:length(t2)/2);
a1 = 2*(Cfinal-Cinitial)/Tcpr;
b1 = Cinitial-a1*t1(end); % when t = t1(end), c2 = Cinitial; 
                      % when t = t1(end)+0.5*Tcpr, c2 = Cfinal.
                      % So using y=ax+b;a=2*(Cfinal-Cinitial)/Tcpr,
                      % b=Cinitial-a*t1(end).
                      % the changing trend between Cinitial and Cfinal is
                      % assumed to be linear, which must be replaced later with
                      % experimental data of ionic capacitance change
c2_1th = a1*t2_1th+b1;           

t2_2nd = t2(length(t2)/2:end);
a2 = -2*(Cfinal-Cinitial)/Tcpr;
b2 = Cinitial-a2*(t1(end)+Tcpr); % when t = t1(end)+Tcpr, c2 = Cinitial; 
                      % when t = t1(end)+0.5*Tcpr, c2 = Cfinal.
                      % So using y=ax+b;a=-2*(Cfinal-Cinitial)/Tcpr,
                      % b=Cinitial-a*(t1(end)+Tcpr).
                      % the changing trend between Cinitial and Cfinal is
                      % assumed to be linear, which must be replaced later with
                      % experimental data of ionic capacitance change
c2_2nd = a2*t2_2nd+b2;           


c2 = [c2_1th c2_2nd]; 


                     
ttemp = [t1 t2];
xtemp = [x1 x2];
ctemp = [c1 c2];


for i = 1:n
    t = [t ttemp+(i-1)*T];% all time serials
    x = [x xtemp];% all air gap serials
    c = [c ctemp];% all capacitance serials of inoic layer 

    torigin = [torigin torigin1+(i-1)*T1];
    xorigin = [xorigin xorigin1];
    corigin = [corigin corigin1];
end
end

