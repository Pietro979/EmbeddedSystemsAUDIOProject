
close all
clear all

%Parametry 
dt = 0.01;
t_end = 10;
t = 0:dt:t_end;

% Odchylenie standardowe pomiaru
std_dev = 10;
 
% Model stanowy
A = 10;
C = 0.5;
 
% Macierze kowariancji szumow
V = 0.1*std_dev*dt;
W = std_dev*std_dev;
 
% Wartosci poczatkowe
x0 = 0;
P0 = 0.5;
xpri = x0;
Ppri = P0;
xpost = x0;
Ppost = P0;
 

%% Wczytanie audio
[Y,Fs] = audioread('frozen.wav');

%% Zakłócenia 
dist = rand(size(Y));

Yf(1) = x0;

for i = 1:size(Y)
    
    if i > 1
        % aktualizacja czasu
        xpri = A*xpost;
        Ppri = A*Ppost*A' + V;
        
        % aktualizacja pomiarow
        eps = Y(i) - C*xpri;
        S = C*Ppri*C' + W;
        K = Ppri*C'*S^(-1);
        xpost = xpri + K*eps;
        Ppost = Ppri - K*S*K';
        
        Yf(i) = xpost;
    end
end

figure(1)
plot(Y)
title('przed Kalmanem')

figure(2)
plot(Yf)
title('po Kalmanie')
