function HG= getHG(z,delta, u,v)
% getHG returns H and G at a local 3x3 window based on CC face integrals
% [H,G]= getHGCCface(z,d, u,v)

	b= z(2,1) - z(1,1);
	c= z(1,2) - z(1,1);
	d= z(1,1) - z(1,2) - z(2,1) + z(2,2);
	
	S= sqrt(delta^2 + (b+d*v)^2 + (c+d*u)^2);
	H= -(b+d*v)*(c+d*u)*d/S^3; % insignificant! 
	G= -d^2/S^4;
    HG= [H,G];
end