function err= approxG(z, pars)
% approxG approximates G on the 4 faces around z_{00} 
% err= approxG(z, pars)

	inds= struct('is',[],'js',[]);
	err= f(z(1:2,1:2), pars, [0.5,1.0],[0.5,1.0])+...;
		 f(z(2:3,1:2), pars, [0.0,0.5],[0.5,1.0])+...;
		 f(z(2:3,2:3), pars, [0.0,0.5],[0.0,0.5])+...;
		 f(z(1:2,2:3), pars, [0.5,1.0],[0.0,0.5]);
end