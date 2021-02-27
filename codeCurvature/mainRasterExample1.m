% run after mainSynthExample.m!

zss1= load('../z/S5233F.txt','-ascii'); sz= size(zss1); n1= sz(1); 
incrs= [1,2,3,4,6,8,10]; m= length(incrs); delta1= 2.0; % (m)
deltas= delta1*incrs;
p1= [584,7296]*1.0e3; p2= [590,7302]*1.0e3; saveIt= 0; 

cases= struct('k',0,'name','', 'H',[],'G',[], 'kappa1',[],'kappa2',[]);
counter= 0; 
Hscale= [-0.3,0.36]; % (m^{-1})
Gscale= [-0.02,0.07]; % (m^{-2})
k1scale= [-0.3,0.4]; k2scale= [-0.3,0.4];
for k=1:m
	delta= deltas(k);
    if k==1
        inds= 1:floor(n1/2); 
    else
        inds= 1:incrs(k):n1;
    end
    n= length(inds);
	Z= zss1(inds,inds); 
    X= p1(1)+ (0:(n-1))*delta; 
    Y= p2(2)+ (0:(n-1))*delta;
    if saveIt
        counter= counter+1;
        cases(counter).name= 'window';
        cases(counter).k= k;
    end

    figure(1); subplot(2,3,1);
        contourf(X,Y,Z,30, 'LineStyle','none'); axis equal; % shading interp;
        xlabel('x'); ylabel('y'); title('z');
        h= colorbar; set(get(h,'title'),'string','(m)');

        H= zeros(n,n); G= H; kappa1= H; kappa2= H;
            
        for i=2:(n-1)
            indsI= (i-1):(i+1);
            for j=2:(n-1)
                indsJ= (j-1):(j+1);
                [Hij,Gij, k1ij,k2ij]= getHGwindow(Z(indsI,indsJ),delta);
                H(j,i)= Hij; G(j,i)= Gij;
                kappa1(j,i)= k1ij; kappa2(j,i)= k2ij; 
            end
        end
        if saveIt
            cases(counter).H= H; cases(counter).G= G;
            cases(counter).kappa1= kappa1; cases(counter).kappa2= kappa2;
        end
    
    subplot(2,3,2);
        contourf(X,Y,H,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('H'); caxis(Hscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,3);
        contourf(X,Y,G,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('G'); % caxis(Gscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-2})'); 

    subplot(2,3,4); 
        contourf(X,Y,kappa1,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_1'); caxis(k1scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,5); 
        contourf(X,Y,kappa2,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_2'); caxis(k2scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,6); m= 200;
        k1s= reshape(kappa1,n^2 ,1); [f1,k1]= hist(k1s, m); 
        k2s= reshape(kappa2,n^2 ,1); [f2,k2]= hist(k2s, m); 
        semilogy(k1,f1,'b', k2,f2,'r');  % axis([-30,30,10,10^5]);
        xlabel('\kappa (m^{-1})'); ylabel('freq. (m)'); 
        title('princ. curv. distr.');
        legend('\kappa_1','\kappa_2'); hold on; 
        
    disp('!');
end
