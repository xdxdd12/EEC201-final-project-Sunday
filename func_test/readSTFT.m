function [S, F, T, fs] = readSTFT(filename,N) 

[signal, fs] = audioread(filename);

fprintf('Sampling rate of %s : %d Hz\n', filename , fs);
% normalization
signal = signal / max(abs(signal));
M = round(N / 3); % frame increment
[S, F, T] = spectrogram(signal, N, N - M, N, fs, 'yaxis');

end

