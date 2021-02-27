function [H,G, k1,k2]= getHGCC(z, d)
% getHGCC returns H and G at a local 3x3 window based on CC
% [H,G]= getHGCC(zss ,d)
global case3counter;

    for k=1:3
        thX(k)= atan((z(k,3) - z(k,2))/d) - atan((z(k,2) - z(k,1))/d);
        thY(k)= atan((z(3,k) - z(2,k))/d) - atan((z(2,k) - z(1,k))/d);
    end

    d2= d^2;
    inds= [1,3];
    for k0=1:2
        k= inds(k0);
        lx(k0)= sqrt((z(k,2)-z(2,2))^2 + d2); 
        ly(k0)= sqrt((z(2,k)-z(2,2))^2 + d2); 
    end

    A= (lx(1)+lx(2))*(ly(1)+ly(2))/4;
    
    if 1
        G= thX(2)*thY(2)/A; 
        if G < 0.0
            G= G; %*3;
        else
            G= G; %*(2/3);
        end
        H= thY(2)/(lx(1)+lx(2)) + thX(2)/(ly(1)+ly(2));
        H= H; 
    else
        G= (thX(1)+2*thX(2)+thX(3))*(thY(1)+2*thY(2)+thY(3))/(16*A);
        if G < 0.0
            G= G;% G*3;
        else
            G= G;%G*(2/3);
        end
        H= (thY(1)+2*thY(2)+thY(3))/(lx(1)+lx(2))...
        +  (thX(1)+3*thX(2)+thX(3))/(ly(1)+ly(2));
        H= -H/4;
    end

    discr= H^2-G; 
    if discr < 0.0
        discr =-discr; 
        case3counter= case3counter+1; 
    end
    discr= sqrt(discr);
    
    k1= H+discr; k2= H-discr;
end