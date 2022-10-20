%%

clear all; close all; clc

load("frame_extractor.mat")

t = 0:frame_size/Fs:1/Fs;

min_frame = 16;
max_frame = 22;

for i = 1:tests
    
    x = data(i,:);
    
    filtered = highpass(x,3e6,Fs);
    
    [S,F,T] = spectrogram(filtered,kaiser(256,5),220,512,Fs,'yaxis');
            
    kernal = [0.5, 0, 0.5;...
              1, -1, 1;...
              0.5, 0, 0.5];
    
    P = S .* conj(S);
    P(P<3) = 0;
    P = imgaussfilt(P,2).*P;
    P(P<3) = 0;
    
          
          
    figure
    subplot(2,1,1)
    spectrogram(x,kaiser(256,5),220,512,Fs,'yaxis');
    subplot(2,1,2)
    imshow(flip(P))
end