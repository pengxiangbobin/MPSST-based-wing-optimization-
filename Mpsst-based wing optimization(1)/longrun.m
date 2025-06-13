function [L,val]=longrun(a)
  A(1,1)=a(1);%The first column records the elements that appear
  A(1,2)=1;%The second column records the number of consecutive occurrences of that element
  j=1;
for i=2:length(a)
    if a(i)==a(i-1)
        A(j,2)=A(j,2)+1;%For consecutive occurrences, increment the value in the second column by 1
    else %When a new element appears, initialize the j-th row of A
        j=j+1;
        A(j,1)=a(i);
        A(j,2)=1;
    end
end
Num=A(:,1);
L=A(:,2);
if size(a,1)-size(a,2)>=0%Ensure that both input and output are either row vectors or column vectors.
    val=Num(L==max(L));
else
    val=(Num(L==max(L)))';
end
end
