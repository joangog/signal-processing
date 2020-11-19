%script to find probability and mean distortion of 2-bit PCM signal using normal distribution

%variables
Pexp=zeros(length(C),1); %experimental probability
Pnorm=zeros(length(C),1); %theoretical probability


y_yq=[y,yq]; %create matrix with y values and their quantized values
[~,uniq_rows,~]=unique(y_yq(:,1)); %extract the rows with the unique values of y
uniq_y_yq=y_yq(uniq_rows,:); %create matrix with unique y values and their quantized values

pdf=normpdf(uniq_y_yq(:,1),-0.04,sqrt(0.11)); %create normal pdf for the unique values of y

%calculate probability of levels of 2-bit PCM experimentally
[~,Pexp]=calc_entropy(yq,C); 


%calculate probability of levels of 2-bit PCM theoretically using normal distribution
for i=1:length(C)
    if sum(uniq_y_yq(:,2)==C(i))<2 %if there is none or just one value quantized to this level then integral is zero and thus P is zero
        Pnorm(i)=0;
    else
        %create vector with the probability of each level calculated as the
        %trapezoid integral (because discreet values) of the pdf over the range of the unique values of y
        %which their quantized value is equal to the current level
        Pnorm(i)=trapz(uniq_y_yq(uniq_y_yq(:,2)==C(i)),pdf(uniq_y_yq(:,2)==C(i)));
    end
end

%calculate mean distortion of signal experimentally (already calculated from pcm function)
Dexp=D(end); %mean dist from last loop of algorithm

%calculate mean distortion of signal theoretically using normal distribution
Dnorm=trapz(uniq_y_yq(:,1),((uniq_y_yq(:,1)-uniq_y_yq(:,2)).^2).*pdf); %mean distortion is trapezoid_integral((y-yq))^2*P(y)*dy) where y=uniq_y_yq(:,1) and yq=uniq_y_yq(:,2)

