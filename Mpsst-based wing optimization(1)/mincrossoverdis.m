function [newpop] = mincrossoverdis(pop,pc,minlayer,difthick,mode)
%CROSSOVERDIS 
[px,py] = size(pop);
newpop = pop;
for i =1:2:px-1
    if (rand<pc)     
        const = 0;
        while const ==0
            for py_n=1:py
                if rand<0.5
                newpop(i,py_n)=pop(i+1,py_n); 
                end
            end
            
            if (mode ==1)
            const = constraintSST(newpop(i,:),minlayer,difthick); 
            else
            const = constraint(newpop(i,:),minlayer,difthick);
            end
        end
    end
end
end
