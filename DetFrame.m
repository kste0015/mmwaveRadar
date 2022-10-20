function [chirp_values, T] = DetFrame(RecievedFrame, min_chirp_length, max_chirp_length)
    
    min_chirp_length = int32(min_chirp_length);
    max_chirp_length = int32(max_chirp_length);
    chirp_population = int32(length(RecievedFrame)-min_chirp_length+1);
    
    chirp_val = zeros(chirp_population,2);
    
    
    for chirp_no = 1:chirp_population
        current_chirp = RecievedFrame(chirp_no:chirp_no+min_chirp_length-1);
        
        chirp_val(chirp_no,:) = [mean(current_chirp),std(current_chirp)];
        
    end
    
    best_samples = islocalmin(chirp_val(:,2),'MinSeparation',min_chirp_length);
    
    possible_chirps = sum(best_samples);
    
    chirp_values = zeros(1,possible_chirps);
    chirp_no = 1;
    
    T = zeros(possible_chirps,1);
    
    for i = 1:chirp_population
        if best_samples(i)
            chirp_values(chirp_no) = chirp_val(i,1);
            T(chirp_no) = i;
            chirp_no = chirp_no + 1;
        end
    end
end

