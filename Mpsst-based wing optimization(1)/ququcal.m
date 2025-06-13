function ququ = ququcal(id,th,SST)
%QUQUCAL 
Nxx = 0.1751*[700 375 270 250  305   1100 900 375 400 330   815  ];%Force acting on the x-axis
Nyy = 0.1751*[400 360 325 200  360   600 400 525 320 330   1000  ];%Force acting on the y-axis
F=[ 0  0  0  0  0  0  ] ; % [Nx Ny Nxy Mx My Mxy] (N/mm & Nmm/mm)
F(1,1) = Nxx(1,id);
F(1,2) = Nyy(1,id);
Dir = zeros;
for u=1:size(SST,2)
if size(SST{1,u},2)==th
    Dir= SST{1,u};
end
end


b = 305;%Length of the y-axis
a = 508;%Length of the x-axis
if id==1|id==2|id==6|id==7|id==8|id==9
b = 610;%Length of the y-axis
a = 457;%Length of the x-axis
end

E1= 141;  %Young's moduli-1[GPa]  121   
E2= 9.03;          %Ypung's moduli-2[Gpa]   8.6   9.03
G12= 4.27;   %Shear modules   [Gpa]   4.7      4.27
miu12=  0.32;      %Poisson;s ratio                0.32
t=  0.191;   %thickness       [mm]  5/4

fail=[2.583  1.483  0.092 0.27  0.106   2.583  1.483  0.092 0.27  0.106 ];
Nx=F(1,1);
Ny=F(1,2);
Nxy=F(1,3);
Mx=F(1,4);
My=F(1,5);
Mxy=F(1,6);

Xt=fail(1,1);  %Xt  Tensile strength in the vertical direction
Xc=fail(1,2);  %Xc  Compressive strength in the vertical direction
Yt=fail(1,3);  
Yc=fail(1,4);
St=fail(1,5);
Xet=fail(1,6);
Xec=fail(1,7);
Yet=fail(1,8);
Yec=fail(1,9);
Gt=fail(1,10);

%%
n=size(Dir,2);           %the number of the layers
T(1,1:n)=t;
h=sum(T);                %total thickness of the laminate
mech=[E1,E2,G12,miu12];   %mechanical properities
%%
A=zeros(3,3);
B=zeros(3,3);
D=zeros(3,3);
z0=-h/2;
Q0=layer(mech,0);
for i=1:n  % Qi [GPa]
    Qi{1,i}=layer(mech,Dir(1,i));
    z(1,i)=z0+sum(T(1,1:i));
    Ti{1,i}=Tr(Dir(1,i));
end
for i=1:n
    if i==1
        A=Qi{1,i}*(z(1,i)-z0)*1000;
        B=Qi{1,i}*1/2*(z(1,i)^2-z0^2)*1000;
        D=Qi{1,i}*1/3*(z(1,i)^3-z0^3)*1000;
    else
        A=A+Qi{1,i}*(z(1,i)-z(1,i-1))*1000;
        B=B+Qi{1,i}*1/2*(z(1,i)^2-z(1,i-1)^2)*1000;
        D=D+Qi{1,i}*1/3*(z(1,i)^3-z(1,i-1)^3)*1000;
    end
end
ABD=[A B;B D];% A[N/mm] /B[N]  D[Nmm]

D11 = D(1,1);
D22 = D(2,2);
D12 = D(1,2);
D66 = D(3,3);

for m = 1:3
    for n = 1:3
        % % Critical buckling load factor under biaxial compression
        Nx_1 = pi^2*(D11*(m/a)^4+2*(D12+2*D66)*(m/a)^2*(n/b)^2+D22*(n/b)^4)/((m/a)^2*Nx+(n/b)^2*Ny);
        Nx_2(m,n) = Nx_1;
    end
end
ququyz = min(min(Nx_2));
ququ = ququyz;
end