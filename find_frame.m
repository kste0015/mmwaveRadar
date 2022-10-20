function frame_data = find_frame(raw_data,frame_size,threshold)
    
    mu = mean(raw_data);
    MMSE = movmean((raw_data-mu).^2,3);
    
    
    frame_start = -1;
    i = 1;
    while frame_start<0
        if MMSE(i) > threshold
            frame_start = i;
        end
        i = i+1;
    end  
    
    frame_data = raw_data(frame_start:frame_start+frame_size-1);
    
end

