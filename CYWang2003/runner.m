c = parcluster('local');
c.NumWorkers = 20;
parpool(c, c.NumWorkers);
tic
N =50;
M = 20;
num = 10000;
b = zeros(M,N,N);
us = zeros(M,N,N,1000);
taus = zeros(M,N,N,1000);
h = logspace(2,-6,N);
a  = linspace(0.01,0.99,M);
L_l=@(a,L) -L./(pi).*log(cos(pi./2*a));
tic
parfor i = 1:M
    for j = 1:N
        for k = 1:N
            [i,j,k]
            [us(i,j,k,:),taus(i,j,k,:),b(i,j,k)] = cywang2003b(a(i),h(k),20,h(j),num);
        end
    end
end
toc
save('cywang2003bdata.mat')
delete(gcp('nocreate'))
toc
