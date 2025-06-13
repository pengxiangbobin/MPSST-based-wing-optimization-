function [pop_0,pop_1,pop_2] = initpop_insertion(pop_thick,popsize,difthick,minthick,minlayer)
minthick = minthick/2;
for k = 1:3
    popa = zeros(popsize,difthick);
    popu = zeros(popsize,difthick);
    array0 = [2,4,8,9,10,12,14,18,19,20,22,24,28,29,30,32,34,38,39,40];
    for i = 1:popsize
        thick_0 = pop_thick(i,array0);
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
                    angdif = 1;
                    randompostive = randi(2);
                    if randompostive == 1
                        numbers = [1, 3, 5, 7, 9];  %Randomly select a positive angle
                        while angdif == 1
                            innercounter = innercounter+1;
                            if innercounter == 100
                                flag1 =1 ;
                                break
                            end
                            if k == 1
                                angel = numbers(randi(numel(numbers)));
                                popa(i,2*j-1)=angel;
                                popu(i,2*j-1)=fix((minthick+2*j-3)*rand)+1;
                                popa(i,2*j)=angel+1;
                                popu(i,2*j)=fix((minthick+2*j-2)*rand)+1;
                                newlayer = layerupdate(minlayer,i,2*j,popa,popu);
                                angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                            else
                                MPST0 = sequence(pop_0(i,:),minlayer,difthick);
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
                                popa(i,2*j-1)=angel;
                                popu(i,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                popa(i,2*j)=angel+1;
                                popu(i,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                newlayer = layerupdate(tranlayer,i,2*j,popa,popu);
                                angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                            end
                        end
                    else
                        numbers = [2, 4, 6, 8, 10];  %Randomly select a negative angle
                        while angdif == 1
                            innercounter = innercounter+1;
                            if innercounter == 100
                                flag1 =1 ;
                                break
                            end
                            if k ==1
                                angel = numbers(randi(numel(numbers)));
                                popa(i,2*j-1)=angel;
                                popu(i,2*j-1)=fix((minthick+2*j-3)*rand)+1;
                                popa(i,2*j)=angel+1;
                                popu(i,2*j)=fix((minthick+2*j-2)*rand)+1;
                                newlayer = layerupdate(minlayer,i,2*j,popa,popu);
                                angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                            else
                                MPST0 = sequence(pop_0(i,:),minlayer,difthick);
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
                                popa(i,2*j-1)=angel;
                                popu(i,2*j-1)=fix((tranlayerthick/2+2*j-3)*rand)+1;
                                popa(i,2*j)=angel+1;
                                popu(i,2*j)=fix((tranlayerthick/2+2*j-2)*rand)+1;
                                newlayer = layerupdate(tranlayer,i,2*j,popa,popu);
                                angdif=ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(newlayer)));
                            end
                        end
                    end
                    individual = [popa(i,1:2*j) popu(i,1:2*j)];
                    if k == 1
                        constj = constraintSST(individual,minlayer,2*j);
                    else
                        constj = constraintSST(individual,tranlayer,2*j);
                    end
                end
            end
            individual = [popa(i,:) popu(i,:)]
            if k == 1
                const = constraintSST(individual,minlayer,difthick)
            else
                const = constraintSST(individual,tranlayer,difthick)
            end
        end
    end 
    if k ==1
        pop_0 = [popa popu];    
    elseif k ==2
        pop_1 = [popa popu];  
    else
        pop_2 = [popa popu];
    end
end
end