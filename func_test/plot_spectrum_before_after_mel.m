function plot_spectrum_before_after_mel(filename, N, numFilters)
    % Read the audio file and compute STFT
    [S, F, T, fs] = readSTFT(filename, N); % No Notch filtering applied
    powerSpectrum = abs(S).^2; % Compute power spectrum

    % Compute Mel filter bank
    melFilterBank = melfb(numFilters, N, fs);

    % Apply Mel filter bank to convert the power spectrum into the Mel frequency domain
    melSpectrum = melFilterBank * powerSpectrum;

    % Plot the original power spectrum
    figure;
    subplot(2,1,1);
    imagesc(T, F, 10*log10(powerSpectrum)); 
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Power Spectrum Before Mel Wrapping');
    colorbar;

    % Plot the Mel spectrum
    subplot(2,1,2);
    imagesc(T, 1:numFilters, 10*log10(melSpectrum)); 
    axis xy;
    xlabel('Time (s)');
    ylabel('Mel Filter Index');
    title('Power Spectrum After Mel Wrapping');
    colorbar;
end
