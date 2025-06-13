function const = constraint(individual,minlayer,difthick)
%CONSTRAINT Calculate if individuals meet the constraints
%   0 indicates that the constraint is not met
const = 1;

    Dir = decode(individual);
    [L,val]=longrun(Dir);
    targetElements1=[-45 ,0 ,45 ,90];
    % Initialize the result variable
frequencies1 = zeros(size(targetElements1));


% Iterate over each target element and calculate the number of occurrences and frequency
for k = 1:numel(targetElements1)
    targetElement = targetElements1(k);
    counts = 0;
    for j = 1:numel(Dir)
        if Dir(j) == targetElement
            counts = counts + 1;
        end
    end
    frequencies1(k) = counts/size(Dir,2);
end   
   targetElements2=[15 -15 30 -30 45 -45 60 -60 75 -75];
    % Initialize the result variable
frequencies2 = zeros(size(targetElements2));

    for k = 1:numel(targetElements2)
    targetElement = targetElements2(k);
    counts = 0;
    for j = 1:numel(Dir)
        if Dir(j) == targetElement
            counts = counts + 1;
        end
    end
    frequencies2(k) = counts;
end  

cond1 = abs(frequencies2(1,1)-frequencies2(1,2));
cond2 = abs(frequencies2(1,3)-frequencies2(1,4));
cond3 = abs(frequencies2(1,5)-frequencies2(1,6));
cond4 = abs(frequencies2(1,7)-frequencies2(1,8));
cond5 = abs(frequencies2(1,9)-frequencies2(1,10));
satisfiedCount = cond1 + cond2 + cond3 + cond4 + cond5;
   


    if max (L) > 4||ismember(1,ismember([120 105 90 75 60 -60 -75 -90 -105 -120],diff(Dir)))==1%|| any(frequencies1 < 0.1)||satisfiedCount>1
    const = 0;



    end
    end

