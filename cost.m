%% cost function for the current guess of the expected IF
function distance = cost(expected_peaks, IF, observed_peaks, Fs,offset)
    no_peaks = length(observed_peaks);
%  find distance of nearest peak and sum the costs
    distance = 0;
    
    offset_peaks = zeros(size(expected_peaks));
    for peak = 1:no_peaks
        
        % this for loop adjusts the IF and allows for wrap around
        for i = 1:length(expected_peaks)
            observed_freq = expected_peaks(i) + IF;
            if observed_freq > Fs/2
                offset_peaks(i) = offset - observed_freq;
            end
        end
        distance = distance + peak_cost(observed_peaks(peak), offset_peaks);
    end
    
end

