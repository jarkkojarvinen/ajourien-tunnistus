zs= struct('z',[]);

sz= size(z); n= sz(1); m= sz(2);
for i=1:9
    zs(i).z= z; 
end
xForw= [2:n,n]; xBack= [1,1:(n-1)];
yForw= [2:m,m]; yBack= [1,1:(m-1)];

zs(1).z= z(xForw, :   );
zs(2).z= z(xForw,yForw);
zs(3).z= z( :   ,yForw);
zs(4).z= z(xBack,yForw);
zs(5).z= z(xBack, :   );
zs(6).z= z(xBack,yBack);
zs(7).z= z( :   ,yBack);
zs(8).z= z(xForw,yBack);
zs(9).z= z(xForw, :   );

