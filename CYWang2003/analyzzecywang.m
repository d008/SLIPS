%clear all
%b(a,h,N)
SandH2014
load('cywang2003bdata.mat')
%load('matlab.mat')
close all
[H,A,n] = meshgrid(h,a,h);
bnorm = b./B_l(A,n,20);
hnorm  = H.*A./(1-A)./B_l(A,n,20);
US = mean(us,4);
TAUS = mean(taus,4);
B = US./TAUS;
for i = 1:10
    i
    hnorm1 = squeeze(hnorm(i,:,:));
    bnorm1 = squeeze(bnorm(i,:,:));
    nnorm1 = squeeze(n(i,:,:));
    hold on
    contour3(hnorm1(:,:),nnorm1(:,:),bnorm1(:,:),40,'k');
    surf(hnorm1(:,:),nnorm1(:,:),bnorm1(:,:));
    alpha(.25)
    hold off
end


ax =gca
ax.XScale = 'log';
xlabel('h');
ax.YScale = 'log';
ylabel('N');
ax.ZScale = 'log';
zlabel('b');
shading interp
view([0,0])

%%
clf
for j=1:length(a);
    bnorm = b;
    hnorm  = H;
    p = colormap(jet);
    a(j)
    
    hnorm1 = squeeze(hnorm(j,:,:));
    bnorm1 = squeeze(bnorm(j,:,:));
    nnorm1 = squeeze(n(j,:,:));
    for i = 1:1:length(h)
        
        hold on
        
        
        temp = Cl(a(j),20,h(i)).*Alpha(a(j))./(1+Cl(a(j),20,h(i)));
        %plot(hnorm1(:,i),bnorm1(:,i),'-','Color',p(floor(i/2)+1,:));
        %plot(hnorm1(:,i).*a(j)./(1-a(j)),bnorm1(:,i),'-','Color',p(floor(i/2)+1,:));
        %plot(hnorm1(:,i).*a(j)./(1-a(j))./bnorm1(1,i),bnorm1(:,i)./bnorm1(1,i),'-','Color',p(floor(i/2)+1,:));
        plot(hnorm1(:,i)./(1-a(j)).*a(j)./bnorm1(1,i),bnorm1(:,i)./bnorm1(1,i),'.','Color',p(floor(i/2)+1,:));
        
        %./bnorm1(1,i).*a(j)./(1-a(j))
        ache = hnorm1(:,i).*a(j)./(1-a(j));
        %plot(ache./bnorm1(1,i),bnorm1(:,i)-bnorm1(1,i).*(ache/2)./(ache./2+bnorm1(1,i)),'--','Color',p(floor(i),:))
        
    end
    figure(1)
    ax =gca
    ax.XScale = 'log';
    xlabel('$\frac{ha}{b_{\infty}(1-a)}$','Interpreter','latex');
    ax.YScale = 'log';
    ylabel('$\frac{b}{b_{\infty}}$','Interpreter','latex');
    axis([0.001 1000 0.001 1.1])
    hold off
    colorbar
end




