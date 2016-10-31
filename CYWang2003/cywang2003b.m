function [us,taus, B0,A ] = cywang2003b( a,mu,b,h,M )
a = a+1e-10;
b = b./a;
%M =500;
N = round(M*a);
%tic
A = zeros(M+N,M+N);
B = zeros(M+N,1);
[n,m] = meshgrid(1:M,1:M);

Lmn =  sin(pi*(m*a+n-0.5))./(2.*pi.*(m+(n-0.5)./a))+...
    sin(pi.*(m.*a-n+0.5))./(2.*pi.*(m-(n-0.5)./a));
%clear m n
a_n = ((1:N)-0.5).*pi./a;
g_n = (1:M).*pi;
%B0
A(N+1,N+1) = 1;
%{
for n = 1:N
    A(N+1,n) = -(-1).^n./a_n(n).*(1-exp(-2.*a_n(n).*b));
end
%}
A(N+1,1:N) = -(-1).^(1:N)./a_n.*(1-exp(-2.*a_n.*b));
%B_1...B_M
for m = 2:M
    A(N+m,N+m) = (1-exp(-2.*g_n(m-1).*h));
end

A(N+2:end,1:N) = -2.*Lmn(1:M-1,1:N).*(1-exp(-2.*(ones(M-1,1)*a_n).*b));

%A_1...A_N
for n = 1:N
    A(n,n) = a/2.*a_n(n).*(1+exp(-2.*a_n(n).*b))./mu;
    B(n) = (-1).^n./a_n(n);
    %for m = 2:N
    %    A(n,N+m) = Lmn(m-1,n).*g_n(m-1).*(1+exp(-2.*g_n(m-1).*h));
    %end
end
A(1:N,N+2:end) = Lmn(1:M-1,1:N)'.*(ones(N,1)*g_n(1:end-1)).*(1+exp(-2.*(ones(N,1)*g_n(1:end-1)).*h));

A;
%x = linsolve(A,B);
x =A\B;
B0 = x(N+1)/2
%((1-a).*log(1-a)+(1+a).*log(1+a))./pi
%[X1,Y1] = meshgrid(linspace(0,a,200),linspace(-b,0,100));
%u1= X1*0;
%for i = 1:N
%    u1 = u1- x(i).*cos(a_n(i).*X1).*(exp(a_n(i).*Y1)-exp(-a_n(i).*(Y1+2.*b)));
%end
X2=linspace(0,1,1000);
u2= X2*0+x(N+1);
tau2 =  X2*0+1;
for i = 2:M
    u2 = u2 - x(N+i).*cos(g_n(i-1).*X2).*(exp(-g_n(i-1).*0)-exp(g_n(i-1).*(0-2.*h)));
    tau2 = tau2 - x(N+i).*cos(g_n(i-1).*X2).*(-g_n(i-1).*exp(-g_n(i-1).*0)-g_n(i-1).*exp(g_n(i-1).*(0-2.*h)));
end
%toc
us = u2(1,:);
taus = tau2(1,:);
%mesh(X1,Y1,u1)
%hold on
%mesh(X2,Y2,u2)
%hold off
%hold on
%plot(X2(1,:),u2(1,:),'o-')
drawnow
%hold off
end
