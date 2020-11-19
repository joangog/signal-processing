function [xq,D]=adm(x,d,M)
%inputs:
%   x: input signal
%   d: initial delta step
%   M: oversample signal by M
%outputs:
%   xq: output signal
%   D: mean distortion

b=adm_encode(x,d,M);
xq=adm_decode(b,d,M);
D=mean((x-xq).^2);

figure;
plot(x);
hold on
stairs(xq);
hold off;

end