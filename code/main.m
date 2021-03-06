disp('reading stuff');
temp= load('../data/z2.mat'); z0= temp.z; sz0= size(z0); 
mask= temp.mask; clear temp; 

kSkip= 64; % can be 1,2,4,6,8,... (no odd numbers 3,5,... allowed)
delta= kSkip*0.03292; % (m) grid constant
if kSkip == 1
    dls= [1,1];
else
    l= kSkip/2; % kSkip has to be odd!
    dls= [1,1; l+1,1; 1,l+1; l+1,l+1];
end
nDls= size(dls,1);

global z; 
Hfinal= 0*z0; Afinal= 0*z0; sFinal= 0*z0; 
indsXUsed= []; indsYUsed= [];
for l=1:nDls
    lFactor= (l-1)/nDls; % work amount... 
    dl= dls(l,:); 
    indsLx= dl(1):sz0(1); indsLx= indsLx(1:kSkip:end);
    indsLy= dl(2):sz0(2); indsLy= indsLy(1:kSkip:end);
    z= z0(indsLx,indsLy); sz= size(z);

    disp(sprintf('directional curvatures, %.1f %% done', lFactor*100));
    global zs; initZs; % --> zs
    %alphas= 0.0:45.0:180.0; alphas= alphas(1:(end-1))*pi/180.0;
    alphas=  0.0:15.0:180.0; alphas= alphas(1:(end-1))*pi/180.0;
    nAlphas= length(alphas);
    data= struct('H',[],'J',[],'s',[]); % curvature, entropy, slope
    for k=1:nAlphas
        alpha= alphas(k);
        [H,s]= getDirectionalH(alpha,delta);
        data(k).H= H; data(k).J= entropyfilt(H); data(k).s= s;
    end

    disp('assembling an image from entropy minimae');
    Js= zeros(1,nAlphas); counter= 0; dCounter= 100000; nAll= prod(sz);
    A= 0*H; % aspects
    for i=1:sz(1)
        for j=1:sz(2)
            if mod(counter,dCounter) == 0
                disp(sprintf('%.1f %% done', (lFactor+counter/(nAll*nDls))*100));
            end
            counter= counter+1;

            for k=1:nAlphas
                Js(k)= data(k).J(i,j);
            end
            [~,k]= min(Js);
            H(i,j)= data(k).H(i,j);
            A(i,j)= k;
			s(i,j)= data(k).s(i,j);
        end
    end
    
    Hfinal(indsLx,indsLy)= H;
    Afinal(indsLx,indsLy)= A;
	sFinal(indsLx,indsLy)= s;
    indsXUsed= [indsXUsed, indsLx];
    indsYUsed= [indsYUsed, indsLy];
end
indsXUsed= sort(unique(indsXUsed)); 
indsYUsed= sort(unique(indsYUsed)); 
H= Hfinal(indsXUsed,indsYUsed); clear Hfinal; 
A= Afinal(indsXUsed,indsYUsed); clear Afinal;
s= sFinal(indsXUsed,indsYUsed); clear sFinal;
mask= mask(indsXUsed,indsYUsed);

% mask the non-target zone away from the histograms
m= reshape(mask,prod(size(mask)),1); inds= find(m);
Htemp= reshape(H,prod(size(H)),1); Htemp= Htemp(inds);    
[fk,kappaBins]= hist(Htemp, 80); clear Htemp;

% mask the margins away from the histograms
fk= fk/trapz(kappaBins,fk); cfk= cumsum(fk)/sum(fk); eps= 0.05; 
[~,i1]= min(abs(cfk-eps)); [~,i2]= min(abs(cfk-(1-eps)));
Hmin= kappaBins(i1); Hmax= kappaBins(i2); % 90 % of values within [Hmin,Hmax]

sTemp= reshape(s,prod(size(s)),1); stemp= sTemp(inds);    
[fs,sBins]= hist(sTemp, 80); 
fs= fs/trapz(sBins,fs); cfs= cumsum(fs)/sum(fs); eps= 0.005;
[~,i3]= min(abs(cfs-eps)); [~,i4]= min(abs(cfs-(1-eps)));
sMin= sBins(i3); sMax= sBins(i4); % 90 % of values within [sMin,sMax]

figure(1); 
	subplot(1,2,1); semilogy(kappaBins,fk); 
    xlabel('\kappa (m^{-1}'); ylabel('freq (m)'); title('\kappa histogram');
	subplot(1,2,2); semilogy(sBins,fs);
    xlabel('slope (1)'); ylabel('freq. (1)'); title('slope histogram');
    set(findall(gcf,'-property','FontSize'),'FontSize',12);

figure(2);
    imshow(H); caxis([Hmin,Hmax]); h= colorbar;
    h.Title.String= '\kappa (m^{-1})';
    title(['curvature with \delta= ',sprintf('%.2f',delta), ' (m)']);

figure(3);
    imshow(A); caxis([min(min(A)),max(max(A))]); h= colorbar;
    h.Title.String= 'k of \alpha_k (1...8)';
    title('aspect  index k of the aspect \alpha_k'); 
    set(findall(gcf,'-property','FontSize'),'FontSize',12);

figure(4);
    imshow(s); caxis([0.5,1.0]); % caxis([sMin,sMax]); 
    h= colorbar; h.YDir= 'reverse';
    h.Title.String= 'slope (1)';
    title(['slope with \delta= ',sprintf('%.2f',delta), ' (1)']); 
    set(findall(gcf,'-property','FontSize'),'FontSize',12);
