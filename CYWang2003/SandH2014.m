%% Helper Functions
%clear all
L_t=@(a,L) -L./(2*pi).*log(cos(pi./2.*a));
L_l=@(a,L) -L./(pi).*log(cos(pi./2.*a));

f = @(a) -log((1+sin(pi./2.*a))./(1-sin(pi./2.*a)))./...
    (2.*pi.*a.*(1+2.*log(cos(pi./2.*a))./(2.*a.*atanh(a)+log(1-a.^2))))*pi/log(2);
g = @(a) 4./pi-(4-pi)./(pi).*a;

D_l = @(a) f(a).*log(2)/pi;
D_t = @(a) f(a).*0.505/(2*pi);

D_l2 = @(a,A) D_l(a).*erf(g(a).*sqrt(pi)./(2.*D_l(a)).*A);
D_t2 = @(a,A) D_t(a).*erf(g(a).*sqrt(pi)./(8.*D_t(a)).*A);

%Dlb = @(a,A) (log(2)/pi-(1/2).*(log(2)/pi-0.505/(2*pi)).*exp(-f(a).*log(2)/pi.*A));
%D_l3 = @(a,A) f(a).*Dlb(a,A).*erf(g(a).*sqrt(pi)./(8.*f(a).*Dlb(a,A)).*A);

B_t=@(a,N,A) -log(cos(pi/2*a))./(2*pi + 1./(2.*a.*D_t2(a,A).*N).*log((1+sin(pi/2*a))./(1-sin(pi/2*a))));
B_l=@(a,N,A) -log(cos(pi/2.*a))./(pi + 1./(2.*a.*D_l2(a,A).*N).*log((1+sin(pi/2.*a))./(1-sin(pi/2.*a))));
Ct = @(a,A,N) 4.*pi.*a.*D_t2(a,A).*N./log((1+sin(pi/2.*a))./(1-sin(pi/2.*a))) ;
Cl = @(a,A,N) 2.*pi.*a.*D_l2(a,A).*N./log((1+sin(pi/2.*a))./(1-sin(pi/2.*a))) ;
Alpha = @(a) pi/2.*a;

%%

phi_t = @(X,Y,a,A,N) (Y.^2 + Ct(a,A,N)./Alpha(a).*Y.*imag(acos(cos(Alpha(a).*(X+i.*Y))./cos(Alpha(a)))))./(1+Ct(a,A,N));

wl = @(X,Y,a,A,N) (Y+ Cl(a,A,N)./Alpha(a).*imag(acos(cos(Alpha(a).*(X+i.*Y))./cos(Alpha(a)))))./(1+Cl(a,A,N));

% dy = 1e-10;
% a=0.5;
% x  = linspace(0,1./a,1000);
% [X,Y] = meshgrid(x,linspace(0,dy,2));
% w = wl(X,Y,a,10,100);
% tau = diff(w)./(dy);
% plot(x,tau)
% hold on
% plot(x,w(1,:))
% hold off
% 
% [X,Y] = meshgrid(x,linspace(0,dy,3));
% phi_t = phi_t(X,Y,a,1,1);
% u = diff(phi_t)./(dy./2);
% taut = diff(phi_t,2)./(dy./2).^2./2;
% %figure(1)
% %plot([fliplr(-x.*a),x.*a],[fliplr(taut),taut])
% xlabel('x')
% ylabel('t')
% title('title')
% axis([-1 1 0 3])
% print(figure(1),'-depsc2','tau')
% 
% 
% %figure(2)
% %plot([fliplr(-x.*a),x.*a],[fliplr(u(1,:)./max(u(1,:))),u(1,:)./max(u(1,:))])
% xlabel('x')
% ylabel('u')
% title('title')
% axis([-1 1 0 1])
% print(figure(2),'-depsc2','us')
