% run after mainSynthExample.m!

zss1= load('../z/S5233F.txt','-ascii'); sz= size(zss1); n1= sz(1); 
incrs= [1,2,3,4,6,8,10]; m= length(incrs); delta1= 2.0; % (m)
deltas= delta1*incrs;

thetas= load('thetas.mat'); thetas= thetas.thetas; 
thetas(2).bins= thetas(1).bins; 
thetas(2).fs= zeros(m,length(thetas(1).bins));
for k=1:m
	delta= deltas(k);
	inds= 1:incrs(k):m; n= length(inds);
	zss= zss1(inds,inds);
	
    theta= zeros(n,n);
	for i=2:(n-1)
		for j=2:(n-1)
			kx= (zss(i+1,j)-zss(i-1,j))/delta;
			ky= (zss(i,j+1)-zss(i,j-1))/delta;
			theta(i,j)= atan(sqrt(kx^2 + ky^2));
		end
	end
	[f,t]= hist(reshape(theta,1,n^2), thetas(2).bins); f= f/trapz(t,f); 
	thetas(2).fs(k,:)= f;

end

if 0
    subplot(2,1,1); plot(thetas(1).bins*180/pi, thetas(1).fs(1,:)); axis([0,80,0,5]);
    xlabel('\theta (^o)'); ylabel('freq.'); title('slope angle \theta distr. (synthetic case)');
    subplot(2,1,2); plot(thetas(2).bins*180/pi, thetas(2).fs); axis([0,80,0,5]);
    xlabel('\theta (^o)'); ylabel('freq.'); title('slope angle \theta distr. (real case)')
end