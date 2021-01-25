% Two Channel implementation of the LMS algorithm
clear all;close all;
sigfile='queen.wav'; % Read the recorded signal
noisefile='szum.wav'; % Read the recorded noise
%[sig_noise,fs_sig,nbits_sig,refnoise]=sig_plus_noise(sigfile,noisefile); % Generate a synthetic noise from this reference noise,mix it with signal, and return the mixed file
[sig,fsd]=audioread('orginal.wav');
sig_noise = sig(:,1);
refnoise = sig(:,1)-sig(:,2);
file_len=length(sig_noise); % Length of the file
L=input('Enter the order of the reconstruction filter: '); % Order of the filter
e=zeros(file_len,1); % Put place-holder zeros for error vector
w=zeros(L,1); % Put place-holder zeros for weight vector
eta= 1;%input('Enter the learning rate for LMS: '); % Gain constant that regulates the speed and stability of adaptation
for i=L+1:file_len
 e(i)=sig_noise(i)-refnoise(i-L+1:i)'*w; % Calculation of Error vector
 w=w+eta*e(i)*refnoise(i-L+1:i); % Calculation of the Weight vector
end
figure(1), hold on, 
%axis([0 520000 -1 1]); 
grid on
subplot(1,2,1)
plot(sig_noise,'g');
title('Orginal')
subplot(1,2,2)

plot(e,'r','LineWidth',2);
%axis([0 520000 -1 1]);
title('After two sources LMS Filter')
audiowrite('two_channel.wav',e,fsd) % Write the output signal to a music file