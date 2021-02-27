function nil= plotStuff(X,Y,Z, H,G,kappa1,kappa2)
%plotStuff plots curvature stuff
% nil= plotStuff(X,Y,Z, H,G,kappa1,kappa2)

    n= size(Z,1); 
    subplot(2,3,1);
        contourf(X,Y,Z,30, 'LineStyle','none'); axis equal; % shading interp;
        xlabel('x'); ylabel('y'); title('z');
        h= colorbar; set(get(h,'title'),'string','(m)');
    
    subplot(2,3,2);
        contourf(X,Y,H,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('H'); % caxis(Hscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,3);
        contourf(X,Y,G,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('G'); % caxis(Gscale);
        h= colorbar; set(get(h,'title'),'string','(m^{-2})'); 

    subplot(2,3,4); 
        contourf(X,Y,kappa1,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_1'); % caxis(k1scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,5); 
        contourf(X,Y,kappa2,20, 'LineStyle','none'); shading interp; axis equal;
        xlabel('x'); ylabel('y'); title('\kappa_2'); % caxis(k2scale);
        h= colorbar; set(get(h,'title'),'string','(m^{-1})'); 

    subplot(2,3,6); m= 200;
        k1s= reshape(kappa1,n^2 ,1); [f1,k1]= hist(k1s, m); 
        k2s= reshape(kappa2,n^2 ,1); [f2,k2]= hist(k2s, m); 
        semilogy(k1,f1,'b', k2,f2,'r');  % axis([-30,30,10,10^5]);
        xlabel('\kappa (m^{-1})'); ylabel('freq. (m)'); 
        title('princ. curv. distr.');
        legend('\kappa_1','\kappa_2'); axis([-0.2,0.2,10^1,10^5]); 
    
end

