%% Execute Header File
SurfaceProcessheader
%% External Fluid 
Temp = 20;          %Water Temperature [Degree C]
water = struct('rho',rho_water,'mu',mu_water(Temp),'nu',mu_water(Temp)/rho_water,'gamma' , 50E-3,'contAngle',60,'name','water');
ext = water;
%% Lubricant Struct
%Included lubricants:
% water, alkane(6-12), air

%sampleLubricant = 
%
%          rho: 684 - kg/m^3
%           mu: 3.8900e-04 - Pa.s
%           nu: 5.6871e-07 - m^2/s
%        gamma: 0.0500 - N/m
%    contAngle: 60 - deg
%         name: 'oil1'

sampleLubricant = struct('rho',684,'mu',3.8900e-04,'nu',5.6871e-07,'gamma' ,0.0500,'contAngle',56,'name','oil1');

%% Facility Struct
%sampleFacility = 
%
%    u_tau: 0.1 - m/s
%    delta: 0.0020 - m
%    U_inf: 4 - m/s
%     name: 'channel1'

sampleFacility = struct('u_tau',0.1,'delta',2E-3,'U_inf',4,'name','channel1');

%% Surface Struct
%surf1 = 
%
%              w: 1.5000e-04 - microns
%    aspectRatio: 1 - h/w
%              a: 0.5000 - width/pitch
%           name:'150_5_1'

sampleSurface = struct('w',150E-6,'aspectRatio',1,'a',0.5,'name','150_5_1');
%Lets try a new surface
surf1 = struct('w',10E-6,'aspectRatio',1,'a',0.75,'name','trial1');
surf2 = struct('w',500E-6,'aspectRatio',1.5,'a',0.8,'name','big');
surf3 = struct('w',1.2E-3,'aspectRatio',1,'a',0.8,'name','big2');
%% Example Evaluations
lub = sampleLubricant;
fac = sampleFacility;
surface = sampleSurface;
Names = {'Example'};
SurfaceProcesshelp

%% USNA Example 1
%{
%Prescribe our parameters
lub = octane;
fac = USNA2;
surface = surf1;
%Make a name
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%}
%% USNA Re-tau= 1500 - Decane
lub = decane;
fac = USNA2;
surface = surf2;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%% USNA Re-tau= 1500 - Octane
lub = octane;
fac = USNA2;
surface = surf2;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%% USNA Re-tau= 1500 -Heptane
lub = heptane;
fac = USNA2;
surface = surf2;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp

%% USNA Re-tau= 2000 - Decane
lub = decane;
fac = USNA5;
surface = surf2;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%% USNA Re-tau= 2000 - Octane
lub = octane;
fac = USNA5;
surface = surf2;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%% USNA Re-tau= 2000 - Heptane
lub = heptane;
fac = USNA5;
surface = surf2;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%% USNA Re-tau= 2000 - Heptane
lub = octane;
fac = Princeton20;
surface = jacob;
Names = [Names;makeName(fac,lub,surface)];
%Run the parameters
SurfaceProcesshelp
%% JHU Parameters
%{
lub = octane;
fac = JHU9;
surface = surf1;
Names = [Names;makeName(fac,lub,surface)];

SurfaceProcesshelp

%% JHU Parameters
lub = octane;
fac = JHU51;
surface = surf1;
Names = [Names;makeName(fac,lub,surface)];

SurfaceProcesshelp
%}
%% Compile the tables
%Adjust units
width = width*10^6;
height = height*10^6;
y_plus = y_plus*10^6;
L_inf1=L_inf1*1000; L_inf2=L_inf2*1000;
b =b*10^6;
N =Ns;

disp('Width[micron],    Height[micron],   a,  N')
Geometry = table(width,height,area_fraction,N,'RowNames',Names)

disp('Re_tau,   u_tau[m/s],   tau_w[Pa],   viscous length[micron],   delta_99[mm],   U_e[m/s]')
Flow = table(Re_tau,u_taus,tau_w,y_plus,delta_99,U_e,'RowNames',Names)

disp('L-inf (zero laplace)[mm],  L-inf (barrier)[mm], Weber_tau, Bond, Weber_slip, w_plus,  h-plus')
Determined = table(L_inf1,L_inf2,We_tau,Bo,We_slip,w_plus,h_plus,'RowNames',Names)

disp('b[micron],b-plus, Drag Reduction, Re_cav/slip,    U_slip [m/s]')
DragProperties = table(b,b_plus,DR, Re_cav,U_slip1,'RowNames',Names)