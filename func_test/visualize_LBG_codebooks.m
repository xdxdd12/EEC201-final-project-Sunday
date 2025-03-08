function visualize_LBG_codebooks(codebook_list, speaker_names)
    figure;
    hold on;
    colors = lines(length(speaker_names)); 
    
    for i = 1:2
        codebook = codebook_list{i};
        scatter(codebook(4,:), codebook(5,:), 50, colors(i,:), 'filled');
    end

    xlabel('MFCC Coefficient 1');
    ylabel('MFCC Coefficient 2');
    title('LBG Codebook Distribution');
    legend(speaker_names);
    grid on;
    hold off;
end
