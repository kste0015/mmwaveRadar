function refined_frame = extract_chirps(frame,buff)
    
%     Removing noise 
    mu = mean(frame);
    
    average_RMS = mean(sqrt((frame-mu).^2));
    moving_rms = movmean(sqrt((frame-mu).^2),3);
    
    refined_frame = frame((moving_rms<(average_RMS+buff))&(moving_rms>4e-3));
    
end

