function SST = sequence(bestindividual,minlayer,difthick)
%SEQUENCE Construct SST
layercode = encode(minlayer);
minlayer1 = fliplr(minlayer);
SST{1,1} = [minlayer minlayer1];
[popa,popu] = disassemble(bestindividual,difthick);
for c=1:2*difthick
    if mod(c,2) == 1
    popm = 1;
     [fulllayercode,layercode] = rebuild(popa,popu,popm,layercode,c);
    SST{1,c+1} = decode(fulllayercode);
    else
    popm = 0;
      [fulllayercode,layercode] = rebuild(popa,popu,popm,layercode,c);
    SST{1,c+1} = decode(fulllayercode);
    end
end



% bestindividual= pop(index,:)
% SST = 0





% layercode = encode(minlayer);
% minlayer1 = fliplr(minlayer);
% SST{1,1} = [minlayer minlayer1];
% [popa,popu] = disassemble(bestindividual,difthick);
% for c=1:2*difthick
%     if mod(c,2) == 1
%     popm = 1;
%      [fulllayercode,layercode] = rebuild(popa,popu,popm,layercode,c);
%     SST{1,c+1} = decode(fulllayercode);
%     else
%     popm = 0;
%       [fulllayercode,layercode] = rebuild(popa,popu,popm,layercode,c);
%     SST{1,c+1} = decode(fulllayercode);
%     end
end






