function chirps = breakdownframe(framedata, maxthreshold,minthreshold,lowerbuffer,upperbuffer,frame_size)
    Moving_RMS = sqrt(movmean(framedata.^2,5));
    chirp_indecies = zeros(size(framedata));
    
%     include only information from correctly powered signals
    inband = 0;
    for i = 1:length(framedata)
        if (Moving_RMS(i) > minthreshold) && (Moving_RMS(i) < maxthreshold) 
            chirp_indecies(i) = 1;
            inband = 1;
        elseif inband && (Moving_RMS(i) > (minthreshold-lowerbuffer) && Moving_RMS(i) < (maxthreshold+upperbuffer))
            chirp_indecies(i) = 1;
        else
            inband = 0;
        end
    end
    
%     filter out the tail data
    current_consecutive = 0;
    
    data_frame = zeros(20,frame_size);
    chirp = 0;
    for i = 1:length(framedata)
        if chirp_indecies(i)
            current_consecutive = current_consecutive + 1;
        else
            current_consecutive = 0;
        end
        
        if current_consecutive == frame_size
            chirp = chirp + 1;
            current_consecutive = 0;
            
            data_frame(chirp,:) = framedata(i-frame_size+1:i);
        end
            
    end
    chirps = data_frame(1:chirp,:);
    
end


