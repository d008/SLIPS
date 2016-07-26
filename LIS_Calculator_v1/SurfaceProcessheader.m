%% Helper Functions
clc
clear all
f = @(a) -log((1+sin(pi./2.*a))./(1-sin(pi./2.*a)))./...
    (2.*pi.*a.*(1+2.*log(cos(pi./2.*a))./(2.*a.*atanh(a)+log(1-a.^2))))*pi/log(2);
g = @(a) 4./pi-(4-pi)./(pi).*a;

D_l = @(a) f(a)*log(2)/pi;
D_t = @(a) f(a)*0.505/(2*pi);
D_l2 = @(a,A) D_l(a)*erf(g(a).*sqrt(pi)./(2.*D_l(a)).*A);
D_t2 = @(a,A) D_t(a)*erf(g(a).*sqrt(pi)./(8.*D_t(a)).*A);
Dlb = @(a,A) (log(2)/pi-(1/2).*(log(2)/pi-0.505/(2*pi)).*exp(-f(a).*log(2)/pi.*A));
D_l3 = @(a,A) f(a).*Dlb(a,A).*erf(g(a).*sqrt(pi)./(8.*f(a).*Dlb(a,A)).*A);

% Make Name
makeName = @(fac,lub,surface) strcat(fac.name,'_',lub.name,'_',surface.name);
%Ideal Slip Length Functions
B_t=@(a,N) -log(cos(pi/2*a))./(2*pi + 1./(2.*a.*D_t(a).*N).*log((1+sin(pi/2*a))./(1-sin(pi/2*a))));
B_l=@(a,N,A) -log(cos(pi/2*a))./(pi + 1./(2.*a.*D_l3(a,A).*N).*log((1+sin(pi/2*a))./(1-sin(pi/2*a))));
%% Empty Parameters
Re_tau =[]; Ns=[]; U_e = []; L_inf1 = []; L_inf2=[]; u_taus=[]; tau_w=[];
y_plus=[]; delta_99=[]; width=[];height=[];area_fraction=[];
We_tau=[];Bo=[]; w_plus=[];h_plus=[];b_plus=[];DR=[];We_slip = [];
Re_cav = [];b=[]; U_slip1 = [];U_slip2 = [];

%% Property helpers
% WATER PROPERTIES
mu_water = @(T) 2.414E-5 * 10^(247.8./(T +273.15 - 140)); % [Pa.s]
rho_water = 998;     %Density of water [kg/m^3]

%Old Model
drmodel = @(bp,a,N) (1-a)+ a./(D_l(a).*N.*bp).*(sqrt(25./(1+5./(bp.*D_l(a).*N)))).*atanh(sqrt(1./(1+(5./(D_l(a).*N.*bp)))));

% Lubricant Properties
rho_oils = [1.2,0,0,0,626,659,684,703,718,730,740,749]; %Density of lubricants [kg/m^3]
mu_oils = [1E-3/55,0,0,0,0,0.2949E-3,0.3890E-3,0.542E-3,0.7139E-3,0.9256E-3,1.185E-3,1.503E-3]; %Viscosity of lubricants @20C[Pa.s]
%Select Alkane Number (or 1 for air)

%% Lubricant Properties
air = struct('rho',rho_oils(1),'mu',mu_oils(1),'nu',mu_oils(1)/rho_oils(1),'gamma' , 72E-3,'contAngle',56,'name','air');
hexane = struct('rho',rho_oils(6),'mu',mu_oils(6),'nu',mu_oils(6)/rho_oils(6),'gamma' , 50E-3,'contAngle',56,'name','hexane');
heptane = struct('rho',rho_oils(7),'mu',mu_oils(7),'nu',mu_oils(7)/rho_oils(7),'gamma' , 50E-3,'contAngle',56,'name','heptane');
octane = struct('rho',rho_oils(8),'mu',mu_oils(8),'nu',mu_oils(8)/rho_oils(8),'gamma' , 50E-3,'contAngle',56,'name','octane');
nonane = struct('rho',rho_oils(9),'mu',mu_oils(9),'nu',mu_oils(9)/rho_oils(9),'gamma' , 50E-3,'contAngle',56,'name','nonane');
decane = struct('rho',rho_oils(10),'mu',mu_oils(10),'nu',mu_oils(10)/rho_oils(10),'gamma' , 50E-3,'contAngle',56,'name','decane');
undecane = struct('rho',rho_oils(11),'mu',mu_oils(11),'nu',mu_oils(11)/rho_oils(11),'gamma' , 50E-3,'contAngle',56,'name','undecane');
dodecane = struct('rho',rho_oils(12),'mu',mu_oils(12),'nu',mu_oils(12)/rho_oils(12),'gamma' , 50E-3,'contAngle',56,'name','dodecane');
fc3283 = struct('rho',1.82E3,'mu',1.4E-3,'nu',1.4E-3/1.82E3,'gamma', 18E-3,'contAngle',56,'name','fc3283');
gelest7040 = struct('rho',1061,'mu',42.7E-3,'nu',42.7E-3/1061,'gamma' , 29E-3,'contAngle',56,'name','gelest7040');

clear rho_oils mu_oils drmodel  
%% Facility Properties
USNA2 =struct('u_tau',0.0461,'delta',36E-3,'U_inf',1.269,'name','USNA2');
USNA5 =struct('u_tau',0.0751,'delta',34E-3,'U_inf',1.934,'name','USNA5');

JHU9 =struct('u_tau',0.095,'delta',9.1E-3,'U_inf',2.2,'name','JHU9');
JHU51 =struct('u_tau',0.225,'delta',7.4E-3,'U_inf',6.1,'name','JHU51');
Princeton10 =struct('u_tau',0.10,'delta',1.9E-3,'U_inf',3.1,'name','Princeton');
Princeton20 =struct('u_tau',0.13,'delta',1.9E-3,'U_inf',4.1,'name','Princeton');

Princeton30 =struct('u_tau',0.20,'delta',1.9E-3,'U_inf',6.1,'name','Princeton');
%% Surface Properties
surf1 = struct('w',150E-6,'aspectRatio',1,'a',0.5,'name','surf1');
jacob = struct('w',1E-3,'aspectRatio',0.5,'a',0.75,'name','jacob');
