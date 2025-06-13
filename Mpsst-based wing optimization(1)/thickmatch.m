function [thickdistribution,bestobjvalue,ququ] = thickmatch(bestindividual,thickpredict,nsubergion,minlayer,difthick)
%THICKMATCH Match the thickness for the best individual to obtain the number of layers in each region
Weight=1.563*10^(-6)*0.191*[278770 278770 154940 154940 154940  278770 278770 278770 278770 154940 154940 ];%Single-layer weight of each subregion
SST = sequence(bestindividual,minlayer,difthick);
breaksign = 0;
bestobjvalue=0;
for id = 1:nsubergion 
    thickdistribution(1,id) = 2*thickpredict(1,id);
    ququ(id) = ququcal(id,thickdistribution(1,id),SST);
    if ququ(id) < 1
        while ququ(id) < 1  
            thickdistribution(1,id) = thickdistribution(1,id)+1;
            if thickdistribution(1,id) > max(thickpredict)*2+10
                thickdistribution(1,id) = 100;
                breaksign = 1;
                break
            end
            ququ(id) = ququcal(id,thickdistribution(1,id),SST);
            
        end

    else    
        while ququ(id) >= 1
            thickdistribution(1,id) = thickdistribution(1,id)-1; 
            if thickdistribution(1,id) == size(minlayer,2)-1
                break
            end
            ququ(id) = ququcal(id,thickdistribution(1,id),SST);
        end
        thickdistribution(1,id) = thickdistribution(1,id)+1;
        ququ(id) = ququcal(id,thickdistribution(1,id),SST);
    end
    if breaksign == 1
        bestobjvalue = 1000;
        break
    end
    bestobjvalue = bestobjvalue + thickdistribution(1,id)*Weight(1,id);
end %nsubregion

end

