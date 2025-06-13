clc;
clear;
tic;
number_iterations = 2000;
popsize = 20;
     pc = 0.6;%Crossover probability
     pm = 0.8;%Mutation probabil 
% 定义文件路径
global bdfFilePath modifiedBdfFilePath f06FilePath batFilePath allpartNames displacementsconstraint stressconstraint nastranPath;
bdfFilePath = 'C:\Users\cszzl\Desktop\allinone\original.bdf';
modifiedBdfFilePath = 'C:\Users\cszzl\Desktop\allinone\latest.bdf';
f06FilePath = 'C:\Users\cszzl\Desktop\allinone\latest.f06';
batFilePath = 'C:\Users\cszzl\Desktop\allinone\run_nastran_mode.bat';
nastranPath = 'C:\Program Files\MSC.Software\MSC_Nastran\2020\bin\nastranw.exe';
displacementsconstraint0 = 3.15;%4.386
stressconstraint0 = 300;%500MPa
displacementsconstraint = 39.37*displacementsconstraint0;
stressconstraint = 145.04*stressconstraint0;

% 定义文件名
original_file = 'original.bdf';
new_file = 'Copy_of_original.bdf';

% 检查 latest.bdf 文件是否存在
if exist(new_file, 'file')
    % 读取 latest.bdf 的内容
    fid = fopen(new_file, 'r');  % 打开文件以读取
    latest_content = fread(fid, '*char')';  % 读取文件内容
    fclose(fid);  % 关闭文件

    % 将内容写入 original.bdf
    fid = fopen(original_file, 'w');  % 打开文件以写入
    fwrite(fid, latest_content);  % 写入内容
    fclose(fid);  % 关闭文件
disp('original.bdf has been updated to match latest.bdf.');
else
    disp('Error: new.bdf does not exist.');
end

allpartNames = {'botback0', 'botback9','botback1', 'botback2','botback3', 'botback4', 'botback5','botback6','botback7','botback8',...
            'botfront0','botfront9','botfront1','botfront2','botfront3','botfront4','botfront5','botfront6','botfront7','botfront8',...
            'topback0','topback9','topback1','topback2','topback3','topback4','topback5','topback6','topback7','topback8',...
            'topfront0','topfront9','topfront1','topfront2','topfront3','topfront4','topfront5','topfront6','topfront7','topfront8'};
 
%[50	20	45	40	40	35	30	30	20	20
 %50	20	45	40	40	35	30	30	20	20
 %50	20	45	40	40	35	30	30	20	20
 %50	20	45	40	40	35	30	30	20	20]
notminpartNames = {'botback0', 'botback9','botback1', 'botback2','botback3', 'botback4', 'botback5','botback6','botback7','botback8',...
            'botfront0','botfront9','botfront1','botfront2','botfront3','botfront4','botfront5','botfront6','botfront7','botfront8',...
            'topback0','topback1','topback2','topback3','topback4','topback5','topback6','topback7','topback8',...
            'topfront0','topfront9','topfront1','topfront2','topfront3','topfront4','topfront5','topfront6','topfront7','topfront8'};
%80 80 70 100 100 80 70 50 40 20 
%80 20 80 70 100 100 80 70 50 40 
%[26	14	44	40	27	25	30	23	32	24
% 43	23	32	27	26	22	44	21	24	10
% 34	27	39	32	26	28	30	28	10
% 31	27	50	30	35	24	26	31	10	15]


minpart =   {'topback9'};%10
%MPSTpart0 = {'botback4','botfront4','topback4','topfront4'};

% MPSTpart1 = {'botback0', 'botback1', 'botback2','botback3',...
%             'botfront0','botfront1','botfront2','botfront3',...
%             'topback0','topback1','topback2','topback3',...
%             'topfront0','topfront1','topfront2','topfront3'};

% MPSTpart2 = {'botback9','botback5','botback6','botback7','botback8',...
%             'botfront9','botfront5','botfront6','botfront7','botfront8',...
%             'topback5','topback6','topback7','topback8',...
%             'topfront9','topfront5','topfront6','topfront7','topfront8'};

MPSTpart0 = {'botback9','botback2','botback6','2botback7','botback8',...
             'botfront9','botfront2','botfront6','botfront7','botfront8',...
             'topback9','topback2','topback6','topback7','topback8',...
             'topfront9','topfront2','topfront6','topfront7','topfront8'};
MPST0th=[15 30  25 20 15 15 30 25 20 15 15 30 25 20 15 15 30 25 20 15];

MPSTpart1 = {'botback0','botback1',...
            'botfront0','botfront1',...
            'topback0','topback1',...
            'topfront0','topfront1'};
MPST1th= [30 35 30 35 30 35 30 35 ];

MPSTpart2 = {'botback3','botback4','botback5',...
            'botfront3','botfront4','botfront5',...
            'topback3','topback4','topback5',...
            'topfront3','topfront4','topfront5',};
MPST2th = [45 40 35 45 40 35 45 40 35 45 40 35 ];


