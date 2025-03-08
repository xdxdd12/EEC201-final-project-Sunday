function mfccs = compute_mfcc_from_spectrogram(S, fs, fftSize, numFilters, numCoeffs)
    % calculate MFCC
    % in:
    %   S         - STFT result
    %   fs        - sampling rate
    %   fftSize   - FFT number
    %   numFilters- Mel filter number
    %   numCoeffs - MFCC coefficient number
    %
    % out:
    %   mfccs - MFCC (numCoeffs x numFrames)

    % P(f)
    P = abs(S).^2;

    % melfb
    melFilterBank = melfb(numFilters, fftSize, fs);

    % use melfb
    melSpectrum = melFilterBank * P;

    % log
    logMelSpectrum = log(melSpectrum + eps); 

    % DCT
    mfccs = dct(logMelSpectrum);
    mfccs = mfccs(2:numCoeffs, :); % remove c0

end
