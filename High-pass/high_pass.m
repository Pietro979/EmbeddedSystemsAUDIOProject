close all
clear all

[y,Fs] = audioread('orginal.wav');

N    = 50;     % Order
Fc1  = 5e3;    % First Cutoff Frequency
Fc2  = 10e3;    % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'HIGH', win, flag);
out = filter(b,1,y);
figure(1), hold on, 
%axis([0 4000 .4 1.6]), 
grid on
subplot(1,2,1)
plot(y,'g');
title('Orginal')
subplot(1,2,2)
plot(out,'r','LineWidth',2);
title('After High-pass Filter')
soundsc(out,Fs);

dlmwrite('coeff.txt',b)

audiowrite('high_pass.wav',out,Fs)