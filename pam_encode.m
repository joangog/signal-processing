function [r,s]=pam_encode(x,M,encoding,SNR)
%inputs:
%   x: binary stream
%   M: number of symbols
%   encoding: type of binary encoding ('regular' or 'gray')
%   SNR
%outputs:
%   r: output signals
%   s:matched symbols for each binary string


%variables

Es=1; %symbol energy
Eb=Es/log2(M); %bit energy

Tsymb=4; %symbol period (in ìsec)
Tc=0.4; %transmission zone period (in ìsec)
Tsamp=Tc/4; %sampling period (in ìsec)

fc=1/Tc; %transmission zone frequency (in KHz)

N0=Eb/10^(SNR/10); %constant in variance formula

t=0:Tsamp:Tsymb; % the PAM will be implemented in one Tsymb period

x_len=length(x);


%calculate A using Eav=1
gT=sqrt(2*Es/Tsymb); %square signal
Eg=(gT^2)*Tsymb; %energy of pulse signal (calculated as max_value^2*duration )
A=sqrt(3/(Eg*(M^2-1))); %scaling coefficient


%mapper (seperate x stream into binary  strings of log2(M) bits)

%b will contain on each row every string of log2(M) bits therefore log2(M) columns
b_col=log2(M); 
b_row=ceil(x_len/log2(M));
b=zeros(b_row,b_col); %initialize b

for i=1:b_row
    for j=1:b_col
        if (i-1)*b_col+j>x_len %if the index goes beyond the length of x, then stop 
            break
        end
        b(i,j)=x(1,(i-1)*log2(M)+j);
    end
end


%create symbol vector
m=(1:M).';
sm=(2*m-1-M)*A; %symbols


%create [symbol,binary] mapper
if strcmp(encoding,'regular')
    bin=de2bi(0:M-1,'left-msb');
    mapper=[sm,bin];
elseif strcmp(encoding,'gray')
    bin=gray_code(log2(M)); %see gray_code.m
    mapper=[sm,bin];
else
    error('Error: Specify encoding ("regular" or "gray").')
end


%match input binary strings to symbols with mapper

in_row=logical(zeros(M,1)); %logical vertical vector with values 1 if each row of the mapper matches the input or 0 if not
s=zeros(b_row,1); %vector of the symbols matched to the input binary strings

for i=1:b_row %for every input binary string (every row of b)
    for j=1:M %search in every row of the mapper (column 1->symbol, column 2:end->binary)
        in_row(j)=isequal(mapper(j,2:end),b(i,:)); %save if b(i) was found in row j
    end
    s(i)=mapper(in_row,1); %match the binary b(i) with the symbol s(i)
end

%create square pulse signal
gT=sqrt(2*Es/Tsymb);

%create signals
s_sig=s*(gT.*cos(2*pi*fc*t));

%create white noise signals
n=random('Normal',0,sqrt(N0/2),size(s_sig));

%ouput signals
r=s_sig+n;

disp('done encoding!');
% figure;
% hold on
% for i=1:size(r,1)
%     plot(t,r(i,:));
% end
% hold off

end