function err= getGDiff(Z,G4, pars)
% getGDiff returns the mean abs. diff. between G4 and the f(Z, pars)
% err= getGDiff(Z,G4, pars)

	n= size(Z,1); err= 0.0; 
	for i=2:(n-1)
		indsI= (i-1):(i+1);
		for j=2:(n-1)
			indsJ= (j-1):(j+1);
			err= err + (approxG(Z(indsI,indsJ), pars) - G4(i,j))^2;
		end
	end
	err= err/n^2;
end