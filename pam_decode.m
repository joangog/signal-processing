function [xq,s]=pam_decode(r,M,encoding)
%inputs:
%   r: signals
%   M: number of symbols
%   encoding: type of binary encoding ('regular' or 'gray')
%outputs:
%   s:symbol estimation for each signal vector
%   xq: binary stream

%variables

Es=1; %symbol energy

Tsymb=4; %symbol period (in ìsec)
Tc=0.4; %transmission zone period (in ìsec)
Tsamp=Tc/4; %sampling period (in ìsec)

fc=1/Tc; %transmission zone frequency (in KHz)

t=0:Tsamp:Tsymb; % the PAM will be implemented in one Tsymb period

%calculate A so that Eav=1
Eav=1; %average symbol energy
gT=sqrt(2*Es/Tsymb); %square signal
Eg=(gT^2)*Tsymb; %energy of pulse signal (calculated as max_value^2*duration )
A=sqrt(3/(Eg*(M^2-1))); %scaling coefficient


%create square pulse signal
gT=sqrt(2*Es/Tsymb);

%multiply signal
for i=1:size(r,1) %for each signal (row)
    r_mult(i,:)=r(i,:).*(gT.*cos(2*pi*fc*t));
end

%sum signal value for each moment in time 
r_sum=sum(r_mult,2)/10; %we divide by 10 for normalisation

%create symbol vector
m=(1:M).';
sm=(2*m-1-M)*A; %symbols

%match each value of r_sum to the closest existing symbol
s=zeros(length(r_sum),1);
for i=1:length(r_sum)
    [~,j]=min(abs(sm-r_sum(i))); %j is the index of the symbol with the closest value to r_sum 
    s(i)=sm(j);
end

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


%match input symbols to binary strings using the mapper

in_row=logical(zeros(M,1)); %initialise logical vertical vector (it will have this type of values:  1 (if each row of the mapper matches the input) or 0 (if not))
b=zeros(length(s),log2(M)); %vector of the symbols matched to the input binary strings

for i=1:length(s) %for every input symbol (every row of s)
    for j=1:M %search in every row of the mapper (column 1->symbol, column 2:end->binary)
        in_row(j)=isequal(mapper(j,1),s(i)); %save if x_sep(i) was found in row j
    end
    b(i,:)=mapper(in_row,2:end); %match the symbol s(i) with the binary string
end

xq=reshape(b.',1,[]); %create binary stream from binary strings (transform matrix to row vector)

disp('done decoding!');

end

