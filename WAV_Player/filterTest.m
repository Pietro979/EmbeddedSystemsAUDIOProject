% FIR Window Bandpass filter designed using the FIR1 function.
% All frequency values are in Hz.
Fs = 44100;    % Sampling Frequency

N    = 50;     % Order
Fc1  = 0.4e3;    % First Cutoff Frequency
Fc2  = 8e3;    % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'LOW', win, flag);

dlmwrite('coeff.txt',b)
