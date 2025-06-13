%% Mutation Operation
% Input variables: pop - population
%                  pm - mutation probability
% Output variable: newpop - population after mutation

function [newpop_0, newpop_1, newpop_2,newpop_thick] = mutation(pop_0, pop_1, pop_2,pop_thick,pm,difthick,midsingle,minthick,minlayer)
[px,py] = size(pop_0);
[qx,qy] = size(pop_thick);
newpop_0 =  pop_0;
newpop_1 =  pop_1;
newpop_2 =  pop_2;
newpop_thick =  pop_thick;
array0 = [2,4,8,9,10,12,14,18,19,20,22,24,28,29,30,32,34,38,39,40];
for i = 1:px
    if rand < pm
        consta = 0;
        if rand < 0.5%对MPST0进行优化
            consta = 0;
                constraintCount = 0;
                exitFlag = 0;
            while consta<3
                mpoint = round(rand*py);
                if mpoint <= 0
                    mpoint = 1;
                end
                newpop_0(i,:) = pop_0(i,:);
                if mpoint <= difthick
                    newpop_0(i,mpoint) = fix(12*rand);
                else
                    newpop_0(i,mpoint) = fix((fix((minthick-midsingle)/2)+mpoint-difthick-2)*rand)+1;
                end
                npoint = round(rand*qy);
                if npoint <= 0
                    npoint = 1;
                end
                newpop_thick(i,:) = pop_thick(i,:);
                newpop_thick(i,npoint) = min(max((newpop_thick(i,npoint)+ randi([-5, 5])),minthick),110);
                newpop_thick(i,:) = rethick(newpop_thick(i,:),1);
                thick_0 = newpop_thick(i, array0);
                MPST0 = sequence(newpop_0(i, :), minlayer, difthick);
                [tranlayerthick,max_index] = max(thick_0);
                max_index = array0(max_index);
                if mod(tranlayerthick, 2) == 1
                    tranlayerthick = tranlayerthick + 1;
                end
                % 查找合适的 tranlayer
                tranlayer = [];
                for l = 1:length(MPST0)
                    if length(MPST0{l}) == tranlayerthick
                        tranlayer = MPST0{l};
                        tranlayer = tranlayer(1:floor(end/2));
                    end
                end
                %生成全新的MPST1、2
                for k = 1:2
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
                                        MPST0 = sequence(newpop_0(i,:),minlayer,difthick);
                                        tranlayerthick = max(thick_0);
                                        if mod(tranlayerthick,2) == 1
                                            tranlayerthick = tranlayerthick+1;
                                        end
                                        for l = 1:length(MPST0)
                                            if length(MPST0{l}) == tranlayerthick
                                                tranlayer = MPST0{l};
                                                tranlayer = tranlayer(1:floor(end/2));
                                            end
                                        end
                                        angel = numbers(randi(numel(numbers)));
                                        popa(1,2*j-1)=angel;
                                        popu(1,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                        popa(1,2*j)=angel+1;
                                        popu(1,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                        newlayer = layerupdate(tranlayer,1,2*j,popa,popu);
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
                                        MPST0 = sequence(newpop_0(i,:),minlayer,difthick);
                                        tranlayerthick = max(thick_0);
                                        if mod(tranlayerthick,2) == 1
                                            tranlayerthick = tranlayerthick+1;
                                        end
                                        for l = 1:length(MPST0)
                                            if length(MPST0{l}) == tranlayerthick
                                                tranlayer = MPST0{l};
                                                tranlayer = tranlayer(1:floor(end/2));
                                            end
                                        end
                                        angel = numbers(randi(numel(numbers)));
                                        popa(1,2*j-1)=angel;
                                        popu(1,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                        popa(1,2*j)=angel+1;
                                        popu(1,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                        newlayer = layerupdate(tranlayer,1,2*j,popa,popu);
                                        angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                                    end

                                end
                                individual = [popa(1,1:2*j) popu(1,1:2*j)];
                                constj = constraintSST(individual,tranlayer,2*j);
                                                        constraintCount = constraintCount + 1;
                        if constraintCount > 500
                            disp('constraintSST函数调用次数超过500，终止最外层循环');
                            exitFlag = 1;
                            break;
                        end
                            end
                        end
                        individual = [popa(1,:) popu(1,:)];
                        const = constraintSST(individual,tranlayer,difthick);
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
                a = constraintSST(newpop_0(i,:), minlayer, difthick);
                b = constraintSST(newpop_1(i,:), tranlayer, difthick);
                c = constraintSST(newpop_2(i,:), tranlayer, difthick);
                consta = a + b + c;
                constraintCount = constraintCount + 1;
                if constraintCount > 500
                    disp('constraintSST函数调用次数超过500，终止最外层循环');
                    exitFlag = 1;
                end
                if exitFlag == 1
                    break;  % 如果退出标志为1，则跳出最外层循环
                end
            end


        else
            constraintCount = 0;
            exitFlag = 0;

            while consta < 3
                %对MPST1、2进行变异
                % newpop_0(i,:) =  pop_0(i,:);
                % newpop_1(i,:) =  pop_1(i,:);
                % newpop_2(i,:) =  pop_2(i,:);
                % newpop_thick(i,:) =  pop_thick(i,:);
                thick_0 = pop_thick(i, array0);
                MPST0 = sequence(pop_0(i, :), minlayer, difthick);
                [tranlayerthick,max_index] = max(thick_0);
                max_index = array0(max_index);
                if mod(tranlayerthick, 2) == 1
                    tranlayerthick = tranlayerthick + 1;
                end
                % 查找合适的 tranlayer
                tranlayer = [];
                for l = 1:length(MPST0)
                    if length(MPST0{l}) == tranlayerthick
                        tranlayer = MPST0{l};
                        tranlayer = tranlayer(1:floor(end/2));
                    end
                end

                if rand < 0.5
                    b = 0;
                    while b==0
                        mpoint_1 = round(rand*py);
                        if mpoint_1 <= 0
                            mpoint_1 = 1;
                        end
                        newpop_1(i,:) = pop_1(i,:);
                        if mpoint_1 <= difthick
                            newpop_1(i,mpoint_1) = fix(12*rand);
                        else
                            newpop_1(i,mpoint_1) = fix((fix((tranlayerthick*2-midsingle)/2)+mpoint_1-difthick-2)*rand)+1;
                        end
                        b = constraintSST(newpop_1(i,:), tranlayer, difthick);
                        constraintCount = constraintCount + 1;

                        if constraintCount > 500
                            disp('constraintSST函数调用次数超过500，终止最外层循环');
                            exitFlag = 1;
                            break;
                        end
                        if b == 0
                            while mpoint_1 <py
                                newpop_1(i,mpoint_1+1) = newpop_1(i,mpoint_1);
                                newpop_1(i,mpoint_1) = pop_1(i,mpoint_1);
                                b = constraintSST(newpop_1(i,:), tranlayer, difthick);

                                if b == 1
                                    break
                                end
                                mpoint_1 = mpoint_1+1;
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
                else

                    c = 0;
                    while c==0
                        mpoint_2 = round(rand*py);
                        if mpoint_2 <= 0
                            mpoint_2 = 1;
                        end
                        newpop_2(i,:) = pop_2(i,:);
                        if mpoint_2 <= difthick
                            newpop_2(i,mpoint_2) = fix(12*rand);
                        else
                            newpop_2(i,mpoint_2) = fix((fix((tranlayerthick*2-midsingle)/2)+mpoint_2-difthick-2)*rand)+1;
                        end
                        c = constraintSST(newpop_2(i,:), tranlayer, difthick);
                        constraintCount = constraintCount + 1;

                        if constraintCount > 500
                            disp('constraintSST函数调用次数超过500，终止最外层循环');
                            exitFlag = 1;
                            break;
                        end
                        if c == 0
                            while mpoint_2 <py
                                newpop_2(i,mpoint_2+1) = newpop_2(i,mpoint_2);
                                newpop_2(i,mpoint_2) = pop_2(i,mpoint_2);
                                c = constraintSST(newpop_2(i,:), tranlayer, difthick);
                                if c == 1
                                    break
                                end
                                mpoint_2 = mpoint_2+1;
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
                npoint = round(rand*qy);
                %                 while max_index == npoint
                %                     npoint = round(rand*qy) ;
                %                 end
                if npoint <= 0
                    npoint = 1;
                end
                newpop_thick(i,:) = pop_thick(i,:);
                newpop_thick(i,npoint) = min(max((pop_thick(i,npoint)+ randi([-5, 5])),minthick),110);
                newpop_thick(i,:) = rethick(newpop_thick(i,:),1);
                a = constraintSST(newpop_0(i,:), minlayer, difthick);
                b = constraintSST(newpop_1(i,:), tranlayer, difthick);
                c = constraintSST(newpop_2(i,:), tranlayer, difthick);
                consta = a + b + c;
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
            newpop_0(i,:) =  pop_0(i,:);
            newpop_1(i,:) =  pop_1(i,:);
            newpop_2(i,:) =  pop_2(i,:);
            newpop_thick(i,:) =  pop_thick(i,:);
                consta = 0;
                constraintCount1 = 0;
                exitFlag1 = 0;
                while consta < 3
                NP = round(rand*5)+2;
                npoint = zeros(NP);
                newpop_thick(i,:) = pop_thick(i,:);
                for np = 1:NP
                npoint(np) = round(rand*qy);
                if npoint(np) <= 0
                    npoint(np) = 1;
                end
                newpop_thick(i,npoint(np)) = min(max((newpop_thick(i,npoint(np))+ randi([-5, 5])),minthick),110);
                newpop_thick(i,:) = rethick(newpop_thick(i,:),1);
                end
                    thick_0 = newpop_thick(i, array0);
                    MPST0_1 = sequence(newpop_0(i, :), minlayer, difthick);
                    [tranlayerthick,max_index] = max(thick_0);
                    if mod(tranlayerthick, 2) == 1
                        tranlayerthick = tranlayerthick + 1;
                    end
                    % 查找合适的 tranlayer
                    tranlayer = [];
                    for l = 1:length(MPST0_1)
                        if length(MPST0_1{l}) == tranlayerthick
                            tranlayer = MPST0_1{l};
                            tranlayer = tranlayer(1:floor(end/2));
                        end
                    end
                    a = constraintSST(newpop_0(i,:), minlayer, difthick);
                    b = constraintSST(newpop_1(i,:), tranlayer, difthick);
                    c = constraintSST(newpop_2(i,:), tranlayer, difthick);
                    consta = a + b + c;
                    constraintCount1 = constraintCount1 + 1;
                    if constraintCount1 > 500
                        exitFlag1 = 1;
                        break;
                    end
                end
                if exitFlag1 == 1
                    newpop_0(i,:) =  pop_0(i,:);
                    newpop_1(i,:) =  pop_1(i,:);
                    newpop_2(i,:) =  pop_2(i,:);
                    newpop_thick(i,:) =  pop_thick(i,:);
                end


        end
    end
end