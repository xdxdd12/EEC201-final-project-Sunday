N = 512; % FFT size
numFilters = 30; % Number of mel filter banks
numCoeffs  = 20; % Number of MFCC coefficients

% Read audio and compute STFT
[S1, ~, ~, fs] = readSTFT('Zero_train1.wav', N); % Speaker 1 STFT
[S2, ~, ~, fs] = readSTFT('Zero_train2.wav', N); % Speaker 2 STFT

% Compute MFCC features
mfcc1 = compute_mfcc_from_spectrogram(S1, fs, N, numFilters, numCoeffs); % MFCC for Speaker 1
mfcc2 = compute_mfcc_from_spectrogram(S2, fs, N, numFilters, numCoeffs); % MFCC for Speaker 2

numCentroids = 12; % LBG codebook size
epsilon = 0.005;   % LBG convergence threshold

% Compute LBG codebook for each speaker
codebook1 = LBG(mfcc1, numCentroids, epsilon); % Codebook for Speaker 1
codebook2 = LBG(mfcc2, numCentroids, epsilon); % Codebook for Speaker 2

% Select MFCC dimensions 4 and 5 for visualization
mfcc1_selected = mfcc1(4:5, :); % Selected MFCC for Speaker 1
mfcc2_selected = mfcc2(4:5, :); % Selected MFCC for Speaker 2

% Select Codebook dimensions 4 and 5 for visualization
codebook1_selected = codebook1(4:5, :); % Selected Codebook for Speaker 1
codebook2_selected = codebook2(4:5, :); % Selected Codebook for Speaker 2

% Plot the mel filter bank response
plot_mel_filterbank(N, numFilters, fs);

% Plot MFCC scatter plot
figure;
hold on;
scatter(mfcc1_selected(1, :), mfcc1_selected(2, :), 10, 'r', 'filled'); % Speaker 1 MFCC
scatter(mfcc2_selected(1, :), mfcc2_selected(2, :), 10, 'b', 'filled'); % Speaker 2 MFCC

xlabel('MFCC Coefficient 4');
ylabel('MFCC Coefficient 5');
title('MFCC Visualization');
legend({'Speaker 1 MFCC', 'Speaker 2 MFCC'});
grid on;
hold off;
