function speaker_identification()
    % parameter settings
    N = 512; % FFT size
    numFilters = 30;
    numCoeffs  = 20;
    numCentroids = 12; % LBG number of centroids
    epsilon = 0.005;    % LBG error
    applyNotchFilter = false; % Apply Notch filter

    % training: traverse the training folder and build LBG codebook
    training_folder = 'GivenSpeech_Data_training/Eleven Training/'; 
    training_files = dir(fullfile(training_folder, '*.wav'));
    
    speaker_codebooks = struct(); % store all speaker codebooks
    speaker_names = {}; % store all speaker names

    for i = 1:length(training_files)
        filename = fullfile(training_folder, training_files(i).name);
        
        % read training audio
        [S_train, ~, ~, fs] = readSTFT(filename, N, false);
        mfcc_train = compute_mfcc_from_spectrogram(S_train, fs, N, numFilters, numCoeffs);

        % training LBG codebook
        codebook = LBG(mfcc_train, numCentroids, epsilon);
        
        % store codebook
        speaker_name = erase(training_files(i).name, '.wav'); % get speaker name
        speaker_codebooks.(speaker_name) = codebook;
        speaker_names{i} = speaker_name;
    end

    % testing: traverse the test folder and classify speakers
    test_folder = 'GivenSpeech_Data_test/Eleven Test/'; 
    test_files = dir(fullfile(test_folder, '*.wav'));
    
    for i = 1:length(test_files)
        test_filename = fullfile(test_folder, test_files(i).name);

        % read test radio
        [S_test, ~, ~, fs] = readSTFT(test_filename, N, applyNotchFilter);
        mfcc_test = compute_mfcc_from_spectrogram(S_test, fs, N, numFilters, numCoeffs);

        % calculate the min distance to each training codebook
        min_distance = Inf;
        predicted_speaker = '';

        for j = 1:length(speaker_names)
            speaker_name = speaker_names{j};
            codebook = speaker_codebooks.(speaker_name);
            dist = mean(min(pdist2(mfcc_test', codebook'), [], 2));

            if dist < min_distance
                min_distance = dist;
                predicted_speaker = speaker_name;
            end
        end

        % output prediction results
        fprintf('(Eleven)Test radio %s is predicted to be: %s\n', test_files(i).name, predicted_speaker);
    end
end


function [S, F, T, fs] = readSTFT(filename,N,applyNotchFilter)
    [signal, fs] = audioread(filename);
    signal = signal / max(abs(signal));
     if applyNotchFilter
        signal = applyNotch(signal, fs); % Notch
    end
    M = round(N / 3); % frame increment
    [S, F, T] = spectrogram(signal, N, N - M, N, fs, 'yaxis');
end

function filteredSignal = applyNotch(signal, fs)
    % Notch filter
    f0 = 50;
    Q = 35;

    wo = f0 / (fs / 2); % normalized freq
    bw = wo / Q;
    [b, a] = iirnotch(wo, bw);

    filteredSignal = filtfilt(b, a, signal);
end


function melFilterBank = melfb(numFilters, fftSize, fs)
    % compute mel filter bank
    fMin = 0;                
    fMax = fs / 2;           

    % calculate mel freq
    melMin = hz2mel(fMin);
    melMax = hz2mel(fMax);

    melPoints = linspace(melMin, melMax, numFilters + 2);

    % mel to hz
    hzPoints = mel2hz(melPoints);

    % FFT
    freqBins = linspace(0, fMax, fftSize / 2 + 1);

    % initialize mel filter bank
    melFilterBank = zeros(numFilters, length(freqBins));

    % triangle filter
    for i = 1:numFilters
        fLeft = hzPoints(i);
        fCenter = hzPoints(i + 1);
        fRight = hzPoints(i + 2);

        leftBin = find(freqBins >= fLeft, 1);
        centerBin = find(freqBins >= fCenter, 1);
        rightBin = find(freqBins >= fRight, 1);

        if isempty(leftBin) || isempty(centerBin) || isempty(rightBin)
            continue;
        end
        if leftBin == centerBin
            centerBin = min(centerBin + 1, length(freqBins));
        end
        if centerBin == rightBin
            rightBin = min(rightBin + 1, length(freqBins));
        end
        if leftBin >= centerBin || centerBin >= rightBin
            continue;
        end

        % compute triangle filter
        for j = leftBin:centerBin
            melFilterBank(i, j) = max(0, (freqBins(j) - fLeft) / (fCenter - fLeft));
        end
        for j = centerBin:rightBin
            melFilterBank(i, j) = max(0, (fRight - freqBins(j)) / (fRight - fCenter));
        end
    end
end

function mel = hz2mel(hz)
    mel = 2595 * log10(1 + hz / 700);
end

function hz = mel2hz(mel)
    hz = 700 * (10 .^ (mel / 2595) - 1);
end

function mfccs = compute_mfcc_from_spectrogram(S, fs, fftSize, numFilters, numCoeffs)
    % calculate MFCC
    P = abs(S).^2;
    melFilterBank = melfb(numFilters, fftSize, fs);
    melSpectrum = melFilterBank * P;
    logMelSpectrum = log(melSpectrum + eps);
    mfccs = dct(logMelSpectrum);
    mfccs = mfccs(2:numCoeffs, :); % remove c0
end

function codebook = LBG(mfccs, numCentroids, epsilon)
    % LBG
    codebook = mean(mfccs, 2);
    distortion_prev = Inf;
    
    while size(codebook, 2) < numCentroids
        perturbation = epsilon * randn(size(codebook)); 
        codebook = [codebook + perturbation, codebook - perturbation]; 
        [codebook, distortion] = kmeans_lbg(mfccs, codebook, epsilon);
        
        if abs(distortion_prev - distortion) < epsilon
            break;
        end
        distortion_prev = distortion;
    end
end

function [centroids, distortion] = kmeans_lbg(mfccs, initialCodebook, epsilon)
    numCentroids = size(initialCodebook, 2);
    centroids = initialCodebook;
    maxIter = 100;
    distortion_prev = Inf;

    for iter = 1:maxIter
        distances = pdist2(mfccs', centroids');
        [~, labels] = min(distances, [], 2);

        for i = 1:numCentroids
            centroids(:, i) = mean(mfccs(:, labels == i), 2);
        end
        
        distortion = mean(min(distances, [], 2));

        if abs(distortion_prev - distortion) < epsilon
            break;
        end
        distortion_prev = distortion;
    end
end


