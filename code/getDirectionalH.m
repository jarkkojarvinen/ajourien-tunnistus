function [H,s]= getDirectionalH(alpha,delta)
% getDirectionalH returns the directional curvature and slope 
% [H,s]= getDirectionalH(alpha,delta)
% H: curvature, s: slope 
global z; global zs; 
    [u1,h]= alpha2u(alpha); h= h*delta; 
    
    % 1) z(alpha), l(alpha), beta(alpha)
    uf= floor(u1); uc= ceil(u1); t= u1 - uf;
    z1= zs(uf+1).z * (1-t) + zs(uc+1).z * t; % matlab indexing starts from 1!
    beta1= atan2(z1 - z,h);
    l1= h ./ cos(beta1);
    
    % 2) z(alpha+pi), l(alpha+pi), beta(alpha+pi)
    u2= mod(u1 + 4,8); % +pi in alpha --> +4 in u
    uf= floor(u2); uc= ceil(u2); t= u2 - uf;
    z2= zs(uf+1).z * (1-t) + zs(uc+1).z * t; % matlab indexing starts from 1!
    beta2= atan2(z2 - z,h); 
	s= abs(z2 - z1)/(2*h); clear z1; clear z2;
    l2= h ./ cos(beta2);
    
    % 3) 
    H= -2.0* (beta1 + beta2) ./ (l1 + l2);
end