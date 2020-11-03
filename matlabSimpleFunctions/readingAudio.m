%% clear and close
clear all;
close all;

%% Reading WAV files in matlab
[y,Fs] = audioread('ex1.wav');

%% Create some disturbances
dist = rand(size(y));

for i= 50000:200000
    y(i) = y(i) + rand();
end

%% Play audio
sound(y, Fs);