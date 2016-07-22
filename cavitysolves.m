N = 20;
a = 0.025;
b = 0.025;
N1 = 40;
X = linspace(0,a,N1);
Y = linspace(0,b,N1);
dy = b/(N1-1)
[x,y] =meshgrid(X,Y);
u = x*0;
n = 1:N;
tau = 7;
cn = 2.*tau.*a./(pi.*n).^2.*(1-(-1).^n)./(cosh(pi.*n.*b./a));
for i = 1:N
   u = u+cn(i).*sin(n(i).*(pi.*x./a)).*sinh(n(i).*(pi.*y./a));
end
mesh(x,y,u)
u3 =u;

plot(Y/10,mean(u3')./max(mean(u3')),'-o')
f0 = fit(Y'/10,mean(u3')'./max(mean(u3')),'cubicinterp');
hold on
plot(Y/10,f0(Y/10),'r-')
hold off
%%
x = linspace(-a,a,N1);
y = linspace(-b,b,N1);
dy = (2*b/(N1-1))
dx = (2*a/(N1-1))
[x,y] =meshgrid(x,y);
gamma =.1;
eta = 1;
tau = 0;
tau1 = 0;
eis = -(2.*n-1).*pi./(2.*a);
an = 8.*a.*cos(n.*pi).*sech(2.*eis.*b).*((-1+2.*n).*pi.*tau.*cosh(eis.*b)+2.*a.*gamma.*sinh(eis.*b))./(eta.*(1-2.*n).^3.*pi.^3)
bn = 8.*a.*cos(n.*pi).*sech(eis.*b).*(2.*a.*gamma-(2.*n-1).*pi.*tau.*tanh(eis.*b))./(eta.*(-1+2.*n).^3.*pi.^3.*(1+tanh(eis.*b).^2))
u1= gamma./(2.*eta).*(x.^2-a.^2);
u=-u1;
cn = 2.*tau1.*a./(pi.*n).^2.*(1-(-1).^n)./(cosh(pi.*n.*b./a));
u3=u1*0;
for i = 1:N
    i;
       u3 = u3+cn(i).*sin(n(i).*(pi.*(x+a)./(2.*a))).*sinh(n(i).*(pi.*(-y+b)./(2.*a)));
   u = u-cos(-eis(i).*x).*(-an(i).*sinh(-eis(i).*y)-bn(i).*cosh(-eis(i).*y));
end
mesh(u)
%mesh(u)
%mesh(del2(u))
%plot(mean(u'))
t1 =fliplr(mean(u'))
plot(t1)
%%
x = linspace(-a,a,N1);
y = linspace(-b,b,N1);
dy = (2*b/(N1-1))
dx = (2*a/(N1-1))
[x,y] =meshgrid(x,y);
gamma =1;
eta = 1;
tau = 3;
eis = -(2.*n-1).*pi./(2.*a);
u1= gamma./(2.*eta).*(x.^2-a.^2);
cn = 2.*tau.*a./(pi.*n).^2.*(1-(-1).^n)./(cosh(pi.*n.*b./a));
u3=u1*0;
for i = 1:N
    i;
   u3 = u3+cn(i).*sin(n(i).*(pi.*(x+a)./(2.*a))).*sinh(n(i).*(pi.*(y+b)./(2.*a)));
   u1 = u1+cosh(eis(i).*y)./cosh(eis(i).*b).*cos(eis(i).*x).*16.*gamma.*a.^2./(eta.*pi.^3).*(-1).^(n(i)+1)./(2.*n(i)-1).^3;
end
u = -u1+u3;
plot((mean(u')))
hold on
plot(-(mean(u1')))
plot((mean(u3')))
hold off
legend('total','nopg','shear')
[max(-(mean(u1'))),a*b*gamma/eta*0.197]