function [H,G]= getCurvatures(zss,delta, i,j)
% getCurvatures calculates G and H at (x_i,y_j,z_{ij})
% [H,G]= getCurvatures(zss,delta, i,j)
    
    zssLocal= zss((i-1):(i+1),(j-1):(j+1));
    C= getC(zssLocal,delta);
    x= 0.0; y= 0.0; 
end