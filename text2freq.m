function frame_frequencies = text2freq(text,bandwidth,IF)
    
    frame_frequencies = double(text)*(bandwidth/255)+IF;
end

