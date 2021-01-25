clear all;
close all;
[sig,fsd]=audioread('queen.wav');

%add white noise
sigNoise = awgn(sig(:,1),20);

%Signal segmentation, devide signal into 40ms frames
j = 1;
z=1;
audio = sigNoise;
% for i=1:length(sig)
%         audio(z,j) = sigNoise(i);
%         j = j +1;
%         if j >1764 %1764 coz frame is 40ms
%             z = z + 1;
%             j = 1;
%         end
% end

% e=zeros(length(audio(:,1)),length(audio(1,:)));
% w=zeros(length(audio(:,1)),length(audio(1,:)));
% w1=zeros(length(audio(:,1)),length(audio(1,:))); 
u= 0.1; % learning rate
order=500; % number of filter coefficients

w= zeros(1,order);
iter=1;

for n=order+1:numel(audio)
        x=audio(n-1:-1:n-order);
        y(n)= w*x;
        e(n)= y(n)+audio(n);
        Atten(iter)= sum(abs(e(1:n)))/sum(abs(audio(1:n)));
    
%     if Atten(iter)<0.1
%         disp('Converged');
%         iter
%         break;
%     end
    w=w - u * e(n) * x';
    iter=iter+1;
end


