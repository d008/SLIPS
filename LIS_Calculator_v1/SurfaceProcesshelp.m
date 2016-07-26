%Calculate viscous length scale in m
yplus = ext.nu/fac.u_tau;

%Calculate friction Re
Re_tau = [Re_tau;fac.u_tau*fac.delta/ext.nu];

%Viscosity Ratio mu_water/mu_oil
N = ext.mu/lub.mu;

%Calculate retention length [m] (zero laplace, chemical barrier)
[L1a , L2a] = retentionLength(lub.contAngle,surface.w*surface.aspectRatio,surface.w,lub.gamma,ext.rho*fac.u_tau^2);

%Store N
Ns = [Ns;N];

%Store Ue
U_e = [U_e;fac.U_inf];

%Store retention lengths in meteres L1- zero laplace pressure, L2 -
%chemical barrier
L_inf1 = [L_inf1;L1a];L_inf2 = [L_inf2;L2a];

%Store friction velocity in m/s
u_taus = [u_taus;fac.u_tau]; 

%Store shear
tau_w = [tau_w;ext.rho*fac.u_tau^2]; 

%Store viscous length scale
y_plus = [y_plus;yplus];

%Store delta_99
delta_99 = [delta_99;fac.delta];

%Store surface width, height, and area fraction
width = [width;surface.w]; 
height= [height;surface.w*surface.aspectRatio];
area_fraction = [area_fraction;surface.a];

%Calcualte Weber number based on u tau
We_tau = [We_tau; ext.rho*fac.u_tau^2*surface.w/lub.gamma];

%Calculate Bond Number
Bo = [Bo;(ext.rho - lub.rho)*(9.8)*(surface.w).^2./lub.gamma];

%Store w-plus, h-plus, and slip length plus assuming streamwise grooves
w_plus = [w_plus;surface.w/yplus];
h_plus = [h_plus;surface.w/yplus*surface.aspectRatio];
b_plus = [b_plus;B_l(surface.a,N,surface.aspectRatio)/surface.a*surface.w/yplus];
b= [b;B_l(surface.a,N,surface.aspectRatio)/surface.a*surface.w];

%Calucalte drag reduction using spanwise and streamwise slip models and
%Fukagata 2006 models
DR= [DR;getDragReduction(b_plus(end),B_t(surface.a,N)/surface.a*surface.w/yplus,fac.u_tau*fac.delta/ext.nu)];

U_slip1 = [U_slip1;(100-DR(end))./100.*tau_w(end)./ext.mu.*b(end)];
U_slip2 = [U_slip2;DR(end)/100*fac.U_inf];

%From the drag reduction approximate the slip velocity and estimate the
%slip Weber number
We_slip = [We_slip;ext.rho*(U_slip1(end))^2*surface.w/lub.gamma];

%Calculate cavity Reynolds number
Re_cav= [Re_cav;(U_slip1(end))*surface.w/lub.nu];