%%一次性厚度优化
    mode = 1;
    partNames = allpartNames; 
    minlayer = [0 45 90 -45 0];%bestindividual;%stacking sequence of the thinnest subregion,均以一半铺层序列表达
    minthick = size(minlayer,2)*2;
    thickpredict = [80 20 80 70 100 100 80 70 50 40 80 20 80 70 100 100 80 70 50 40 80 20 80 70 100 100 80 70 50 40 80 20 80 70 100 100 80 70 50 40 ];
    pop_thick = zeros(popsize, length(thickpredict));
    range = 10; % 设置生成个体的范围
    for i = 1:popsize
    % 在原个体的基础上随机生成数值
    new_individual = thickpredict + randi([-range, range], 1, length(thickpredict));  
    % 限制生成的值在 10 到 60 之间
    pop_thick(i, :) = min(max(new_individual, minthick), 110);
    end
    pop_thick = rethick(pop_thick,popsize);
    %Prediction of thickness, represented by half of the thickness
    %the optimization objective includes subregions 1, 2, 3, 4, 6, 9, 10, 11, 12, 13, and 16 of the 18 panels
    nsubergion = size(thickpredict,2);
    midsingle = 0;%0 represents a double layer in the middle, while 1 represents a single layer
    difthick = 35;%The difference in thickness between the thickest and thinnest layers
    if mod(difthick,2) == 1
        difthick =difthick+1;
    end
    [pop_0,pop_1,pop_2] = initpop_insertion(pop_thick,popsize,difthick,minthick,minlayer);
for xunhuan = 1:number_iterations 
    [objvalue,MAXIMUMDISPLACEMENTS,MAXIMUMVONMISES,mass,failureCriteria,maxTau12] = cal_objvalue_ins(pop_0,pop_1,pop_2,pop_thick,minlayer,difthick,partNames,popsize); 
    [~,a]=max(objvalue);            %Save the max fitness value
    pop_0_max=pop_0(a,:);
    pop_1_max=pop_1(a,:);
    pop_2_max=pop_2(a,:);
    pop_thick_max=pop_thick(a,:);
    fitvalue = objvalue;
    [newpop_0,newpop_1,newpop_2,newpop_thick] = selection(pop_0,pop_1,pop_2,pop_thick,fitvalue);    
    [newpop_0,newpop_1,newpop_2,newpop_thick] = crossoverdis(newpop_0,newpop_1,newpop_2,newpop_thick,pc,minlayer,difthick);
    [newpop_0,newpop_1,newpop_2,newpop_thick] = mutation(newpop_0,newpop_1,newpop_2,newpop_thick,pm,difthick,midsingle,minthick,minlayer);
    pop_0 = newpop_0;
    pop_1 = newpop_1;
    pop_2 = newpop_2;
    pop_thick = newpop_thick;%Update the population
    pop_0(a,:)=pop_0_max;
    pop_1(a,:)=pop_1_max;
    pop_2(a,:)=pop_2_max;
    pop_thick(a,:)=pop_thick_max; 
    fitvalue = objvalue;
    [bestpop_0,bestpop_1,bestpop_2,bestthick,bestfit,bestMAXIMUMDISPLACEMENTS,bestMAXIMUMVONMISES,bestmass,bestmaxTau12] = best(pop_0,pop_1,pop_2,pop_thick,fitvalue,MAXIMUMDISPLACEMENTS,MAXIMUMVONMISES,mass,maxTau12);   %Find the optimal solution
    fitvalue
    totalthick = sum(bestthick)
    bestMAXIMUMDISPLACEMENTS
    bestMAXIMUMVONMISES
    bestmaxTau12
    bestmass
    bestfit
    xunhuan
    recordbestfit(xunhuan)=bestfit;                %Plot the best value at each iteration
    recordmeanfit(xunhuan)=mean(fitvalue);       %Plot the average value at each iteration    
    recordDISPLACEMENTS(xunhuan)=bestMAXIMUMDISPLACEMENTS;
    recordstress(xunhuan)=bestMAXIMUMVONMISES;
    recordmass(xunhuan)=bestmass; 
    
end
%输出结果
[objvalue,MAXIMUMDISPLACEMENTS,MAXIMUMVONMISES,mass,failureCriteria,maxTau12] = cal_objvalue_ins(bestpop_0,bestpop_1,bestpop_2,bestthick,minlayer,difthick,partNames,1); 
    %MPST = sequence(bestindividual,minlayer,difthick) 
 elapsedTime = toc;
    fprintf('代码执行时间: %.2f 秒\n', elapsedTime);
gongzhimass = 0.453592*mass
    elapsedTime = toc;
    
       figure;
       plot(recordmass)
      figure;
      plot(recordbestfit)
      hold all
      plot(recordmeanfit)




     MPST0 = sequence(bestpop_0,minlayer,difthick)
     array0 = [2,4,8,9,10,12,14,18,19,20,22,24,28,29,30,32,34,38,39,40];
     thick_0 = bestthick(1,array0);
                 tranlayerthick = max(thick_0);
            if mod(tranlayerthick,2) == 1
                tranlayerthick = tranlayerthick+1;
            end
            for i = 1:length(MPST0)
                if length(MPST0{i}) == tranlayerthick
                    tranlayer = MPST0{i}; % 将符合条件的 cell 添加到结果中
                    tranlayer = tranlayer(1:floor(end/2));
                end
            end
     MPST1 = sequence(bestpop_1,tranlayer,difthick)
     MPST2 = sequence(bestpop_2,tranlayer,difthick)

