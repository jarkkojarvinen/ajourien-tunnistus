function [H,G, kappa1,kappa2]= getHGdirectional(z, delta)
% getHGdirectional returns H and G at a local 3x3 window
% [H,G, k1,k2]= getHGwindow(z,n, d)

	m= 8; % number of orientations
	alphas= linspace(0.0,pi*(1-1/(m-1)), m); % alpha(m+1) would be pi
    kappas= zeros(1,m); 
    zs= [z(3,2),z(3,3),z(2,3),z(1,3),z(1,2),z(1,1),z(2,1),z(3,1),z(3,2)];
    z0= z(2,2);
	for k=1:m
		alpha= alphas(k); 
		u= getU(alpha)+1;
		u1= floor(u); u2= ceil(u); 
        if u1 == u2
            t= 0.0; 
        else
            t= u-u1;
        end

        try
            z1= zs(u1)*(1-t) + zs(u2)*t;
            z2= zs(u1+4)*(1-t) + zs(u2+4)*t;
        catch
            disp('!');
        end

        temp= min(abs(sin(alpha)),abs(cos(alpha)));
        dHoriz= delta*sqrt(1+temp^2);
        dZ1= z1-z0; dZ2= z0-z2;
        l1= sqrt(dZ1^2 + dHoriz^2);
        l2= sqrt(dZ2^2 + dHoriz^2);
        beta1= atan(dZ1/dHoriz); beta2= atan(dZ2/dHoriz);
        
        kappas(k)= 2*(beta1-beta2)/(l1+l2);
    end
    kappa1= max(kappas); kappa2= min(kappas);
    H= (kappa1+kappa2)/2; G= kappa1*kappa2; 
end