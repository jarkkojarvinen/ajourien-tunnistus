function [H,G, k1,k2]= getHGsynth(x,y)
% getHGsynth returns H and G at x,y
% [H,G]= getHGsynth(x,y)
% z= A0*sin(A*X.*Y)+B*sin(2*X).*cos(2*Y) + C*cos(sqrt(X.^2 + Y.^2)*(pi/2)/D) + f1+f2;
% z= A0*sin(A*X.*Y)+B*sin(2*X).*cos(2*Y) + C*cos(K*sqrt(X.^2 + Y.^2)) + f1+f2;

	global A0; global A; global B; global C; global D; global E; global F; 
    global p1; global p2;
    f1= E*exp(-((x-p1(1))^2+ (y-p1(2))^2)/F);
    f2=-E*exp(-((x-p2(1))^2+ (y-p2(2))^2)/F);
    K= pi/(2*D);

	r= sqrt(x^2 + y^2); 
	zx= A0*A*y*cos(A*x*y)+ 2*B*cos(2*x)*cos(2*y)- C*K*sin(r)*x/r;
    zx= zx -2*(-p1(1)+x)/F * f1 - 2*(-p2(1)+x)/F * f2;
    
	zy= A0*A*x*cos(A*x*y)- 2*B*sin(2*x)*sin(2*y)- C*K*sin(r)*y/r;
    zy= zy -2*(-p1(2)+y)/F * f1 - 2*(-p2(2)+y)/F * f2;

	zxx= -(C*K^2*x^2*cos(K*r))/r^2 - 4*B*cos(2*y)*sin(2*x) ... 
     -A0*A^2*y^2*sin(A*x*y) + (C*K*x^2*sin(K*r))/r^1.5 ... 
     -(C*K*sin(K*r))/r;
    zxx= zxx+ (-2/F+ 4/F^2*(-p1(1)+x)^2 )*f1;
    zxx= zxx+ (-2/F+ 4/F^2*(-p2(1)+x)^2 )*f2;

	zyy= -(C*K^2*y^2*cos(K*r))/r^2 - 4*B*cos(2*y)*sin(2*x) ... 
     -A0*A^2*x^2*sin(A*x*y) + (C*K*y^2*sin(K*r))/r^1.5 ... 
     -C*K*sin(K*r)/r;
    zyy= zyy+ (-2/F+ 4/F^2*(-p1(2)+y)^2 )*f1;
    zyy= zyy+ (-2/F+ 4/F^2*(-p2(2)+y)^2 )*f2;

	zxy= A0*A*cos(A*x*y)- (C*K^2*x*y*cos(K*r))/r^2 ... 
     -4*B*cos(2*x)*sin(2*y)- A0*A^2*x*y*sin(A*x*y) ... 
     -(C*K*x*y*sin(K*r))/r^1.5;
    zxy= zxy+ 4/F^2*(-p1(1)+x)*(-p1(2)+y)*f1;
    zxy= zxy+ 4/F^2*(-p2(1)+x)*(-p2(2)+y)*f2;
	
	S= sqrt(1+zx^2+zy^2); 
	H= (1+zy^2)*zxx + (1+zx^2)*zyy - 2*zx*zy*zxy; H= H/(2*S^3); 
	G= (zxx*zyy-zxy^2)/S^4;
    
    discr= H^2-G; 
    if discr < 0.0
        discr =-discr; 
        disp('.');
    end
    discr= sqrt(discr);
    
    k1= H+discr; k2= H-discr;
end