function [ Rd ] = getDragReduction( stream, span, ret )
k = 0.41;
%k = 0.0394; 
F0 = 3.2;
%F0 = -54.669; 
Finf = -0.8;
a = 7;
b = 0.7;

%Get Re_tau
Retau = ret;
nu = 1.12E-6;
temp= 1/k.*log(Retau)+F0;
lxplus = stream;
lzplus = span;
Rd = 0.5;
Rl = -1;
Rh = 1;


f0 = 3;
finf = -1;

%temp2 = (1-Rd).*lxplus+sqrt(1-Rd)./k.*log(sqrt(1-Rd)*Retau)+sqrt(1-Rd).*(Finf+(F0+Finf).*exp(-(lzplus.*sqrt(1-Rd)/a).^b));
temp2 = (1-Rd).*lxplus+sqrt(1-Rd)./k.*log(sqrt(1-Rd)*Retau)+sqrt(1-Rd).*(finf+(f0-finf).^2./(f0-finf+lzplus));
for n =1:100
    if temp>temp2
        Rh = Rd;
        Rd = (Rh+Rl)/2;
    elseif temp<temp2
        Rl = Rd;
       Rd = (Rh+Rl)/2;
    else
        break;
    end
temp2 = (1-Rd).*lxplus+sqrt(1-Rd)./k.*log(sqrt(1-Rd)*Retau)+sqrt(1-Rd).*(Finf+(F0+Finf).*exp(-(lzplus.*sqrt(1-Rd)/a).^b));
end
Rd = Rd*100;
end

