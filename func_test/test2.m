function test2
[signal, fs] = audioread('Zero_train1.wav');

fprintf('Sampling rate of %s : %d Hz\n', 'Zero_train1.wav', fs);

sound(signal, fs);

% calculate time of 256 samples
num_samples = 256;
time_ms = (num_samples / fs) * 1000;
fprintf('time of 512 samples: %.2f ms\n', time_ms);

% plot signal in time domain
figure;
plot((1:length(signal)) / fs, signal);
xlabel('Time(s)');
ylabel('Amplitude');
title('Signal in Time Domain');
grid on;

% normalization
signal = signal / max(abs(signal));

N = 128;
M = round(N / 3); % frame increment
[S, F, T] = spectrogram(signal, N, N - M, N, fs, 'yaxis');

figure;
imagesc(T * 1000, F, 10 * log10(abs(S))); 
axis xy;
xlabel('Time (ms)');
ylabel('Frequency (Hz)');
title(['STFT spectrum (N = ' num2str(N) ')']);
colorbar;
end