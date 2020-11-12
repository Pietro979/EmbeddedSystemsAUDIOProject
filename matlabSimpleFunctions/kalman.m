% Parametry symulacji

 
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
 

%% Reading WAV files in matlab
[Y,Fs] = audioread('ex1.wav');

%% Create some disturbances
dist = rand(size(Y));

Yf = Y;
Yf(1) = x0;

for i= 50000:200000
    Y(i) = Y(i) + rand();
end
Y
%% Play audio
%sound(Y, Fs);

dt = 0.01;
t_end = 10;
t = 0:dt:t_end;

for i = 1:size(t,2)
    
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
sound(Yf, Fs);
% plot(t, Y, 'b', t, Yf, 'r', 'LineWidth', 1.5)
% title('Filtr Kalmana')
% xlabel('Czas')
% ylabel('Sygnal mierzony')
% legend('Wartosc mierzona', 'Wartosc estymowana')