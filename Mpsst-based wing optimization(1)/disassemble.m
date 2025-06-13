function [popa,popu] = disassemble(bestindividual,difthick)
%disassemble Split the long encoding into separate variable encodings
popa = bestindividual(1,1:difthick);
popu = bestindividual(1,difthick+1:2*difthick);
end

