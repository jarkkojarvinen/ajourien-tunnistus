function out= getC(zss,d)
% getC returns the C matrix of the z(u,v) function, given a local window zss
% out= getC(zss) % zss == zssLocal
	
	z= [zss(1,1),zss(1,2),zss(1,3),zss(2,1),zss(2,2),zss(2,3),zss(3,1),zss(3,2),zss(3,3)];
	A= (( z(1) + z(3) + z(7) + z(9))/4 - (z(2) + z(4) + z(6) + z(8))/2 + z(5))/ d^4;
	B= (( z(1) + z(3) - z(7) - z(9))/4 - (z(2) - z(8))/2)/ d^3;
	C= ((-z(1) + z(3) - z(7) + z(9))/4 + (z(4) - z(6))/2)/ d^3;
	D= (( z(4) + z(6))/2 - z(5))/ d^2;
	E= (( z(2) + z(8))/2 - z(5))/ d^2;
	F= ( -z(1) + z(3) + z(7) - z(9))/(4*d^2);
	G= ( -z(4) + z(6))/(2*d);
	H= (  z(2) - z(8))/(2*d);
	I= z(5);

	D= 2*D; E= 2*E; I= 2*I;
	out= [0, A, 0, B, 0;
	      A, 0, C, 0, 0;
		  0, C, D, F, G;
		  B, 0, F, E, H;
		  0, 0, G, H, I]*0.5;
end