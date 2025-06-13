function [newpop_0, newpop_1, newpop_2, newpop_thick] = crossoverdis(pop_0, pop_1, pop_2, pop_thick, pc, minlayer, difthick)
% CROSSOVERDIS
[px, py] = size(pop_0);
[pxt, pyt] = size(pop_thick);

% 初始化输出种群
newpop_0 = pop_0;
newpop_1 = pop_1;
newpop_2 = pop_2;
newpop_thick = pop_thick;


% 设置交叉的位置数组
array0 = [2,4,8,9,10,12,14,18,19,20,22,24,28,29,30,32,34,38,39,40];

% 使用 parfor 来并行处理种群
for i = 1:px-1
    % 创建临时变量 v 以避免对 newpop_0, newpop_1, newpop_2 的多次索引

    if mod(i, 2) == 1
        newpop_0(i, :) = pop_0(i, :);
        newpop_1(i, :) = pop_1(i, :);
        newpop_2(i, :) = pop_2(i, :);
        newpop_thick(i, :) = pop_thick(i, :);
        newpop_0(i+1, :) = pop_0(i+1, :);
        newpop_1(i+1, :) = pop_1(i+1, :);
        newpop_2(i+1, :) = pop_2(i+1, :);
        newpop_thick(i+1, :) = pop_thick(i+1, :);
        if rand < pc  % 交叉概率
            constb = 0;
            if rand < 0.5%对MPST0进行优化
                constraintCount = 0;
                exitFlag = 0;
                constb = 0;
                while constb <6
                    % 单点交叉
                    crossover_point = randi([1, difthick-1]);  % 随机选择一个交叉点
                    newpop_0(i,1:crossover_point) = pop_0(i,1:crossover_point);
                    newpop_0(i,crossover_point+1:difthick) = pop_0(i+1,crossover_point+1:difthick);
                    newpop_0(i,difthick+1:difthick+crossover_point) = pop_0(i,difthick+1:difthick+crossover_point);
                    newpop_0(i,difthick+crossover_point+1:end) = pop_0(i+1,difthick+crossover_point+1:end);
                    newpop_0(i+1,1:crossover_point) = pop_0(i+1,1:crossover_point);
                    newpop_0(i+1,crossover_point+1:difthick) = pop_0(i,crossover_point+1:difthick);
                    newpop_0(i+1,difthick+1:difthick+crossover_point) = pop_0(i+1,difthick+1:difthick+crossover_point);
                    newpop_0(i+1,difthick+crossover_point+1:end) = pop_0(i,difthick+crossover_point+1:end);
                    % 更新厚度矩阵
                    crossover_point_thick = randi([1, pyt-1]);  % 随机选择一个交叉点
                    newpop_thick(i,1:crossover_point_thick+1) = pop_thick(i, 1:crossover_point_thick+1);
                    newpop_thick(i,crossover_point_thick+1:end) = pop_thick(i+1, crossover_point_thick+1:end);
                    newpop_thick(i+1,1:crossover_point_thick+1) = pop_thick(i+1, 1:crossover_point_thick+1);
                    newpop_thick(i+1,crossover_point_thick+1:end) = pop_thick(i, crossover_point_thick+1:end);
                    newpop_thick(i:i+1,:) = rethick(newpop_thick(i:i+1,:),2);
                    %生成全新的MPST1、2

                    for k = 1:2%i个体
                            if constraintCount > 500
                                disp('constraintSST函数调用次数超过500，终止最外层循环');
                                exitFlag = 1;
                                break;
                            end
                        popa = zeros(1,difthick);
                        popu = zeros(1,difthick);
                        const = 0;
                        while const == 0
                            flag1 = 0;
                            for j = 1:difthick/2
                                innercounter = 1;
                                constj =0;
                                if flag1 ==1
                                    break
                                end
                                while constj ==0
                                    if flag1 ==1
                                        break
                                    end
                                    angdif = 1;
                                    randompostive = randi(2);
                                    if randompostive == 1
                                        numbers = [1, 3, 5, 7, 9, 11];  %Randomly select a positive angle
                                        while angdif == 1
                                            innercounter = innercounter+1;
                                            if innercounter > 100
                                                flag1 =1 ;
                                                break
                                            end
                                            thick_0 = newpop_thick(i, array0);
                                            MPST0 = sequence(newpop_0(i,:),minlayer,difthick);
                                            tranlayerthick = max(thick_0);
                                            if mod(tranlayerthick,2) == 1
                                                tranlayerthick = tranlayerthick+1;
                                            end
                                            for l = 1:length(MPST0)
                                                if length(MPST0{l}) == tranlayerthick
                                                    tranlayer1 = MPST0{l};
                                                    tranlayer1 = tranlayer1(1:floor(end/2));
                                                end
                                            end
                                            angel = numbers(randi(numel(numbers)));
                                            popa(1,2*j-1)=angel;
                                            popu(1,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                            popa(1,2*j)=angel+1;
                                            popu(1,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                            newlayer = layerupdate(tranlayer1,1,2*j,popa,popu);
                                            angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                                        end
                                    else
                                        numbers = [2, 4, 6, 8, 10];  %Randomly select a negative angle
                                        while angdif == 1
                                            innercounter = innercounter+1;
                                            if innercounter > 100
                                                flag1 =1 ;
                                                break
                                            end
                                            thick_0 = newpop_thick(i, array0);
                                            MPST0 = sequence(newpop_0(i,:),minlayer,difthick);
                                            tranlayerthick = max(thick_0);
                                            if mod(tranlayerthick,2) == 1
                                                tranlayerthick = tranlayerthick+1;
                                            end
                                            for l = 1:length(MPST0)
                                                if length(MPST0{l}) == tranlayerthick
                                                    tranlayer1 = MPST0{l};
                                                    tranlayer1 = tranlayer1(1:floor(end/2));
                                                end
                                            end
                                            angel = numbers(randi(numel(numbers)));
                                            popa(1,2*j-1)=angel;
                                            popu(1,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                            popa(1,2*j)=angel+1;
                                            popu(1,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                            newlayer = layerupdate(tranlayer1,1,2*j,popa,popu);
                                            angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                                        end

                                    end
                                    individual = [popa(1,1:2*j) popu(1,1:2*j)];
                                    constj = constraintSST(individual,tranlayer1,2*j);
                                                            constraintCount = constraintCount + 1;
                        if constraintCount > 500
                            disp('constraintSST函数调用次数超过500，终止最外层循环');
                            exitFlag = 1;
                            break;
                        end
                                end
                            end
                            individual = [popa(1,:) popu(1,:)];
                            const = constraintSST(individual,tranlayer1,difthick);
                                    constraintCount = constraintCount + 1;
                                    if constraintCount > 500
                                        disp('constraintSST函数调用次数超过500，终止最外层循环');
                                        exitFlag = 1;
                                        break;
                                    end
                        end

                        if k == 1
                            newpop_1(i,:) = [popa popu];
                        else
                            newpop_2(i,:) = [popa popu];
                        end
                    end

                    for k = 1:2%i+1个体
                        popa = zeros(1,difthick);
                        popu = zeros(1,difthick);
                        const = 0;
                        while const == 0
                            flag1 = 0;
                            for j = 1:difthick/2
                                innercounter = 1;
                                constj =0;
                                if flag1 ==1
                                    break
                                end
                                while constj ==0
                                    if flag1 ==1
                                        break
                                    end
                                    angdif = 1;
                                    randompostive = randi(2);
                                    if randompostive == 1
                                        numbers = [1, 3, 5, 7, 9, 11];  %Randomly select a positive angle
                                        while angdif == 1
                                            innercounter = innercounter+1;
                                            if innercounter > 100
                                                flag1 =1 ;
                                                break
                                            end
                                            thick_0 = newpop_thick(i+1, array0);
                                            MPST0 = sequence(newpop_0(i+1,:),minlayer,difthick);
                                            tranlayerthick = max(thick_0);
                                            if mod(tranlayerthick,2) == 1
                                                tranlayerthick = tranlayerthick+1;
                                            end
                                            for l = 1:length(MPST0)
                                                if length(MPST0{l}) == tranlayerthick
                                                    tranlayer2 = MPST0{l};
                                                    tranlayer2 = tranlayer2(1:floor(end/2));
                                                end
                                            end
                                            angel = numbers(randi(numel(numbers)));
                                            popa(1,2*j-1)=angel;
                                            popu(1,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                            popa(1,2*j)=angel+1;
                                            popu(1,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                            newlayer = layerupdate(tranlayer2,1,2*j,popa,popu);
                                            angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                                        end
                                    else
                                        numbers = [2, 4, 6, 8, 10];  %Randomly select a negative angle
                                        while angdif == 1
                                            innercounter = innercounter+1;
                                            if innercounter > 100
                                                flag1 =1 ;
                                                break
                                            end
                                            thick_0 = newpop_thick(i+1, array0);
                                            MPST0 = sequence(newpop_0(i+1,:),minlayer,difthick);
                                            tranlayerthick = max(thick_0);
                                            if mod(tranlayerthick,2) == 1
                                                tranlayerthick = tranlayerthick+1;
                                            end
                                            for l = 1:length(MPST0)
                                                if length(MPST0{l}) == tranlayerthick
                                                    tranlayer2 = MPST0{l};
                                                    tranlayer2 = tranlayer2(1:floor(end/2));
                                                end
                                            end
                                            angel = numbers(randi(numel(numbers)));
                                            popa(1,2*j-1)=angel;
                                            popu(1,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                            popa(1,2*j)=angel+1;
                                            popu(1,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                            newlayer = layerupdate(tranlayer2,1,2*j,popa,popu);
                                            angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                                        end

                                    end
                                    individual = [popa(1,1:2*j) popu(1,1:2*j)];
                                    constj = constraintSST(individual,tranlayer2,2*j);
                                                            constraintCount = constraintCount + 1;
                        if constraintCount > 500
                            disp('constraintSST函数调用次数超过500，终止最外层循环');
                            exitFlag = 1;
                            break;
                        end
                                end
                            end
                            individual = [popa(1,:) popu(1,:)];
                            const = constraintSST(individual,tranlayer2,difthick);
                                    constraintCount = constraintCount + 1;
                                    if constraintCount > 500
                                        disp('constraintSST函数调用次数超过500，终止最外层循环');
                                        exitFlag = 1;
                                        break;
                                    end
                        end

                        if k == 1
                            newpop_1(i+1,:) = [popa popu];
                        else
                            newpop_2(i+1,:) = [popa popu];
                        end
                    end
                    a = constraintSST(newpop_0(i,:), minlayer, difthick)+constraintSST(newpop_0(i+1,:), minlayer, difthick);
                    b = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                    c = constraintSST(newpop_2(i,:), tranlayer1, difthick)+constraintSST(newpop_2(i+1,:), tranlayer2, difthick);
                    constb = a + b + c;
                    constraintCount = constraintCount + 1;
                if constraintCount > 500
                    disp('constraintSST函数调用次数超过500，终止最外层循环');
                    exitFlag = 1;
                end
                if exitFlag == 1
                    break;  % 如果退出标志为1，则跳出最外层循环
                end
                end

            else%对MPST12进行优化
                constraintCount = 0;
                exitFlag = 0;
                constb = 0;

                while constb < 6
                    thick_0 = newpop_thick(i, array0);
                    MPST0_1 = sequence(newpop_0(i, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer1 = [];
                    for l = 1:length(MPST0_1)
                        if length(MPST0_1{l}) == tranlayerthick
                            tranlayer1 = MPST0_1{l};
                            tranlayer1 = tranlayer1(1:floor(end/2));
                        end
                    end
                    thick_0 = newpop_thick(i+1, array0);
                    MPST0_2 = sequence(newpop_0(i+1, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer2 = [];
                    for l = 1:length(MPST0_2)
                        if length(MPST0_2{l}) == tranlayerthick
                            tranlayer2 = MPST0_2{l};
                            tranlayer2 = tranlayer2(1:floor(end/2));
                        end
                    end
                    if rand < 0.5%mpst1
                        b = 0;
                        while b<2
                            crossover_point = randi([1, difthick-1]);
                            if crossover_point <= 0
                                crossover_point = 1;
                            end
                            newpop_1(i,1:crossover_point) = pop_1(i,1:crossover_point);
                            newpop_1(i,crossover_point+1:difthick) = pop_1(i+1,crossover_point+1:difthick);
                            newpop_1(i,difthick+1:difthick+crossover_point) = pop_1(i,difthick+1:difthick+crossover_point);
                            newpop_1(i,difthick+crossover_point+1:end) = pop_1(i+1,difthick+crossover_point+1:end);
                            newpop_1(i+1,1:crossover_point) = pop_1(i+1,1:crossover_point);
                            newpop_1(i+1,crossover_point+1:difthick) = pop_1(i,crossover_point+1:difthick);
                            newpop_1(i+1,difthick+1:difthick+crossover_point) = pop_1(i+1,difthick+1:difthick+crossover_point);
                            newpop_1(i+1,difthick+crossover_point+1:end) = pop_1(i,difthick+crossover_point+1:end);
                            b = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                            constraintCount = constraintCount + 1;
                            if constraintCount > 500
                                disp('constraintSST函数调用次数超过500，终止最外层循环');
                                exitFlag = 1;
                                break;
                            end
                            if b <2
                                while crossover_point <difthick
                                    newpop_1(i,1:crossover_point) = pop_1(i,1:crossover_point);
                                    newpop_1(i,crossover_point+1:difthick) = pop_1(i+1,crossover_point+1:difthick);
                                    newpop_1(i,difthick+1:difthick+crossover_point) = pop_1(i,difthick+1:difthick+crossover_point);
                                    newpop_1(i,difthick+crossover_point+1:end) = pop_1(i+1,difthick+crossover_point+1:end);
                                    newpop_1(i+1,1:crossover_point) = pop_1(i+1,1:crossover_point);
                                    newpop_1(i+1,crossover_point+1:difthick) = pop_1(i,crossover_point+1:difthick);
                                    newpop_1(i+1,difthick+1:difthick+crossover_point) = pop_1(i+1,difthick+1:difthick+crossover_point);
                                    newpop_1(i+1,difthick+crossover_point+1:end) = pop_1(i,difthick+crossover_point+1:end);
                                    b = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                                    if b == 2
                                        break
                                    end
                                    crossover_point = crossover_point+1;
                                    constraintCount = constraintCount + 1;
                                    if constraintCount > 500
                                        disp('constraintSST函数调用次数超过500，终止最外层循环');
                                        exitFlag = 1;
                                        break;
                                    end
                                end
                            end
                            if exitFlag == 1
                                break;  % 如果退出标志为1，则跳出最外层循环
                            end
                        end
                    else%mpst2
                        c = 0;
                        while c<2
                            crossover_point = randi([1, difthick-1]);
                            if crossover_point <= 0
                                crossover_point = 1;
                            end
                            newpop_2(i,1:crossover_point) = pop_2(i,1:crossover_point);
                            newpop_2(i,crossover_point+1:difthick) = pop_2(i+1,crossover_point+1:difthick);
                            newpop_2(i,difthick+1:difthick+crossover_point) = pop_2(i,difthick+1:difthick+crossover_point);
                            newpop_2(i,difthick+crossover_point+1:end) = pop_2(i+1,difthick+crossover_point+1:end);
                            newpop_2(i+1,1:crossover_point) = pop_2(i+1,1:crossover_point);
                            newpop_2(i+1,crossover_point+1:difthick) = pop_2(i,crossover_point+1:difthick);
                            newpop_2(i+1,difthick+1:difthick+crossover_point) = pop_2(i+1,difthick+1:difthick+crossover_point);
                            newpop_2(i+1,difthick+crossover_point+1:end) = pop_2(i,difthick+crossover_point+1:end);
                            c = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                            constraintCount = constraintCount + 1;
                            if constraintCount > 500
                                disp('constraintSST函数调用次数超过500，终止最外层循环');
                                exitFlag = 1;
                                break;
                            end
                            if c <2
                                while crossover_point <difthick
                                    newpop_2(i,1:crossover_point) = pop_2(i,1:crossover_point);
                                    newpop_2(i,crossover_point+1:difthick) = pop_2(i+1,crossover_point+1:difthick);
                                    newpop_2(i,difthick+1:difthick+crossover_point) = pop_2(i,difthick+1:difthick+crossover_point);
                                    newpop_2(i,difthick+crossover_point+1:end) = pop_2(i+1,difthick+crossover_point+1:end);
                                    newpop_2(i+1,1:crossover_point) = pop_2(i+1,1:crossover_point);
                                    newpop_2(i+1,crossover_point+1:difthick) = pop_2(i,crossover_point+1:difthick);
                                    newpop_2(i+1,difthick+1:difthick+crossover_point) = pop_2(i+1,difthick+1:difthick+crossover_point);
                                    newpop_2(i+1,difthick+crossover_point+1:end) = pop_2(i,difthick+crossover_point+1:end);
                                    c = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                                    if c == 2
                                        break
                                    end
                                    crossover_point = crossover_point+1;
                                    constraintCount = constraintCount + 1;
                                    if constraintCount > 500
                                        disp('constraintSST函数调用次数超过500，终止最外层循环');
                                        exitFlag = 1;
                                        break;
                                    end
                                end
                            end
                            if exitFlag == 1
                                break;  % 如果退出标志为1，则跳出最外层循环
                            end
                        end
                    end
                    crossover_point_thick = randi([1, pyt-1]);
                    newpop_thick(i,1:crossover_point_thick+1) = pop_thick(i, 1:crossover_point_thick+1);
                    newpop_thick(i,crossover_point_thick+1:end) = pop_thick(i+1, crossover_point_thick+1:end);
                    newpop_thick(i+1,1:crossover_point_thick+1) = pop_thick(i+1, 1:crossover_point_thick+1);
                    newpop_thick(i+1,crossover_point_thick+1:end) = pop_thick(i, crossover_point_thick+1:end);
                    newpop_thick(i:i+1,:) = rethick(newpop_thick(i:i+1,:),2);
                    thick_0 = newpop_thick(i, array0);
                    MPST0_1 = sequence(newpop_0(i, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer1 = [];
                    for l = 1:length(MPST0_1)
                        if length(MPST0_1{l}) == tranlayerthick
                            tranlayer1 = MPST0_1{l};
                            tranlayer1 = tranlayer1(1:floor(end/2));
                        end
                    end
                    thick_0 = newpop_thick(i+1, array0);
                    MPST0_2 = sequence(newpop_0(i+1, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer2 = [];
                    for l = 1:length(MPST0_2)
                        if length(MPST0_2{l}) == tranlayerthick
                            tranlayer2 = MPST0_2{l};
                            tranlayer2 = tranlayer2(1:floor(end/2));
                        end
                    end
                    a = constraintSST(newpop_0(i,:), minlayer, difthick)+constraintSST(newpop_0(i+1,:), minlayer, difthick);
                    b = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                    c = constraintSST(newpop_2(i,:), tranlayer1, difthick)+constraintSST(newpop_2(i+1,:), tranlayer2, difthick);
                    constb = a + b + c;
                    constraintCount = constraintCount + 1;
                    if constraintCount > 500
                        disp('constraintSST函数调用次数超过500，终止最外层循环');
                        exitFlag = 1;
                    end
                    if exitFlag == 1
                        break;  % 如果退出标志为1，则跳出最外层循环
                    end
                end

            end
            if exitFlag == 1
                'thick'
                newpop_0(i:i+1,:) =  pop_0(i:i+1,:);
                newpop_1(i:i+1,:) =  pop_1(i:i+1,:);
                newpop_2(i:i+1,:) =  pop_2(i:i+1,:);
                newpop_thick(i:i+1,:) =  pop_thick(i:i+1,:);
                constb = 0;
                constraintCount1 = 0;
                exitFlag1 = 0;
                while constb < 6
                    crossover_point_thick = randi([1, pyt-1]);
                    newpop_thick(i,1:crossover_point_thick+1) = pop_thick(i, 1:crossover_point_thick+1);
                    newpop_thick(i,crossover_point_thick+1:end) = pop_thick(i+1, crossover_point_thick+1:end);
                    newpop_thick(i+1,1:crossover_point_thick+1) = pop_thick(i+1, 1:crossover_point_thick+1);
                    newpop_thick(i+1,crossover_point_thick+1:end) = pop_thick(i, crossover_point_thick+1:end);
                    newpop_thick(i:i+1,:) = rethick(newpop_thick(i:i+1,:),2);
                    thick_0 = newpop_thick(i, array0);
                    MPST0_1 = sequence(newpop_0(i, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer1 = [];
                    for l = 1:length(MPST0_1)
                        if length(MPST0_1{l}) == tranlayerthick
                            tranlayer1 = MPST0_1{l};
                            tranlayer1 = tranlayer1(1:floor(end/2));
                        end
                    end
                    thick_0 = newpop_thick(i+1, array0);
                    MPST0_2 = sequence(newpop_0(i+1, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer2 = [];
                    for l = 1:length(MPST0_2)
                        if length(MPST0_2{l}) == tranlayerthick
                            tranlayer2 = MPST0_2{l};
                            tranlayer2 = tranlayer2(1:floor(end/2));
                        end
                    end
                    a = constraintSST(newpop_0(i,:), minlayer, difthick)+constraintSST(newpop_0(i+1,:), minlayer, difthick);
                    b = constraintSST(newpop_1(i,:), tranlayer1, difthick)+constraintSST(newpop_1(i+1,:), tranlayer2, difthick);
                    c = constraintSST(newpop_2(i,:), tranlayer1, difthick)+constraintSST(newpop_2(i+1,:), tranlayer2, difthick);
                    constb = a + b + c;
                    constraintCount1 = constraintCount1 + 1;
                    if constraintCount1 > 500
                        exitFlag1 = 1;
                        break;
                    end
                end
                if exitFlag1 == 1
                    newpop_0(i:i+1,:) =  pop_0(i:i+1,:);
                    newpop_1(i:i+1,:) =  pop_1(i:i+1,:);
                    newpop_2(i:i+1,:) =  pop_2(i:i+1,:);
                    newpop_thick(i:i+1,:) =  pop_thick(i:i+1,:);
                end
            end
        end
    end
end
end
