% run after mainSynthExample.m!
global case3counter; case3counter= 0; 

disp('reading the map page'); 
Z= load('../z/S5233F.txt','-ascii'); sz= size(Z); 
inds= floor(sz(1)*0.6):floor(sz(1)*0.9);
Z= Z(inds,inds); sz= size(Z); n= sz(1);
delta= 2.0; % (m)
p1= [584,7296]*1.0e3; p2= [590,7302]*1.0e3;

cases= struct('name','', 'kappa1',[],'kappa2',[]);
Hscale= [-0.3,0.36]; % (m^{-1})
Gscale= [-0.02,0.07]; % (m^{-2})
k1scale= [-0.3,0.4]; k2scale= [-0.3,0.4];
X= p1(1)+ (0:(n-1))*delta; 
Y= p2(2)+ (0:(n-1))*delta;

n= size(Z,1); 
figure(1);
    if 0
        subplot(2,3,1);
        contourf(X,Y,Z,30, 'LineStyle','none'); axis equal; % shading interp;
        xlabel('x'); ylabel('y'); title('z');
        h= colorbar; set(get(h,'title'),'string','(m)');
    end

disp('computing the window method');
cases(1).name= 'window';
kappa1= zeros(n,n); kappa2= zeros(n,n);
for i=2:(n-1)
	indsI= (i-1):(i+1);
	for j=2:(n-1)
		indsJ= (j-1):(j+1);
		[Hij,Gij, k1ij,k2ij]= getHGwindow(Z(indsI,indsJ),delta);
		kappa1(j,i)= k1ij; kappa2(j,i)= k2ij; 
	end
end
cases(1).kappa1= kappa1; cases(1).kappa2= kappa2;

subplot(2,2,1); 
	contourf(X,Y,kappa1',20, 'LineStyle','none'); shading interp; axis equal;
	xlabel('E (m)'); ylabel('N (m)'); title('windowed \kappa_1'); % caxis(k1scale);
	h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 
    caxis([-0.04,0.05]);
    
disp('computing the CC method');
cases(2).name= 'CC';
for i=2:(n-1)
	indsI= (i-1):(i+1);
	for j=2:(n-1)
		indsJ= (j-1):(j+1);
		[Hij,Gij, k1ij,k2ij]= getHGCC(Z(indsI,indsJ),delta);
		kappa1(j,i)= k1ij; kappa2(j,i)= k2ij; 
	end
end
cases(2).kappa1= kappa1; cases(2).kappa2= kappa2;
    
subplot(2,2,2); 
	contourf(X,Y,kappa2',20, 'LineStyle','none'); shading interp; axis equal;
	xlabel('E (m)'); ylabel('N (m)'); title('CC \kappa_2'); % caxis(k1scale);
	h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 
    caxis([-0.05,0.04]);

disp('computing the CC+ method');
cases(3).name= 'CC+';
for i=2:(n-1)
	indsI= (i-1):(i+1);
	for j=2:(n-1)
		indsJ= (j-1):(j+1);
		H(j,i)= Hij; G(j,i)= Gij;
		kappa1(j,i)= k1ij; kappa2(j,i)= k2ij;
	end
end
cases(3).kappa1= cases(2).kappa1 + kappa1;
cases(3).kappa2= cases(2).kappa2 + kappa2;

subplot(2,2,3); 
	kappa1= cases(1).kappa2;
	kappa2= cases(2).kappa2;
	plot(kappa1,kappa2,'k.', 'markerSize',1); axis equal; 
    xlabel('windowed \kappa_2'); grid on; 
    ylabel('CC \kappa_2'); title('windowed and CC \kappa_1');

subplot(2,2,4); % subplot(2,3,[5,6]); 
    m= 80; 
	kappa1= cases(1).kappa1; k1s= reshape(kappa1,n^2 ,1); [f1,k1]= hist(k1s, m); f1= f1/trapz(k1,f1); 
	kappa2= cases(1).kappa2; k2s= reshape(kappa2,n^2 ,1); [f2,k2]= hist(k2s, m); f2= f2/trapz(k2,f2); 
	kappa1= cases(2).kappa1; k1s= reshape(kappa1,n^2 ,1); [f3,k3]= hist(k1s, m); f3= f3/trapz(k3,f3); 
	kappa2= cases(2).kappa2; k2s= reshape(kappa2,n^2 ,1); [f4,k4]= hist(k2s, m); f4= f4/trapz(k4,f4); 
	semilogy(k1,f1,'k', k2,f2,'k--', k3,f3,'r', k4,f4,'r--');  % axis([-30,30,10,10^5]);
	xlabel('\kappa (m^{-1})'); ylabel('freq. (m)'); 
	title('DEM principal curvatures');
	legend('window \kappa_1','window \kappa_2', 'CC \kappa_1','CC \kappa_2'); 
	axis([-0.2,0.25,10^(-3),35]); 

set(findall(gcf,'-property','FontSize'),'FontSize',12);

kappa1= cases(1).kappa2; kappa2= cases(2).kappa2;
k1= reshape(kappa1,n^2,1); k2= reshape(kappa2,n^2,1);
inds= 1:200:n^2; k1= k1(inds); k2= k2(inds); 
inds1= find(~isnan(k1)); inds2= find(~isnan(k2));
inds= intersect(inds1,inds2); k1= k1(inds); k2= k2(inds);
disp(sprintf('corr(k2(window),k2(CC))= %.3f', corr(k1,k2)));
disp(sprintf('RMSE(k2(window),k2(CC))= %.2g', norm(k1-k2)/sqrt(n)));

