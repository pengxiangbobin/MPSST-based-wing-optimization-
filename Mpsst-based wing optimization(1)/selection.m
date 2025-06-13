% Selection Operation
% Input variables: pop - population
% fitvalue - fitness values
% Output variable: newpop - selected population

function [newpop_0,newpop_1,newpop_2,newpop_thick] = selection(pop_0,pop_1,pop_2, pop_thick, fitvalue)
    [px, py] = size(pop_0);

    % 检查适应度值
    if any(fitvalue < 0) || sum(fitvalue) <= 0
        % 出现问题，直接返回原始种群和厚度
        newpop_0 = pop_0;
        newpop_1 = pop_1;
        newpop_2 = pop_2;
        newpop_thick = pop_thick;
        return;
    end

    % 计算相对适应度和累积概率
    totalfit = sum(fitvalue);
    p_fitvalue = fitvalue / totalfit;
    p_fitvalue = cumsum(p_fitvalue);

    % 初始化新种群
    newpop_0 = zeros(px, py);
    newpop_1 = zeros(px, py);
    newpop_2 = zeros(px, py);
    newpop_thick = zeros(px, size(pop_thick, 2));

    % 生成随机数
    ms = rand(px, 1);

    % 选择个体
    for newin = 1:px
        % 使用随机数来选择个体
        fitin = sum(ms(newin) > p_fitvalue) + 1;  % 更高效的方式

        % 选择个体
        newpop_0(newin, :) = pop_0(fitin, :);
        newpop_1(newin, :) = pop_1(fitin, :);
        newpop_2(newin, :) = pop_2(fitin, :);
        newpop_thick(newin, :) = pop_thick(fitin, :);
    end
end