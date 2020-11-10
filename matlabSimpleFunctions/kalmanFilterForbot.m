%% Clear
clear all;
close all;

%% Kalman Filter
% Parametry symulacji
dt = 0.1;
t_end = 10;
t = 0:dt:t_end;
 
% Odchylenie standardowe pomiaru
std_dev = 10;
 
% Model stanowy
A = 1;
C = 1;
 
% Macierze kowariancji szumow
V = 5*std_dev*dt;
W = std_dev*std_dev;
 
% Wartosci poczatkowe
x0 = 0;
P0 = 1;
xpri = x0;
Ppri = P0;
xpost = x0;
Ppost = P0;
 
% Wektory wynikow
Y = zeros(1, size(t,2));
Yf = Y;
Yf(1) = x0;
 
for i = 1:size(t,2)
    
    if i < 50
        Y(i) = std_dev*randn(1);
    else
        Y(i) = std_dev*randn(1) + 100;
    end
 
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
 
plot(t, Y, 'b', t, Yf, 'r', 'LineWidth', 1.5)
title('Filtr Kalmana')
xlabel('Czas')
ylabel('Sygnal mierzony')
legend('Wartosc mierzona', 'Wartosc estymowana')