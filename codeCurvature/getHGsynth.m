function [H,G, k1,k2]= getHGsynth(x,y)
% getHGsynth returns H and G at x,y
% [H,G, k1,k2]= getHGsynth(x,y)
% z= A0*sin(A*X.*Y)+B*sin(2*X).*cos(2*Y) + C*cos(sqrt(X.^2 + Y.^2)*(pi/2)/D) + f1+f2;
% z= A0*sin(A*X.*Y)+B*sin(2*X).*cos(2*Y) + C*cos(K*sqrt(X.^2 + Y.^2)) + f1+f2;

	global A0; global A; global B; global C; global D; global E1; global F; 
    global p1; global p2;
    f1= E1*exp(-((x-p1(1))^2+ (y-p1(2))^2)/F);
    f2=-E1*exp(-((x-p2(1))^2+ (y-p2(2))^2)/F);
    K= pi/(2*D);

	r= sqrt(x^2 + y^2); 
	zx= (-2*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1*(-p1(1) + x))/F ... 
     -  (2*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1*(-p2(1) + x))/F ... 
     -  2*B*cos(2*x)*cos(2*y) + A*A0*y*cos(A*x*y) ...
     -  (C*K*x*sin(K*sqrt(x^2 + y^2)))/sqrt(x^2 + y^2);
    
	zy= (-2*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1*(-p1(2) + y))/F ... 
     -  (2*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1*(-p2(2) + y))/F + A*A0*x*cos(A*x*y) ... 
     -  2*B*sin(2*x)*sin(2*y) - (C*K*y*sin(K*sqrt(x^2 + y^2)))/sqrt(x^2 + y^2);
	 
	zxx= (-2*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1)/F ...
     -  (2*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1)/F ...
     -  (4*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1*(-p1(1) + x)^2)/F^2 ... 
     -  (4*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1*(-p2(1) + x)^2)/F^2 ...
     -  (C*K^2*x^2*cos(K*sqrt(x^2 + y^2)))/(x^2 + y^2) - 4*B*cos(2*y)*sin(2*x) ... 
     -  A^2*A0*y^2*sin(A*x*y) + (C*K*x^2*sin(K*sqrt(x^2 + y^2)))/(x^2 + y^2)^1.5 ... 
     -  (C*K*sin(K*sqrt(x^2 + y^2)))/sqrt(x^2 + y^2);

	zyy= (-2*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1)/F ...
     -  (2*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1)/F ...
     -  (4*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1*(-p1(2) + y)^2)/F^2 ...
     -  (4*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1*(-p2(2) + y)^2)/F^2 ...
     -  (C*K^2*y^2*cos(K*sqrt(x^2 + y^2)))/(x^2 + y^2) - 4*B*cos(2*y)*sin(2*x) ... 
     -  A^2*A0*x^2*sin(A*x*y) + (C*K*y^2*sin(K*sqrt(x^2 + y^2)))/(x^2 + y^2)^1.5 ... 
     -  (C*K*sin(K*sqrt(x^2 + y^2)))/sqrt(x^2 + y^2);

	zxy= (4*exp((-(-p1(1) + x)^2 - (-p1(2) + y)^2)/F)*E1*(-p1(1) + x)*(-p1(2) + y))/F^2 ... 
     -  (4*exp((-(-p2(1) + x)^2 - (-p2(2) + y)^2)/F)*E1*(-p2(1) + x)*(-p2(2) + y))/F^2 ...
     -  A*A0*cos(A*x*y) - (C*K^2*x*y*cos(K*sqrt(x^2 + y^2)))/(x^2 + y^2) ...
     -  4*B*cos(2*x)*sin(2*y) - A^2*A0*x*y*sin(A*x*y) ...
     -  (C*K*x*y*sin(K*sqrt(x^2 + y^2)))/(x^2 + y^2)^1.5;
	
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