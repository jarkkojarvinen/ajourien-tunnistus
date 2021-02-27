function [H,G, k1,k2]= getHGwindow(z, d)
% getHGwindow returns H and G at a local 3x3 window
% [H,G, k1,k2]= getHGwindow(zss ,d)

	d2= d^2;
	C10= (-z(2,1)+z(1,1))/(2*d);
	C01= ( z(1,2)-z(2,1))/(2*d); 
	C11= (-z(1,1)+z(1,3)+z(3,1)-z(3,3))/(4*d2);
	C20= ((z(2,1)+z(2,3))/2-z(2,2))/d2;
	C02= ((z(1,2)+z(3,2))/2-z(2,2))/d2;
	
	S= sqrt(1+C10^2+C01^2);
	H= ((1+C01^2)*C20+(1+C10^2)*C02-C10*C01*C11)/S^3; 
	G= (4*C20*C02-C11^2)/S^4;
    
    discr= H^2-G; 
    if discr < 0.0
        discr =-discr; 
        disp('.');
    end
    discr= sqrt(discr);
    
    k1= H+discr; k2= H-discr;
end