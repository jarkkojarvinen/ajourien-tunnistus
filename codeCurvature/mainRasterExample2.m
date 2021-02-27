% run after mainSynthExample.m!
global case3counter; case3counter= 0; 

disp('reading the map page'); 
Z= load('../z/S5233F.txt','-ascii'); sz= size(Z); 
inds= floor(sz(1)*0.6):floor(sz(1)*0.9);
Z= Z(inds,inds); sz= size(Z); n= sz(1);
delta= 2.0; % (m)
p1= [584,7296]*1.0e3; p2= [590,7302]*1.0e3;

caseNames= {'num','window','CC','CC+','OC'}; 
cases= struct('name','', 'H',[],'G',[], 'kappa1',[],'kappa2',[]);
Hscale= [-0.3,0.36]; % (m^{-1})
Gscale= [-0.02,0.07]; % (m^{-2})
k1scale= [-0.3,0.4]; k2scale= [-0.3,0.4];
X= p1(1)+ (0:(n-1))*delta; 
Y= p2(2)+ (0:(n-1))*delta;

for k=1:length(caseNames)
    aCaseName= caseNames{k};

    disp(['computing the ',aCaseName,' method']);
    cases(1).name= aCaseName;
        H= zeros(n,n); G= H; kappa1= H; kappa2= H;
        for i=2:(n-1)
            indsI= (i-1):(i+1);
            for j=2:(n-1)
                indsJ= (j-1):(j+1);
                if k==1
                    [Hij,Gij, k1ij,k2ij]= getHGnum(Z(indsI,indsJ),delta);
                elseif k==2
                    [Hij,Gij, k1ij,k2ij]= getHGwindow(Z(indsI,indsJ),delta);
                elseif k==3
                    [Hij,Gij, k1ij,k2ij]= getHGCC(Z(indsI,indsJ),delta);
                elseif k==4
                    [Hij,Gij, k1ij,k2ij]= getHGCC(Z(indsI,indsJ),delta);
                    [Hijf,Gijf, k1ijf,k2ijf]= ...
                        getHGCCface(Z(indsI,indsJ),delta);
                    Hij= Hij+Hijf; Gij= Gij+Gijf; 
                    k1ij= k1ij+ k1ijf; k2ij= k2ij+ k2ijf;
                else % k==5
                    [Hij,Gij, k1ij,k2ij]= ...
                        getHGdirectional(Z(indsI,indsJ),delta);
                end
                
                H(j,i)= Hij; G(j,i)= Gij;
                kappa1(j,i)= k1ij; kappa2(j,i)= k2ij; 
            end
        end
        cases(k).H= H; cases(k).G= G;
        cases(k).kappa1= kappa1; cases(k).kappa2= kappa2;

    disp(['plotting the ',aCaseName,' method']);
    if k==1 | k==5
        figure(k); 
            plotStuff(X,Y,Z, H,G,kappa1,kappa2);
            title(['curvature by ',aCaseName]);
    end
end

disp('readjusting color axes');
axesAll= [NaN,NaN; -0.05,0.05; -0.01,0.01; -0.05,0.05; -0.005,0.005];
for k=1:length(caseNames)
    figure(k);
    for l=2:5
        subplot(2,3,l);
        caxis(axesAll(l,:));
    end
end

if 0
    for k=1:3
        disp(sprintf('%d!',k));
        t1= cases(k).H; t2= cases(k).G; 
        [min(min(t1)),max(max(t1)),min(min(t2)),max(max(t2))]
        t1= cases(k).kappa1; t2= cases(k).kappa2;
        [min(min(t1)),max(max(t1)),min(min(t2)),max(max(t2))]
    end
end

if 1
    figure(6); subplot(1,2,1); 
        k11= reshape(cases(1).kappa1, 1,n^2);
        k21= reshape(cases(2).kappa1, 1,n^2);
        k51= reshape(cases(5).kappa1, 1,n^2);
        
        plot(k11,k51,'k.','markerSize',1); 
        xlabel('window \kappa_1 (m^{-1})');
        ylabel('OC \kappa_1 (m^{-1})');
        title('Window fit curvature and oriented curvatures');
        axis equal; axis([-0.15,0.3,-0.15,0.3]); grid on; 
        text(0.1,0.0,'corr= 0.98');
        
        subplot(1,2,2); 
        k12= reshape(cases(1).kappa2, 1,n^2);
        k22= reshape(cases(2).kappa2, 1,n^2);
        k52= reshape(cases(5).kappa2, 1,n^2);
        
        plot(k12,k52,'k.','markerSize',1); 
        xlabel('window \kappa_2 (m^{-1})');
        ylabel('OC \kappa_2 (m^{-1})');
        title('Window fit curvature and oriented curvatures');
        axis equal; axis([-0.2,0.15,-0.2,0.15]); grid on; 
        text(0.0,-0.1,'corr= 0.98');
        set(findall(gcf,'-property','FontSize'),'FontSize',12);
end