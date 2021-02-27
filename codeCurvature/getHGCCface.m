function [H,G, k1,k2]= getHGCCface(z, d)
% getHGCCface returns H and G at a local 3x3 window based on CC face integrals
% [H,G]= getHGCCface(zss ,d,A)
    global case3counter; 

	inds= struct('is',[],'js',[]); 
	inds(1).is= 1:2; inds(1).js= 1:2;  
	inds(2).is= 2:3; inds(2).js= 1:2;  
	inds(3).is= 2:3; inds(3).js= 2:3;  
	inds(4).is= 1:2; inds(4).js= 2:3;  
 
	uvs= struct('uvs',[]);
	uvs(1).uvs= [5,7,7,5; 5,5,7,7]/8; 
	uvs(2).uvs= [1,3,3,1; 5,5,7,7]/8; 
	uvs(3).uvs= [1,3,3,1; 1,1,3,3]/8; 
	uvs(4).uvs= [5,7,7,5; 1,1,3,3]/8; 
	
	HG= [0,0];
	for k=1:4
		indsI= inds(k).is; indsJ= inds(k).js;
		uvsK= uvs(k).uvs; 
		for l=1:4
			u= uvsK(1,l); v= uvsK(2,l); 
			HG= HG+ getHG(z(indsI,indsJ),d, u,v);
		end
	end
	HG= HG/16; 
	
	if 0
		HG= getHG(z(1:2,1:2),d, 0.75,0.75) + getHG(z(2:3,1:2),d, 0.25,0.75)+...
			getHG(z(2:3,2:3),d, 0.25,0.25) + getHG(z(1:2,2:3),d, 0.75,0.25);
		HG= HG/4;
	end
	H= HG(1); G= HG(2);

    discr= H^2-G; 
    if discr < 0.0
        discr =-discr; 
        case3counter= case3counter+1; 
    end
    discr= sqrt(discr);
    
    k1= H+discr; k2= H-discr;
end