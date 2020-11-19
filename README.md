# signal-processing

**Pulse Code Modulation:**
- Read file: 
  - Audio: [y,fs,fs]=audioread('speech.wav');
  - Image: img_read;
- Execute Modulation: 
  - 2-bit PCM: [yq,C,D,i]=pcm(y,2,min(y),max(y));
  - 4-bit PCM: [yq,C,D,i]=pcm(y,4,min(y),max(y));
  - 8-bit PCM: [yq,C,D,i]=pcm(y,8,min(y),max(y));
  - ADM (D=0.01, hypersampling M=10): [yq,D]=adm(y,0.01,10);
- Output:
  - Audio: sound(yq);
  - Image: img_print;
- Compare compressions using SQNR: sqnr=calc_sqnr(y,D);
- Calculate Entropy: [e,P]=calc_entropy(yq,C);

**Pulse Amplitude Modulation:**
- Create random bit series: x=rand(1,10000); x(x>=0.5)=1; x(x<0.5)=0;
- Execute Modulation: 
  - 4-PAM: [~,BER(i),SER(i)]=pam(x,4,'regular',SNR(i));
- Plot Bit Error Rate and Symbol Error Rate: plot_ber_ser;




