AROrder = 10; % Auto regressive filter order.
NumIter = 10;

[Input, Fs] = audioread('frozen.wav');
Input = Input(:,1);
Noise = Input(1:0.3*length(Input));
Time = (0:1/Fs:(length(Input)-1)/Fs)';


H = [zeros(1,AROrder-1),1];
R = var(Noise);
[FiltCoeff, Q] = lpc(Input, AROrder);

P = R * eye(AROrder,AROrder);   % Error covariance matrix.
Output = zeros(1,size(Input,1));   % Allocating memory for output signal.
Output(1:AROrder) = Input(1:AROrder,1)';   % Initializing output signal according to equation (13)
OutputP = Input(1:AROrder,1);

i = AROrder+1;
j = AROrder+1;
WinLenSamples = fix(0.025 * Fs);

for k = 1:length(FiltCoeff)   % For every segment of chopped signal...
    jStart = j;     % Keeping track of AROrder+1 value for every iteration.
    OutputOld = OutputP;    % Keeping the first AROrder amount of samples for every iteration.
    
    for l = 1:length(Input)
        A = [zeros(AROrder-1,1) eye(AROrder-1); fliplr(-FiltCoeff(k,2:end))];
        
        for ii = i:WinLenSamples
            OutputC = A * OutputP;
            Pc = (A * P * A') + (H' * Q(k) * H);
            K = (Pc * H')/((H * Pc * H') + R);
            OutputP = OutputC + (K * (Input(ii,k) - (H*OutputC)));
            Output(j-AROrder+1:j) = OutputP';
            P = (eye(AROrder) - K * H) * Pc;
            j = j+1;
        end
        
        i = 1;
        if l < NumIter
            j = jStart;
            OutputP = OutputOld;
        end
        
        % update lpc on filtered signal
        [FiltCoeff(k,:), Q(k)] = lpc(Output((k-1)*WinLenSamples+1:k*WinLenSamples),AROrder);
    end
end
Output = Output';