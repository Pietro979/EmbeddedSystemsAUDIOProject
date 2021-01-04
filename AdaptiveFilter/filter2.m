% One channel implementation of the LMS algorithm
clear all;
close all;
[sig,fsd]=audioread('queen.wav'); % Reading music file with a noise

sig2=sig(:,1); % Processing only first 1000000 samples toreduce the time, Input to the primary channel
% for i=100000:10:150000
%     sig2(i) = sig2(i) + 0.5*rand;
% end

sig2 = awgn(sig(:,1),20);

ylen=length(sig2);
d=300; % Large delay to make noise uncorrelated as possible
sig_del=zeros(ylen,1);
sig_del(d:ylen)=sig2(1:ylen-d+1); % Delayed signal, Input to the reference channel

e=zeros(ylen,1);
w=zeros(ylen,1); 
w1=zeros(ylen,1); 
L=500; % Filter order

eta=0.001; % Learning rate that regulates the speed and stabilityof adaptation

for i=L+1:ylen
e(i)=sig2(i)-transpose(sig_del(i-L+1:i))*w(i-L+1:i); %Calculation of Error
w(i-L+2:i+1)=w(i-L+1:i)+2*eta*e(i)*sig_del(i-L+1:i); %Calculation of the Weight vector
w1(i)=transpose(sig_del(i-L+1:i))*w(i-L+1:i);% Output signal of our code
end



subplot(411);
plot(sig2); title('Signal');
subplot(412);
plot(sig_del); title('Delayed signal');
subplot(413);
plot(e); title('Error');
subplot(414);
plot(w1); title('Restored signal');
echo on;
%complete!
echo off;
w1=w1/max(abs(max(w1)),abs(min(w1))); 
% Normalization of output toprevent data clipping
soundsc(w1,fsd);
