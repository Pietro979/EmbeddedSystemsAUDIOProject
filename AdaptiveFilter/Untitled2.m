close all;
clear all;

[sig,fsd]=audioread('queen.wav'); % Reading music file with a noise

sig2=sig(:,1);

out = zeros(length(sig2),1);
B =ones(length(sig2),1);
A = ones(length(sig2),1);
order = 20;
for i = 21 : length(sig2)

    for k =1:order
        out(i) = out(i) + B(k)*sig2(i-k)-A(k)*out(i-k); 
    end
end

plot(out);