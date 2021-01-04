close all;
clear all;

[A_, Fs] = audioread('queen.wav');
A_ = A_(:,1);

A_ = awgn(A_,100);
w1= 10000;
fi = 0;
a1 = 10;
alfa = exp(1i*w1/Fs);
uk = a1*exp(1i*w1/Fs+1i*fi);
ukstar = a1*exp(-1i*w1/Fs-1i*fi);

A = [1 0 0;
     uk alfa 0;
     -ukstar/(alfa^2) 0 1/alfa];
B = [0; 0];

H= [0, 0.5, 0.5];

q = 4.11e-6*1e0;

Q = [q 0 0;
     0 q 0;
     0 0 q];
     
R = 0.11596*1e0;

xk_p=[exp(1i*w1/Fs);
      a1*exp(1i*w1/Fs);
      a1*exp(-1i*w1/Fs)];        % warunek poczatkowy stanu
Pk=Q*1e3;               % eskerymentowac zmieniajac o kilka rzedow       
xk=zeros(3,length(A_));

for i=1:length(A_)
    xk_ = A*xk_p; 
    Pk_ = A*Pk*A' + Q;
    Kk = Pk_*H'*( (H*Pk_*H' + R)^-1 );
    xk(:,i) = xk_ + Kk*( A_(i) - H*xk_ );
    Pk = (eye(3,3) - Kk*H)*Pk_;
    xk_p=xk(:,i);
end

%% Plots
figure(1), hold on, 
%axis([0 20 .4 1.6]), 
grid on
subplot(1,2,1)
plot(A_,'g');
subplot(1,2,2)
plot(real(xk(2,:)),'r','LineWidth',2);
soundsc(real(xk(2,:)),Fs);