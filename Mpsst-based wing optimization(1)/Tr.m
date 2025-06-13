function [T]=Tr(a)   % T is the coordinate transformation matrix. It can be used to express stress components in the off-axis x-y coordinate system in terms of stress components in the material's principal direction
m=cosd(a);
n=sind(a);
T=[m^2 n^2 2*m*n;
    n^2 m^2 -2*m*n;
    -m*n m*n m^2-n^2];
end