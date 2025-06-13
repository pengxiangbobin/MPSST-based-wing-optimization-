%% Selection of the Best Fitness Function

% Input variables: pop - population
%                  fitvalue - population fitness
% Output variables: bestindividual - best individual
%                   bestfit - best fitness value
function [bestpop_0,bestpop_1,bestpop_2,bestthick,bestfit,bestMAXIMUMDISPLACEMENTS,bestMAXIMUMVONMISES,bestmass,bestmaxTau12] = best(pop_0,pop_1,pop_2,pop_thick,fitvalue,MAXIMUMDISPLACEMENTS,MAXIMUMVONMISES,mass,maxTau12)
[px,py] = size(pop_0);
bestpop_0 = pop_0(1,:);
bestpop_1 = pop_1(1,:);
bestpop_2 = pop_2(1,:);
bestthick = pop_thick(1,:);
bestMAXIMUMDISPLACEMENTS = MAXIMUMDISPLACEMENTS(1);
bestMAXIMUMVONMISES = MAXIMUMVONMISES(1);
bestfit = fitvalue(1);
bestmass = mass(1);
bestmaxTau12 = maxTau12(1);
for i = 2:px-1                  
    if fitvalue(i) > bestfit
        bestpop_0 = pop_0(i,:);
        bestpop_1 = pop_1(i,:);
        bestpop_2 = pop_2(i,:);
        bestthick = pop_thick(i,:);
        bestMAXIMUMDISPLACEMENTS = MAXIMUMDISPLACEMENTS(i);
        bestMAXIMUMVONMISES = MAXIMUMVONMISES(i);
        bestfit = fitvalue(i);
        bestmass = mass(i);
        bestmaxTau12 = maxTau12(i);
    end
end