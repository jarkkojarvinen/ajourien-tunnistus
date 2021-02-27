d= 0.05; 
x= -10:d:10; y= -10:d:10; n= length(x); [X,Y]= meshgrid(x,y);
global A; global B; global C; global D; global E; global F; global p1; global p2; 
A= 0.3; B= 0.4; C= 2.8; D= 10.0; E= 5.0; F= 0.4; p1= [-5, 5]; p2= [ 5,-4];
global case3counter; case3counter= 0;

if 1
    Z= sin(A*X.*Y)+B*sin(2*X).*cos(2*Y) + C*cos(sqrt(X.^2 + Y.^2)*(pi/2)/D);
    Z= Z+ E*exp(-((X-p1(1)).^2+ (Y-p1(2)).^2)/F);
    Z= Z- E*exp(-((X-p2(1)).^2+ (Y-p2(2)).^2)/F);
else
    r= 100.0;
    Z= sqrt(r^2 - X.^2 - Y.^2);
end

% learn to predict: CC+ case (case 4)
G3= zeros(n,n); G4= zeros(n,n);
for i=2:(n-1)
	indsI= (i-1):(i+1);
	for j=2:(n-1)
		indsJ= (j-1):(j+1);
		[Hij,Gij, k1ij,k2ij]= getHGCC(Z(indsI,indsJ),d); G3(i,j)= Gij;
		[Hijf,Gijf, k1ijf,k2ijf]= getHGCCface(Z(indsI,indsJ),d); G4(i,j)= Gijf;
	end
end

global Z;

fun= @(pars)getGDiff(Z,G4, pars);
options= optimset('TolFun', 0.8, 'Display','iter','PlotFcns',@optimplotfval);
[x,fval,exitflag] = fminsearch(fun,pars0,options);

set(findall(gcf,'-property','FontSize'),'FontSize',12);