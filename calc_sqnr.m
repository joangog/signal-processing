function values=calc_sqnr(sig,D)
%inputs:
%   sig: input signal
%   D: mean distortion of signal for each loop of algorithm
%outputs:
%   values: values of sqnr

%variables
dim=size(D);
sz=dim(1);

%SQNR will be calculated as E[x^2]/E[(x-xq)^2]

%calculate E[x^2] where x is signal
mean_sig=mean(sig.^2);

for i=1:sz %for each loop of the pcm algorithm
    values(i)=mean_sig/D(i);
end

%plot
figure;
plot(values);

end