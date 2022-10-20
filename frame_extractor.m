clear all; close all; clc;

%% This script is used to read the binary file produced by the DCA1000

% files = ["test_data/adc_data_1MHz.bin", "test_data/adc_data_2MHz.bin", ...
%     "test_data/adc_data_3MHz.bin", "test_data/adc_data_4MHz.bin", ...
%     "test_data/adc_data_5MHz.bin", "test_data/adc_data_Increment.bin"];

files = ["adc_data(1).bin"];

% files = ["adc_data(2).bin"];

% files = ["test_data/adc_data_Increment.bin"];

frame_size = 11240;
tests = length(files);

Fs = 10e6;
chirp_size = 512;

data = zeros(tests,frame_size);
for i = 1:tests
    
    raw_data = readDCA1000(files(i));
    data(i,:) = find_frame(raw_data(1,:)/max(abs(raw_data(1,:))),frame_size, 0.0125);

end

save("frame_extractor")

%%
clear all; close all; clc

load("frame_extractor.mat")

min_frame = 16;
max_frame = 22;

for i = 1:tests
    
    x = data(i,:);
    
    frame = FrameFilt(x,Fs);
    
    [received_frame, T] = DetFrame(frame,min_frame,max_frame);
    
    figure 
    subplot(2,1,1)
    spectrogram(x,kaiser(256,5),220,512,Fs,'yaxis');
%     spectrogram(x,64,32,100,Fs,"yaxis");
    title("Recieved Chirp Spectrogram")
    

    text = 'Hello World';
    [ascii,IF,Bandwidth] = freq2text(received_frame, text);

    expected_frequencies = ascii*Bandwidth/255+IF;
    
    actual_frequencies = text2freq(text,Bandwidth, IF);
    
    k = 1:length(frame);
    subplot(2,1,2)
    plot(k,frame)
    title('Measured Chirp')
    xlabel('Sample')
    ylabel('Frequency')
    
    hold on
    for j = 1:length(T)
        start = T(j);
        ki = start:start+min_frame;
        plot(ki,ki.*0+received_frame(j),'r-','linewidth',1)
        plot(ki,ki.*0+expected_frequencies(j),'b-','linewidth',1)
        plot(ki,ki.*0+actual_frequencies(j),'g-','linewidth',1)

        
    end
    hold off
    
    figure
    spectrogram(x,kaiser(256,5),220,512,Fs,'yaxis');
    title("Experimental Spectrogram")
end



error = received_frame - text2freq(text,Bandwidth, IF);

char(ascii)
figure
histogram(error)
title("Histogram of (Predicted - Observed) frequency")
