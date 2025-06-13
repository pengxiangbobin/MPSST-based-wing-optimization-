function newlayer = layerupdate(minlayer,i,j,popa,popu)
%LAYERUPDATE 
newlayer=minlayer;
for l=1:j

    if popa(i,l) == 0 
            a = 0 ;                      
    elseif  popa(i,l) == 1 
            a = 15;
     elseif  popa(i,l) == 2
            a = -15;
     elseif  popa(i,l) == 3 
            a = 30   ;        
     elseif  popa(i,l) == 4 
            a = -30   ;
    elseif  popa(i,l) == 5 
            a = 45    ;
    elseif  popa(i,l) == 6
            a = -45    ;
    elseif  popa(i,l) == 7 
            a = 60    ;
    elseif  popa(i,l) == 8 
            a = -60    ;
    elseif  popa(i,l) == 9 
            a = 75    ;
    elseif  popa(i,l) == 10 
            a = -75  ;
    elseif  popa(i,l) == 11 
            a = 90     ;   
    end


    newlayer=[newlayer(1:popu(i,l)),a,newlayer(popu(i,l)+1:end)];
end
end
