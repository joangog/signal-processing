function [xq,ber,ser]=pam(x,M,encoding,SNR)

[r,s]=pam_encode(x,M,encoding,SNR); %r is signals, s is matched symbols
[xq,sq]=pam_decode(r,M,encoding);%xq is estimated binary stream, sq is estimated symbol vector

%remove excess bits
xq=xq(1:length(x));
%it is needed because when we seperate the stream into strings of logM bits if
%the division has a remainder, we fill the remainder with zeros to create an extra logM string 

ber=sum(x~=xq)/length(x);
ser=sum(s~=sq)/length(s);

end