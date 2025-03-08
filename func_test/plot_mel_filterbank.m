function plot_mel_filterbank(N, numFilters, fs)
    % Compute Mel filter bank
    melFilterBank = melfb(numFilters, N, fs);
    
    % Compute FFT frequency axis
    freqAxis = linspace(0, fs/2, N/2 + 1); % Corresponds to the frequency distribution in `melfb()`

    % Plot the Mel filter bank
    figure;
    plot(freqAxis, melFilterBank');
    xlabel('Frequency (Hz)');
    ylabel('Filter Amplitude');
    title(sprintf('Mel Filter Bank (%d Filters, FFT Size = %d)', numFilters, N));
    grid on;
end
