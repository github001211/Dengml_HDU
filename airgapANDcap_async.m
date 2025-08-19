% Asynchronous recovery mode

function [t, x, c, torigin, xorigin, corigin] = airgapANDcap_async(xmax, f1, ...
    interval1, Tcpr, interval2, r, interval4, Cinitial, Cfinal, n)

T1 = 1/f1;

Trec = r*Tcpr; % recovery state period when the double inoic layer is recover from Cfinal to Cinitial,
               % which will be much longer than the Tcpr
interval3 = r*interval2; % interval for the recovery state


torigin = [];
xorigin= [];
corigin = [];

T = T1 + Tcpr; % total period including non-compression and compression state for x (air gap) and c (capacitance of inoic layer)

t1 = 0:T1/interval1:T1-T1/interval1;
x1 = (xmax/2)*(1-cos(2*pi*f1*t1)); % non-compression state airgap
c1 = t1*0+Cinitial;                % non-compression state ionic layer capacitance

t = t1;  % initial time serials for inoic layer cpacitance change
c = c1;  % initial capacitance serials for inoic layer cpacitance change
x = x1;  % initial airgap serials 

% The motion function curve of x is shown in Figure 1(d)
%and the change in the thickness of the tribo-material is directly reflected by the change in capacitance.

torigin1 = 0:T1/interval1:T1-T1/interval1;
xorigin1 = (xmax/2)*(1-cos(2*pi*f1*torigin1));
corigin1 = torigin1*0+Cinitial;

t2 = T1:Tcpr/interval2:T1+Tcpr-Tcpr/interval2;
x2 = t2*0;                         % compression state airgap
a1 = (Cfinal-Cinitial)/Tcpr;
b1 = Cinitial-a1*T1; % when t = T1, c2 = Cinitial; 
                      % when t = T1+Tcpr, c2 = Cfinal.
                      % So using y=ax+b;a=2*(Cfinal-Cinitial)/Tcpr,
                      % b=Cinitial-a*T1.
                      % the changing trend between Cinitial and Cfinal is
                      % assumed to be linear, which must be replaced later with
                      % experimental data of ionic capacitance change
c2 = a1*t2+b1;           

t3 = T1+Tcpr:Trec/interval3:T1+Tcpr+Trec-Trec/interval3;
a3 = -(Cfinal-Cinitial)/Trec;
b3 = Cinitial-a3*(T1+Tcpr+Trec); % when t = T1+Tcpr+Trec, c2 = Cinitial; 
                      % when t = T1+Tcpr, c2 = Cfinal.
                      % So using y=ax+b;a=-(Cfinal-Cinitial)/Trec,
                      % b=Cinitial-a*(t1(end)+Tcpr+Trec).
                      % the changing trend between Cinitial and Cfinal is
                      % assumed to be linear, which must be replaced later with
                      % experimental data of ionic capacitance change
c3 = a3*t3+b3;           

t4 = T1+Tcpr+Trec:(T1-Trec)/interval4:T1+Tcpr+T1-(T1-Trec)/interval4;
c4 = t4*0+Cinitial; 
tx3 = [t3 t4];
x3 = (xmax/2)*(1-cos(2*pi*f1*(tx3-T1-Tcpr)));

ttemp = [t2 t3 t4];
xtemp = [x2 x3];
ctemp = [c2 c3 c4];

% with instantaneous discharge effect
for i = 1:n
    t = [t ttemp+(i-1)*T]; % all time serials
    x = [x xtemp]; % all air gap serials
    c = [c ctemp]; % all capacitance serials of inoic layer 
end

% without instantaneous discharge effct 
for i = 1:n    
    torigin = [torigin torigin1+(i-1)*T1];
    xorigin = [xorigin xorigin1];
    corigin = [corigin corigin1];
end
% plot(t,x/max(abs(x)))
% hold on
% plot(tc,c/max(abs(c)))
end

