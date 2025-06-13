function pop = initpop(popsize,chromlength)
for i = 1:popsize
 const = 0;
        while const==0
        initposition=randperm(chromlength, 4);%Randomly place four basic layers.
%         pop(i,initposition(1))=0;
%         pop(i,initposition(2))=5;
%         pop(i,initposition(3))=6;
%         pop(i,initposition(4))=11;
        for j=1:(chromlength-4)/2
            numbers = [1, 3, 5, 7, 9];  %Randomly select a positive angle.
            angel = numbers(randi(numel(numbers))); 
            availableNumbers = 1:chromlength;  
            % Remove selected numbers from the range.
            availableNumbers(ismember(availableNumbers, initposition)) = [];
            % Randomly select two numbers that are not in `initposition`.
            position = randsample(availableNumbers, 2);
            pop(i,position(1))=angel;
            pop(i,position(2))=angel+1;
        end
        const = constraint(pop(i,:),chromlength,0);       
        end
end


