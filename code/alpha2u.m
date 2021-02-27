function [u,scale]= alpha2u(alpha)
% alpha2u maps a circle perimeter length alpha to a square perimeter length u
% [u,scale]= alpha2u(alpha)
% scale is the length of the mapping shift in case of a unit square
    c= cos(alpha); s= sin(alpha); scale= 1.0/max(abs(c),abs(s));
    x= c*scale; y= s*scale; eps= 1.0e-8;
    if     abs(x - 1.0) < eps & 0 <= y
        u= y;
    elseif abs(y - 1.0) < eps
        u= 2 - x;
    elseif abs(x + 1.0) < eps % x == -1
        u= 4 - y;
    elseif abs(y + 1.0) < eps % y == -1
        u= 6 + x; 
    else
        u= 8 + y;
    end
end