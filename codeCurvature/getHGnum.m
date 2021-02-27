function [H,G, k1,k2]= getHGwindow(z, d)
% getHGwindow returns H and G at a local 3x3 window
% [H,G, k1,k2]= getHGwindow(zss ,d)

	d2= d^2;
	zx= (z(3,2)-z(1,2))/(2*d);
	zy= (z(2,3)-z(2,1))/(2*d); 
	zxy= (z(3,3)-z(3,1)-z(1,3)+z(1,1))/(4*d2);
	zxx= (z(3,2)-2*z(2,2)+z(1,2))/d2;
	zyy= (z(2,3)-2*z(2,2)+z(2,1))/d2;
		
	S= sqrt(1+zx^2+zy^2);
	H= ((1+zy^2)*zxx+(1+zx^2)*zyy-2*zx*zy*zxy)/(2*S^3); 
	G= (zxx*zyy-zxy^2)/S^4;
    
    discr= H^2-G; 
    if discr < 0.0
        discr =-discr; 
        disp('.');
    end
    discr= sqrt(discr);
    
    k1= H+discr; k2= H-discr;
    k1= k1; k2= k2; 
end