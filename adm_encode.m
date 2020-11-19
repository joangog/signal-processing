function b=adm_encode(x,d,M)
%inputs:
%   x: input signal
%   d: initial delta step
%   M: oversample signal by M
%outputs:
%   b: binary signal

%oversample signal
x_=interp(x,M);

%initialization of variables

K=1.5;
len=length(x_);

b=zeros(len,1); %output signal
if x_(1)>0, b(1)=-1; else, b(1)=-1; end %initial value, assuming x(0)=0 so the comparison x(1)>0 is used

st=zeros(len,1); %step sum signal
if b(1)==1, st(1)=d; else, st(1)=-d; end  %initial value

D=zeros(len,1); %delta step vector for each segment of the step sum signal
D(1)=d; %initial value

for i=2:len
    
    %calculate b(i)
    if x_(i)-st(i-1)>=0 
        b(i)=1;
    elseif x_(i)-st(i-1)<0
        b(i)=-1;  
    end
    
    %calculate new step D(i)
    if b(i)==b(i-1)
    D(i)=D(i-1)*K;
    else
        D(i)=D(i-1)/K;
    end
    
    %sum of steps
    st(i)=st(i-1)+b(i)*D(i);

end

end