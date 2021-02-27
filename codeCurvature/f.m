function err= f(z, pars, us,vs)
% f approximates the definite integral of G 
% err= f(z, pars, us,vs)
	z= z-mean(mean(z));
	ijs= [1,1; 2,1; 2,2; 2,1; 1,1; 2,1; 2,2; 2,1]; 
	for k=1:4
		for l2=1:4 % new indices
			l1= l+k-1; % original indices
			zk(ijs(l2,1),ijs(l2,2))= z(ijs(l1,1),ijs(l1,2));
		end
	end
end