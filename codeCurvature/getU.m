function u= getU(alph)
% getU returns the perimeter length of a 3x3 subraster.
% u==0 & u==8 --> the (i+1,j) node (counterclockwise)

	alpha0= 0.0; alpha1= -pi/4; dAlpha= pi/2; alpha2= pi/4;
	u0= 0.0; 
	for i=1:4
		if alpha1 < alph & alph <= alpha2
			u= u0 + tan(alph-alpha0); 
			break; 
		else
			u0= u0+2; 
			alpha0= alpha0+dAlpha; alpha1= alpha1+dAlpha; alpha2= alpha2+dAlpha;
		end
	end
end