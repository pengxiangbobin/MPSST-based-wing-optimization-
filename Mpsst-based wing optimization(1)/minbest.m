%% Selection of the Best Fitness Function

% Input variables: pop - population
%                  fitvalue - population fitness
% Output variables: bestindividual - best individual
%                   bestfit - best fitness value
function [bestindividual,bestfit,bestMAXIMUMDISPLACEMENTS,bestMAXIMUMVONMISES] = minbest(pop,fitvalue,MAXIMUMDISPLACEMENTS,MAXIMUMVONMISES)
[px,py] = size(pop);
bestindividual = pop(1,:);

bestMAXIMUMDISPLACEMENTS = MAXIMUMDISPLACEMENTS(1);
bestMAXIMUMVONMISES = MAXIMUMVONMISES(1);
bestfit = fitvalue(1);
for i = 2:px-1                  
    if fitvalue(i) > bestfit
        bestindividual = pop(i,:);
        
     
        bestMAXIMUMDISPLACEMENTS = MAXIMUMDISPLACEMENTS(i);
        bestMAXIMUMVONMISES = MAXIMUMVONMISES(i);
        bestfit = fitvalue(i);
    end
end