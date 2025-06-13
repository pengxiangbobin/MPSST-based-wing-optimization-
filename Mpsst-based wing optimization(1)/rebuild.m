function [fulllayercode, layercode] = rebuild(popa,popu,popm,layercode,i)
% Reconstruct the original ternary variable encoding into a layer sequence encoding
% Results of reconstructing by inserting the i-th layer.
   p = ceil(i/2);
    layercode1 = layercode(1:popu(1,p));
    layercode2 = layercode(popu(1,p)+1:end);
    layercode3 = popa(1,p);  
    if popm == 0
        flayercode = fliplr(layercode);
        fulllayercode = [layercode flayercode];
    else
        layercode = [layercode1 layercode3 layercode2];
        flayercode = fliplr(layercode);
        layercode4 = layercode2(1:end-1);
        fulllayercode = [layercode1 layercode3 layercode4 flayercode];
    end 

end

% if popm == 0
%         flayercode = fliplr(layercode);
%         fulllayercode = [layercode flayercode];
%     else
%         layercode = [layercode1 layercode3 layercode2];
%         flayercode = fliplr(layercode);
%         layercode4 = layercode2(1:end-1);
%         fulllayercode = [layercode1 layercode3 layercode4 flayercode];
%     end