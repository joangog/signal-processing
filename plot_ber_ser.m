%script to plot ber and ser

%variables
SNR=0:2:20;
BER=zeros(1,11);
SER=zeros(1,11);

%plot BER and SER for M=4 and encoding='regular'

for i=1:1:11
[~,BER(i),SER(i)]=pam(x,4,'regular',SNR(i));
end

close all;

ber_fig=figure('Name','BER');
semilogy(SNR,BER); %plot with logarithmic on y axis

hold on %hold ber figure 

ser_fig=figure('Name','SER');
semilogy(SNR,SER);

hold on %hold ser figure


%plot BER for M=8 and encoding='gray'

for i=1:1:11
[~,BER(i),~]=pam(x,8,'gray',SNR(i));
end

figure(ber_fig);
semilogy(SNR,BER);
legend('M=4, Regular','M=8, Gray');

hold off %close ber figure

%plot SER for M=8 and encoding='regular'

for i=1:1:11
[~,~,SER(i)]=pam(x,8,'gray',SNR(i));
end

figure(ser_fig);
semilogy(SNR,SER);
legend('M=4, Regular','M=8, Regular');

hold off %close ser figure
