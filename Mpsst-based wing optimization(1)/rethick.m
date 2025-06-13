function [pop_thick] = rethick(pop_thick,popsize)
%RETHICK 保证所有多峰区域的厚度均大于tranlayer（过渡铺层序列）
array0 = [2,4,8,9,10,12,14,18,19,20,22,24,28,29,30,32,34,38,39,40];
for i = 1:popsize
thick_0 = pop_thick(i,array0);
tranlayerthick = max(thick_0);
if mod(tranlayerthick,2) == 1
    tranlayerthick = tranlayerthick+1;
end
for p = 1:40
    if ~ismember(p, array0)
        if pop_thick(i,p) < tranlayerthick
            pop_thick(i,p) = tranlayerthick;
        end
    end
end
end

