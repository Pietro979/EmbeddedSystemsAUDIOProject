 
clear all
close all
%%
[A,fs]=audioread('queen.wav');
Audio=A(:,1);

for i=20000:10:100000
    Audio(i) = Audio(i) + rand*rand;
end
u= 0.1; % learning rate
order=30; % number of filter coefficients
figure,
w= zeros(1,order);
iter=1;
for n=order+1:numel(Audio)
    if rem(n,4000)==0
        stem(w)
        title('Filter Coefficients');
        grid();
        ylim([-1 1]);
        pause(0.0001)
    end
    x=Audio(n-1:-1:n-order);
    y(n)= w*x;
    e(n)= y(n)+Audio(n);
    Atten(iter)= sum(abs(e(1:n)))/sum(abs(Audio(1:n)));
    
    if Atten(iter)<0.1
        disp('Converged');
        iter
        break;
    end
    w=w - u * e(n) * x';
    iter=iter+1;
end
figure,
plot(Atten), title('Attenuation')
xlabel('Iteration')
Settling_time=iter/fs
for n=order+1:numel(Audio)
    x=Audio(n-1:-1:n-order);
    y(n)= w*x;
    e(n)= y(n)+Audio(n);
end
figure
subplot(3,1,1), plot(Audio), title('Original Noise');
subplot(3,1,2), plot(y) , title('Result Noise for attenuation');
subplot(3,1,3), plot(Audio+y'), title(' Attenuated Noise'), ylim([-2 2]);
soundsc(Audio,fs);
pause(17)
soundsc(Audio+y',fs);
Atten= sum(abs(e))/sum(abs(Audio))