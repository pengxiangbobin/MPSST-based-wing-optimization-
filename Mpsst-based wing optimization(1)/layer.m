
%% function (assignment 1)
function [Qbar,Ex,Ey,Gxy,miuxy]=layer(data,a);
%%
E1=data(1,1);
E2=data(1,2);
G12=data(1,3);
miu12=data(1,4);
miu21=miu12*E2/E1;
S11=1/E1;
S12=-(miu21/E2);
S21=-(miu12/E1);
S22=1/E2;
S66=1/G12;
Sl=[S11 S12 0;S21 S22 0;0 0 S66];

m=cosd(a);
n=sind(a);
D=[m^4,      n^4 ,      2*m^2*n^2,      m^2*n^2;   % Stress-strain relationship in any direction.
   n^4,      m^4,       2*m^2*n^2,      m^2*n^2;
   4*m^2*n^2,4*m^2*n^2, -8*m^2*n^2,    (m^2-n^2)^2;
   m^2*n^2,   m^2*n^2,   m^4+n^4,     -m^2*n^2;
   2*m^3*n,   -2*m*n^3, 2*(m*n^3-m^3*n),m*n^3-m^3*n;
   2*m*n^3, -2*m^3*n,   2*(m^3*n-m*n^3), m^3*n-m*n^3;];
Sb=(D*[S11 S22 S12 S66]')';
Sbar=[Sb(1,1) Sb(1,4) Sb(1,5);
     Sb(1,4) Sb(1,2) Sb(1,6);
     Sb(1,5) Sb(1,6) Sb(1,3);] ;
 Ex=1/Sbar(1,1);
 Ey=1/Sbar(2,2);
 Gxy=1/Sbar(3,3);
 miuxy=-Ex*Sbar(1,2);
 miuyx=miuxy*Ey/Ex;
 Ql=inv(Sl);        
 Qbar=inv(Sbar);     % Stiffness matrix in any direction)
end