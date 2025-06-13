% Selection Operation
% Input variables: pop - population
% fitvalue - fitness values
% Output variable: newpop - selected population

function [newpop] = minselection(pop,fitvalue)
[px,py] = size(pop);   %Construct a roulette wheel
totalfit = sum(fitvalue);
p_fitvalue = fitvalue/totalfit;
p_fitvalue = cumsum(p_fitvalue); %Probability summation and sorting. cumsum(A,1) returns the cumulative sum along the first dimension (columns), while cumsum(A,2) returns the cumulative sum along the second dimension (rows)
newpop = zeros(px, size(pop, 2)); % 根据 pop 的大小初始化 newpop
ms = rand(px, 1);  % 生成介于 0 到 1 之间的随机数
fitin = 1;
newin = 1;
    while newin <= px && fitin <= px
        if ms(newin) < p_fitvalue(fitin)
            newpop(newin, :) = pop(fitin, :);
            newin = newin + 1; % 进入新种群的索引加1
        else
            fitin = fitin + 1; % 适应度索引加1
        end
    end
end