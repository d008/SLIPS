function [ Rd ] = getDragReduction( stream, span, ret )
k = 0.41;
%k = 0.0394; 
F0 = 3.2;
%F0 = -54.669; 

%Get Re_tau
Retau = ret;
nu = 1.12E-6;
temp= 1/k.*log(Retau)+F0;
lxplus = stream;
lzplus = span;
Rd = 0.5;
Rl = -1;
Rh = 1;
temp2 = (1-Rd).*lxplus+sqrt(1-Rd)./k.*log(sqrt(1-Rd)*Retau)+sqrt(1-Rd).*(-0.8+(F0+0.8).*exp(-(lzplus.*sqrt(1-Rd)/7).^0.7));
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
temp2 = (1-Rd).*lxplus+sqrt(1-Rd)./k.*log(sqrt(1-Rd)*Retau)+sqrt(1-Rd).*(-0.8+(F0+0.8).*exp(-(lzplus.*sqrt(1-Rd)/7).^0.7));
end
Rd = Rd*100;
end

