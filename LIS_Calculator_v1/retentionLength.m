
function [ L,l ] = retentionLength(angle,h,w,gamma,tau )
%retentionLength(angle,h,w,gamma,tau ) Calculates the retenion length of
%the oil for btoh back end boudnary conditions
%   angle = contact angle
%   h = height
%   w = width
%   gamma = surface tension
%   tau = applied shear
hw = h./w;

for k = 1:length(angle)
    theta = angle(k)/180*pi; % select contact angle
    % calculate geometric prefactors
    N = 5000;
    Cs = 0; for n = 0:N, lambda = (n+1/2)*pi; Cs = Cs + (-1)^n/lambda^4*tanh(lambda/2./hw); end
    Cs = 1/2-4*hw.*Cs;
    Cp = 0; for n = 0:N,lambda = (n+1/2)*pi; Cp = Cp + 1/lambda^5*tanh(lambda/2./hw); end
    Cp = 1/3-4*hw.*Cp;
    
    % calculate curvatures for each h/w ratio
    for j = 1:length(hw)
        if 1/hw(j) <= 2*(sec(theta)+tan(theta))
            rmin(j) = w(j)/2/cos(theta);
        else
            rmin(j) = h*(1+(1/2/hw(j)).^2)/2;
        end
    end
    
    L(k,:) = Cp*h*gamma./Cs./rmin/tau; % calculate predicted retention
    l(k,:) = 2*Cp*h*gamma./Cs./tau./w.*(1+w./(2*rmin));
end

end

