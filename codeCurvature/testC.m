d= 2.0; % (m)
zss0 = [0.0, 0.5, 1.0; % x down, y sideways
        0.0, 0.5, 0.5; 
        0.0, 0.0, 1.0];    
C= getC(zss0,d);

funZ= @(x,y)([x^2,y^2,x,y,1]*C*[x^2,y^2,x,y,1]');

xs= -d:0.05:d; n= length(xs); ys= xs; ys2=xs(n:(-1):1); 
for i= 1:n
	for j=1:n
		zss(i,j)= funZ(xs(i),ys(j));
	end
end

mesh(xs,ys2,zss); hold on;
xlabel('x'); ylabel('y'); zlabel('z'); title('A P_{22} polynom fit on a 3x3 window');
 
ps= [-d,-d,zss0(1,1); % z_{-1-1}
     -d, 0,zss0(1,2); % z_{-10}
     -d, d,zss0(1,3); % z_{-11}
      0,-d,zss0(2,1); % z_{0-1}
      0, 0,zss0(2,2); % z_{00}
      0, d,zss0(2,3); % z_{01}
      d,-d,zss0(3,1); % z_{1-1}
      d, 0,zss0(3,2); % z_{10}
      d, d,zss0(3,3) ]; % z_{11}

plot3(ps(:,1),ps(:,2),ps(:,3),'o');
