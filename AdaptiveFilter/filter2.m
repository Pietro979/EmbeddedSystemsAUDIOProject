% One channel implementation of the LMS algorithm
clear all;
close all;
[sig,fsd]=audioread('orginal.wav'); % Reading music file with a noise

sig2=sig(:,1); % Processing only first 1000000 samples toreduce the time, Input to the primary channel
% for i=100000:10:150000
%     sig2(i) = sig2(i) + 0.5*rand;
% end

sig2 = awgn(sig(:,1),100);

ylen=length(sig2);
d=50000; % Large delay to make noise uncorrelated as possible
sig_del=zeros(ylen,1);
sig_del(d:ylen)=sig2(1:ylen-d+1); % Delayed signal, Input to the reference channel

e=zeros(ylen,1);
w=zeros(ylen,1); 
w1=zeros(ylen,1); 
L=50; % Filter order

eta=0.001; % Learning rate that regulates the speed and stabilityof adaptation

for i=L+1:ylen
e(i)=sig2(i)-transpose(sig_del(i-L+1:i))*w(i-L+1:i); %Calculation of Error
w(i-L+2:i+1)=w(i-L+1:i)+2*eta*e(i)*sig_del(i-L+1:i); %Calculation of the Weight vector
w1(i)=transpose(sig_del(i-L+1:i))*w(i-L+1:i);% Output signal of our code
end



%% Plots
figure(1), hold on, 
%axis([0 4000 .4 1.6]), 
grid on
subplot(1,2,1)
plot(sig2,'g');
title('Orginal')
subplot(1,2,2)
plot(w1,'r','LineWidth',2);
title('After Single source LMS Filter')
%axis([0 400000 -3 3]),

w1=w1/max(abs(max(w1)),abs(min(w1))); 
% Normalization of output toprevent data clipping
soundsc(w1,fsd);
audiowrite('single_source_LMS.wav',w1,fsd)