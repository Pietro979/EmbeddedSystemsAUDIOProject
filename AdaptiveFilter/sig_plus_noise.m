function [sig_noise,fs_sig,nbits_sig,ref_noise]=sig_plus_noise(sigfile,noisefile)
% This function takes in the reference signal, the noise to be added and
% generates a synthesized signal plus noise file.
[ref_sig,fs_sig,nbits_sig]=audioread(sigfile); % Read the pure signal to be added
[ref_noise,fs_noise,nbits_noise]=wavread(noisefile); % Read the reference noise
h=input('Enter the h[n] for generating noise: '); % Get the h[n] from useradd_noise=gennoise(ref_noise,h,fs_noise,nbits_noise); % Generate a synthetic noise signal to be added 
sig_noise_len=min(length(add_noise),length(ref_sig)); % Get the length of the larger of the two files to be mixed
sig_noise=zeros(sig_noise_len,1); % Put place-holder zeros
sig_noise= (ref_sig(1:sig_noise_len)+ add_noise(1:sig_noise_len)); % Mix the two files
wavwrite(sig_noise,fs_sig,nbits_sig,'sig_noise.wav'); % Write signal mixed with noise output to the music file
end