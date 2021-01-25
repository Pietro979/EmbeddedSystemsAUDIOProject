close all
clear all

[Y,Fs] = audioread('frozen.wav');

for i= 1:100:1000000
    Y(i) = Y(i) + rand()/10;
end

plot(Y)

sound(Y,Fs)