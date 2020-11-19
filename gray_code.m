function [b]=gray_code(N)
%the function follows the algorithm written in the chapter "Constructing an
%n-bit Gray code" in the page "https://en.wikipedia.org/wiki/Gray_code"

%inputs
%   N: number of bits
%outputs:
%   b: binary gray encodings in the appropriate order

M=2^N;
b=[0;1]; % start with 1-bit gray

while size(b)~=[M,N]
%b currently contains matrix of n-bit gray encodings
b_=flip(b); %mirror
b=[zeros(size(b,1),1),b]; %add vector of zeros at the left of unmirrored sub-matrix
b_=[ones(size(b_,1),1),b_]; %add vector of ones at the left of mirrored sub-matrix
b=[b;b_]; %merge into matrix with the first matrix on top and the second on the bottom
%now b contains matrix of n+1-bit encodings

%continue until the matrix contains M N-bit gray encodings

end
end