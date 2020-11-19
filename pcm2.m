function [xq,C,D,i]=pcm2(x,N,x_min,x_max)
%inputs: 
%   x: input signal
%   N: number of bits
%   x_min: minimum allowed value of signal
%   x_max: maximum allowed value of signal
%outputs:
%   xq: output signal
%   C: centroids after kmax loops
%   D: mean distortion for each loop
%   i: number of loops executed

%initialization of variables

i=1; %algorithm general loop index
i_max=1000; %maximum number of algorithm loops (needed as a timeout) 
e=0.000000001; %absolute distortion difference limit

M=2^N; % number of levels and intervals
step=(x_max-x_min)/M; % step of uniform quantizer

%transpose signal if column vector
if iscolumn(x)==true, x=x.'; end

%limit signal
x(x>x_max)=x_max;
x(x<x_min)=x_min;

% calculate initial levels
levels(1,1)=x_min+step/2;
for j=2:M
    levels(1,j)=levels(1,j-1)+step;
end

%general algorithm loop
while(i<i_max) 

    %calculate borders of quantization intervals
    for j =1:M-1
        T(i,j)=(levels(i,j)+levels(i,j+1))/2;
    end

    %quantize 
    [~,xq]=quantiz(x,T(i,:),levels(i,:));

    %calculate mean distortion
    y_yq=[x,xq]; %create matrix with y values and their quantized values
    [~,uniq_rows,~]=unique(y_yq(:,1)); %extract the rows with the unique values of y
    uniq_y_yq=y_yq(uniq_rows,:); %create matrix with unique y values and their quantized values
    pdf=normpdf(uniq_y_yq(:,1),-0.04,sqrt(0.11)); %create normal pdf for the unique values of y

    
    D(i)=trapz(uniq_y_yq(:,1),((uniq_y_yq(:,1)-uniq_y_yq(:,2)).^2).*pdf); %mean distortion is trapezoid_integral((y-yq))^2*P(y)*dy) where y=uniq_y_yq(:,1) and yq=uniq_y_yq(:,2)
    
    if(i>1) %only after the first loop has run because we need two values of D(i)
        if(abs(D(i)-D(i-1))<e)
            break
        end
    end

    %calculate new levels
    levels(i+1,1)=mean(x(x<=T(i,1))); %the first level
    for j=2:M-1 %the levels between 2 and M-1
        levels(i+1,j)=mean(x(x>T(i,j-1) & x<=T(i,j))); %level j of the i+1 loop will get the mean value of the x elements in the range between Tj-1 and Tj of the i loop
        if isnan(levels(i+1,j)), levels(i+1,j)=(T(i,j-1)+T(i,j))/2; end %if x>T(i,j-1) & x<=T(i,j) returns no value (we dont have continuous values so it is possible) then take the mean value of the two
    end
    levels(i+1,M)=mean(x(x>T(i,M-1))); %the last level

    i=i+1;

end

C=(levels(i,:)).'; %levels after i loops ("i" will have kmax value) (transpose to read more easily)
xq=xq.'; %(transpose to read more easily)
D=D.'; %(transpose to read more easily)


%plot
figure;
plot(x);
hold on
stairs(xq);
plot(zeros(1,M-1),T(i-1,:),'x');
plot(zeros(1,M),levels(i-1,:),'x');
hold off 

end
