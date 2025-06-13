function Dir=decode(bestindividual)
%Angle decoding.
chr = size(bestindividual,2);
for i = 1:1:chr
    if bestindividual(1,i) == 0 
            a = 0 ;                       
    elseif  bestindividual(1,i) == 1 
            a = 15;
     elseif  bestindividual(1,i) == 2
            a = -15;
     elseif  bestindividual(1,i) == 3 
            a = 30  ;         
     elseif  bestindividual(1,i) == 4 
            a = -30  ; 
    elseif  bestindividual(1,i) == 5 
            a = 45   ; 
    elseif  bestindividual(1,i) == 6
            a = -45  ;  
    elseif  bestindividual(1,i) == 7 
            a = 60   ; 
    elseif  bestindividual(1,i) == 8 
            a = -60   ; 
    elseif  bestindividual(1,i) == 9 
            a = 75   ; 
    elseif  bestindividual(1,i) == 10 
            a = -75  ;
    elseif  bestindividual(1,i) == 11 
            a = 90    ;    
    end
     Dir(1,i) = a ;
end

%      Dir1 = fliplr(Dir)         
%      Dir = [Dir,Dir1]


