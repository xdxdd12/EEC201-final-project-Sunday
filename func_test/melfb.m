function melFilterBank = melfb(numFilters, fftSize, fs)
    % Generate Mel filter bank
    %
    % input:
    % numFilters: number of filter
    % fftSize: number of FFT
    % fs: sampling rate (Hz)
    %
    % output:
    % melFilterBank: Frequency response (numFilters x (fftSize/2+1))

    % 1. frequency range set
    fMin = 0;                % min (Hz)
    fMax = fs / 2;           % max（Hz）

    % 2. Calculate mel Frequency
    melMin = hz2mel(fMin);
    melMax = hz2mel(fMax);

    % 3. Mel mid frequency
    melPoints = linspace(melMin, melMax, numFilters + 2);

    % 4. back to hz
    hzPoints = mel2hz(melPoints);

    % 5. FFT frequency axis
    freqBins = linspace(0, fMax, fftSize / 2 + 1);

    % 6. initialize
    melFilterBank = zeros(numFilters, length(freqBins));

    % 7. Triangle filter
    for i = 1:numFilters
        % Filter frequency boundary
        fLeft = hzPoints(i);
        fCenter = hzPoints(i + 1);
        fRight = hzPoints(i + 2);
        leftBin = find(freqBins >= fLeft, 1);
        centerBin = find(freqBins >= fCenter, 1);
        rightBin = find(freqBins >= fRight, 1);

        % make sure index is legal
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

        % Calculate triangle filter & make sure no negative value
        for j = leftBin:centerBin
            melFilterBank(i, j) = max(0, (freqBins(j) - fLeft) / (fCenter - fLeft));
        end
        for j = centerBin:rightBin
            melFilterBank(i, j) = max(0, (fRight - freqBins(j)) / (fRight - fCenter));
        end
    end
end

% frequency convert function
function mel = hz2mel(hz)
    mel = 2595 * log10(1 + hz / 700);
end

function hz = mel2hz(mel)
    hz = 700 * (10 .^ (mel / 2595) - 1);
end

