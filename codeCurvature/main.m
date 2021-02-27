kappa1= load('kappa1.txt','-ascii');
kappa2= load('kappa2.txt','-ascii'); sz= size(kappa2);

subplot(2,2,1); imshow(kappa1, [0,1]); title('\kappa_1 (m^{-1})');
subplot(2,2,2); imshow(kappa2, [-1,0]); title('\kappa_2 (m^{-1})');

subplot(2,2,3); 
    [f1,x]= hist(reshape(kappa1,prod(sz),1), 80); f1= f1/trapz(x,f1);
    semilogy(x,f1); axis([0,1,0.1,10]);
subplot(2,2,4); 
    [f2,x]= hist(reshape(kappa2,prod(sz),1), 80); f2= f2/trapz(x,f2);
    semilogy(x,f2); axis([-1,0,0.1,10]);