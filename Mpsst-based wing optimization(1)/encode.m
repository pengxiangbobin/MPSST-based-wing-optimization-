function minlayercode = encode(layercode)
%ENCODE Layer angle encoding
chr = size(layercode,2);
for i = 1:1:chr
 if layercode(1,i) == 0 
            a = 0 ;                     
    elseif  layercode(1,i) == 15 
            a = 1;
     elseif  layercode(1,i) == -15
            a = 2;
     elseif  layercode(1,i) == 30 
            a = 3   ;        
     elseif  layercode(1,i) == -30 
            a = 4   ;
    elseif  layercode(1,i) == 45 
            a = 5    ;
    elseif  layercode(1,i) == -45
            a = 6    ;
    elseif  layercode(1,i) == 60 
            a = 7    ;
    elseif  layercode(1,i) == -60 
            a = 8    ;
    elseif  layercode(1,i) == 75 
            a = 9    ;
    elseif  layercode(1,i) == -75
            a = 10  ;
    elseif  layercode(1,i) == 90 
            a = 11     ;   
    end
     minlayercode(1,i) = a;
end

