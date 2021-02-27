ds= [0.2,0.175,0.15,0.1,0.08,0.065,0.05,0.04,0.03,0.02,0.01,0.005,0.003,0.0015]; 
m1= length(ds); corrs= zeros(m1,4);
L1= 20.0;
thetas= struct('bins',[],'fs',[]);
thetas(1).bins= linspace(0.0,pi/2*0.8, round(90*0.8/5)); 
thetas(1).fs= zeros(m1,length(thetas(1).bins));
for k=1:m1 % 4:4
    d= ds(k); L= L1*d/ds(1);
    x= -L:d:L; y= -L:d:L; n= length(x); [X,Y]= meshgrid(x,y);
    global A0; global A; global B; global C; global D; global E1; global F; 
    global p1; global p2; 
    A0= 0.1; A= 0.3; B= 0.2; C= 2.8; D= 10.0; E1= 1.0; F= 0.4; p1= [-5, 5]; p2= [ 5,-4];
  % A= 0.6; B= 0.3; C= 2.8; D= 10.0; E1= 5.0; F= 0.4; p1= [-5, 5]; p2= [ 5,-4];
    global case3counter; case3counter= 0;

    if 1
        Z= A0*sin(A*X.*Y)+B*sin(2*X).*cos(2*Y) + C*cos(sqrt(X.^2 + Y.^2)*(pi/2)/D);
        Z= Z+ E1*exp(-((X-p1(1)).^2+ (Y-p1(2)).^2)/F);
        Z= Z- E1*exp(-((X-p2(1)).^2+ (Y-p2(2)).^2)/F);
    else
        r= 100.0;
        Z= sqrt(r^2 - X.^2 - Y.^2);
    end

    % save('synth.mat','Z','-ascii');
    dlmwrite('synth.mat',Z,'precision','%.3f')

    cases= struct('name','', 'H',[],'G',[], 'kappa1',[],'kappa2',[]);
    cases(1).name= 'synthetic';  
    figure(1); clf; subplot(2,3,1);
        contourf(X,Y,Z,20, 'LineStyle','none'); axis equal; % shading interp; 
        xlabel('x'); ylabel('y'); title('z'); 
        h= colorbar; set(get(h,'title'),'string','(m)'); 

        cases(1).H= zeros(n,n); cases(1).G= zeros(n,n);
        cases(1).kappa1= zeros(n,n); cases(1).kappa2= zeros(n,n);
        for i=1:n
            for j=1:n
                [Hij,Gij, k1ij,k2ij]= getHGsynth(x(i),y(j));
                cases(1).H(i,j)= Hij; cases(1).G(i,j)= Gij;
                cases(1).kappa1(i,j)= k1ij; cases(1).kappa2(i,j)= k2ij; 
            end
        end

    subplot(2,3,2); Hscale= [-10,10]; 
        contourf(X,Y,cases(1).H,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('H'); caxis(Hscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,3); Gscale= [-25,25];
        contourf(X,Y,cases(1).G,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('G'); caxis(Gscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-2})'); 

    subplot(2,3,4); k1scale= [-2,8]; 
        contourf(X,Y,cases(1).kappa1,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_1'); caxis(k1scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1}'); 

    subplot(2,3,5); k2scale= [-8,2]; 
        contourf(X,Y,cases(1).kappa2,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_2'); caxis(k2scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,6); m= 200;
        k1s= reshape(cases(1).kappa1,n^2 ,1); [f1,k1]= hist(k1s, m); 
        k2s= reshape(cases(1).kappa2,n^2 ,1); [f2,k2]= hist(k2s, m); 
        semilogy(k1,f1,'b', k2,f2,'r'); axis([-30,30,10,10^5]);  
        xlabel('\kappa (m^{-1})'); ylabel('freq. (m)'); 
        title('princ. curv. distr.');
        legend('\kappa_1','\kappa_2');


    cases(2).name= 'pol.'; cases(5).name= 'numerical';
    figure(2); clf; subplot(2,3,1);
        contourf(X,Y,Z,20, 'LineStyle','none'); axis equal; % shading interp; 
        xlabel('x'); ylabel('y'); title('z');
        h= colorbar; set(get(h,'title'),'string','(m)'); 

        cases(2).H= zeros(n,n); cases(2).G= zeros(n,n);
        cases(2).kappa1= zeros(n,n); cases(2).kappa2= zeros(n,n);
        cases(5).H= zeros(n,n); cases(5).G= zeros(n,n);
        cases(5).kappa1= zeros(n,n); cases(5).kappa2= zeros(n,n);
        for i=2:(n-1)
            indsI= (i-1):(i+1);
            for j=2:(n-1)
                indsJ= (j-1):(j+1);
                [Hij,Gij, k1ij,k2ij]= getHGwindow(Z(indsI,indsJ),d);
                cases(2).H(j,i)= Hij; cases(2).G(j,i)= Gij;
                cases(2).kappa1(j,i)= k1ij; cases(2).kappa2(j,i)= k2ij; 

                [Hij,Gij, k1ij,k2ij]= getHGnum(Z(indsI,indsJ),d);
                cases(5).H(j,i)= Hij; cases(5).G(j,i)= Gij;
                cases(5).kappa1(j,i)= k1ij; cases(5).kappa2(j,i)= k2ij; 
            end
        end

    subplot(2,3,2);
        contourf(X,Y,cases(2).H,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('H'); caxis(Hscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,3);
        contourf(X,Y,cases(2).G,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('G'); caxis(Gscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-2})'); 

    subplot(2,3,4); 
        contourf(X,Y,cases(2).kappa1,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_1'); caxis(k1scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,5); 
        contourf(X,Y,cases(2).kappa2,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_2'); caxis(k2scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,6); m= 200;
        k1s= reshape(cases(2).kappa1,n^2 ,1); [f1,k1]= hist(k1s, m); 
        k2s= reshape(cases(2).kappa2,n^2 ,1); [f2,k2]= hist(k2s, m); 
        semilogy(k1,f1,'b', k2,f2,'r');  axis([-30,30,10,10^5]);
        xlabel('\kappa (m^{-1})'); ylabel('freq. (m)'); 
        title('princ. curv. distr.');
        legend('\kappa_1','\kappa_2');


    cases(3).name= 'CC';
    cases(4).name= 'CC+';
    figure(3); clf; subplot(2,3,1);
        contourf(X,Y,Z,20, 'LineStyle','none'); axis equal; % shading interp; 
        xlabel('x'); ylabel('y'); title('z');
        h= colorbar; set(get(h,'title'),'string','(m)'); 

        if 0
            k1= load('synthData/curvatures2/synth.k1','-ascii')/8;
            k2= load('synthData/curvatures2/synth.k2','-ascii')/8;
            cases(3).kappa1= k1; cases(3).kappa2= k2; 
            cases(3).H= (k1+k2)/2; cases(3).G= k1.*k2; 
            subplot(2,3,2);
                contourf(X,Y,cases(2).H,20, 'LineStyle','none'); shading interp; axis equal;
                xlabel('x'); ylabel('y'); title('H'); caxis(Hscale);
                h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 
        else
            cases(3).H= zeros(n,n); cases(3).G= zeros(n,n);
            cases(3).kappa1= zeros(n,n); cases(3).kappa2= zeros(n,n);
            cases(4).H= zeros(n,n); cases(4).G= zeros(n,n);
            cases(4).kappa1= zeros(n,n); cases(4).kappa2= zeros(n,n);
            for i=2:(n-1)
                indsI= (i-1):(i+1);
                for j=2:(n-1)
                    indsJ= (j-1):(j+1);

                    [Hij,Gij, k1ij,k2ij]= getHGCC(Z(indsI,indsJ),d);
                    cases(3).H(j,i)= Hij; cases(3).G(j,i)= Gij;
                    cases(3).kappa1(j,i)= k1ij; cases(3).kappa2(j,i)= k2ij; 

                    [Hijf,Gijf, k1ijf,k2ijf]= getHGCCface(Z(indsI,indsJ),d);
                    cases(4).H(i,j)= Hij+Hijf; cases(4).G(i,j)= Gij+Gijf;
                    cases(4).kappa1(j,i)= k1ij+k1ijf; 
                    cases(4).kappa2(j,i)= k2ij+k2ijf; 
                end
            end
            if case3counter > 0
                disp(sprintf('imag. occasions: %d',case3counter));
            end
        end

    subplot(2,3,2);
        contourf(X,Y,cases(3).H,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('H'); caxis(Hscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,3);
        contourf(X,Y,cases(3).G,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('G'); caxis(Gscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-2})'); 

    subplot(2,3,4); 
        contourf(X,Y,cases(3).kappa1,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_1'); caxis(k1scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,5); 
        contourf(X,Y,cases(3).kappa2,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_2'); caxis(k2scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,6); m= 200;
        k1s= reshape(cases(3).kappa1,n^2 ,1); [f1,k1]= hist(k1s, m); 
        k2s= reshape(cases(3).kappa2,n^2 ,1); [f2,k2]= hist(k2s, m); 
        semilogy(k1,f1,'b', k2,f2,'r');  axis([-30,30,10,10^5]);
        xlabel('\kappa (m^{-1})'); ylabel('freq. (m)'); 
        title('princ. curv. distr.');
        legend('\kappa_1','\kappa_2');

    figure(4); clf;
        colors= struct('c',''); m= 80;
        colors(1).c= 'k'; 
        colors(2).c= 'b';
        colors(3).c= 'g';
        colors(4).c= 'r';
        colors(5).c= 'c';
        subplot(2,2,1); 
        for i=1:5
            temp= reshape(cases(i).H, n^2,1);
            [f,x]= hist(temp,m); f= f/trapz(x,f); semilogy(x,f, colors(i).c);
            hold on;
        end
        xlabel('H (m^{-1})'); ylabel('freq. (m)'); 
        title('mean curvature');
        legend('synth.','pol.','CC','CC+','num.'); axis([-5,5,1.0e-3,1.2]); 

        subplot(2,2,2); 
        for i=1:5
            temp= reshape(cases(i).G, n^2,1);
            [f,x]= hist(temp,m); f= f/trapz(x,f); semilogy(x,f, colors(i).c); 
            hold on;
        end
        xlabel('G (m^{-2})'); ylabel('freq. (m^2)'); 
        title('Gaussian curvature');
        legend('synth.','pol.','CC','CC+','num');  axis([-5,5,1.0e-3,2]);

        subplot(2,1,2);  
        colors= struct('c1','','c2','');
        colors(1).c1= 'k'; colors(1).c2= 'k--';
        colors(2).c1= 'b'; colors(2).c2= 'b--';
        colors(3).c1= 'g'; colors(3).c2= 'g--';
        colors(4).c1= 'r'; colors(4).c2= 'r--';
        colors(5).c1= 'c'; colors(5).c2= 'c--';
        for i=1:5
            temp1= reshape(cases(i).kappa1, n^2,1); temp1(1)= 0;
            temp2= reshape(cases(i).kappa2, n^2,1);
            [f,x]= hist(temp1,m); f= f/trapz(x,f); semilogy(x,f, colors(i).c1);  
            hold on;
            [f,x]= hist(temp2,m); f= f/trapz(x,f); semilogy(x,f, colors(i).c2);
        end
        axis([-5,5,5e-4,2]);
        xlabel('\kappa_i,i=1,2 (m^{-1})'); ylabel('freq. (m)'); 
        title('principal curvatures');

    legend('synth. \kappa_1','synth. \kappa_2',...
        'pol. \kappa_1','pol. \kappa_2',...
        'CC \kappa_1','CC \kappa_2', ...
        'CC+ \kappa_1','CC+ \kappa_2', 'num. \kappa_1','num. \kappa_2'); 

    set(findall(gcf,'-property','FontSize'),'FontSize',12);

    figure(5); clf;
        temp1= reshape(cases(1).kappa1, n^2,1);
        temp2= reshape(cases(2).kappa1, n^2,1);
        temp3= reshape(cases(3).kappa1, n^2,1);
        temp4= reshape(cases(4).kappa1, n^2,1);
        temp5= reshape(cases(5).kappa1, n^2,1);
        inds= 1:50:(n^2); 
        plot(temp1(inds),temp2(inds),'b.', 'markerSize',1); hold on; 
        plot(temp1(inds),temp3(inds),'g.', 'markerSize',1);
        plot(temp1(inds),temp4(inds),'r.', 'markerSize',1);
        plot(temp1(inds),temp5(inds),'c.', 'markerSize',1);
        axis equal; grid on; 
        title('The correlation between \kappa_1 of exact, windowed and CC+');
        xlabel('the exact \kappa_1 (m^{-1})'); 
        ylabel('Computed \kappa_1 (m^{-1})');
        legend('windowed','CC','CC+','num.');
        
        inds1= find(~isnan(temp1)); inds2= find(~isnan(temp2));
        inds3= find(~isnan(temp3)); inds4= find(~isnan(temp4)); inds5= find(~isnan(temp5));
        inds= intersect(inds1,inds2); correlations(1)= corr(temp1(inds),temp2(inds)); 
        inds= intersect(inds1,inds3); correlations(2)= corr(temp1(inds),temp3(inds)); 
        inds= intersect(inds1,inds4); correlations(3)= corr(temp1(inds),temp4(inds)); 
        inds= intersect(inds1,inds5); correlations(4)= corr(temp1(inds),temp5(inds)); 
        corrs(k,:)= correlations

    figure(6); clf;
        for i=1:5
            subplot(2,3,i); imshow(cases(i).kappa2); 
        end
 
        % this code fragment is also in mainrasterExample.m 
        theta= zeros(n,n);
		for i=2:(n-1)
			for j=2:(n-1)
				kx= (Z(i+1,j) - Z(i-1,j))/(2*d); %kx= kx*0.2;
				ky= (Z(i,j+1) - Z(i,j-1))/(2*d); %ky= ky*0.2; 
				theta(i,j)= atan(sqrt(kx^2 + ky^2));
			end
		end
		[f,t]= hist(reshape(theta,1,n^2), thetas(1).bins); f= f/trapz(t,f); 
		thetas(1).fs(k,:)= f; 
end

figure(7); 
semilogx(ds,corrs(:,1),'b', ds,corrs(:,2),'g', ds,corrs(:,3),'r', ds,corrs(:,4),'c'); 
legend('windowed','CC','C+','num');
xlabel('\delta (m)'); ylabel('corr(exact,.)'); title('accuracy of \kappa_1 of three methods');
set(findall(gcf,'-property','FontSize'),'FontSize',12);


figure(8);
	plot(thetas(1).bins*180/pi,thetas(1).fs);
    xlabel('\beta'); title('tilt angle \beta distributions');
	save('thetas.mat','thetas'); 