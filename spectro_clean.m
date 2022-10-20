function means = spectro_clean(spectrogram_image, frequencies)

    shape = size(spectrogram_image);   
    
    means = zeros(1,shape(2));        
    
    for col = 1:shape(2)
        
        time_sample = spectrogram_image(:,col);
        weights = time_sample ./ sum(time_sample);
        
        means(col) = sum(weights.*frequencies);
        
    end
end

