function xq=adm_decode(b,d,M)
%inputs:
%   b: input signal
%   d: initial delta step
%   M: downsample signal by M
%outputs:
%   xq: step sum signal and output signal

%initialization of variables

K=1.5;
len=length(b);

xq=zeros(len,1); %step sum signal and output
if b(1)==1, xq(1)=d; else, xq(1)=-d; end  %initial value

D=zeros(1,len); %delta step vector for each segment of the step signal
D(1)=d; %initial value 

for i=2:len
    
    %calculate new step D(i)
    if b(i)==b(i-1)
        D(i)=D(i-1)*K;
    else
        D(i)=D(i-1)/K;
    end
    
    %sum of steps
    xq(i)=xq(i-1)+b(i)*D(i);
  
end

%downsample to original sampling frequency
xq=downsample(xq,M);

end