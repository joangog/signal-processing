function [e,P]=calc_entropy(xq,C)
%inputs
%   xq: input quantizes signal
%   C: levels of signal (its discreet values)
% outputs:
%   e: entropy
%   P: probability vector for each discreet value 

%init variables
P=zeros(length(C),1);

%calculate probability of each value
for i=1:length(C)
    P(i)=sum(xq==C(i))/length(xq);
end

e=-sum(P(P~=0).*log2(P(P~=0))); %ignore zero values

end