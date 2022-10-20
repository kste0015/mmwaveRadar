clear all; close all; clc;

%% This script is used to read the binary file produced by the DCA1000

files = ["test_data/adc_data_1MHz.bin", "test_data/adc_data_2MHz.bin", ...
    "test_data/adc_data_3MHz.bin", "test_data/adc_data_4MHz.bin", ...
    "test_data/adc_data_5MHz.bin", "test_data/adc_data_Increment.bin"];

frame_size = 50000;
tests = length(files);

data = zeros(tests,frame_size);
for i = 1:tests
    
    raw_data = readDCA1000(files(i));
    data(i,:) = find_frame(raw_data(1,:)/max(abs(raw_data(1,:))),frame_size, 0.0125);

end

% csvwrite('adc_data_real(1).csv', data);

save("test_data")

%% Thing 

% clear all; close all; clc
close all
load("test_data.mat")
Fs = 10e6;
chirp_size = 512;

t = linspace(0,frame_size/Fs,frame_size);

file_no = 6;

min_chirp_length = 0.025e-3;
max_chirp_length = 0.085e-3;

subfigs = 5;

for i = 1:6
    
    x = data(i,:);
    
    k = hampel(extract_chirps(x,0.02),3,2);
    
    filtered = highpass(k, 3e6,10e6);
    
    figure 
    subplot(subfigs,1,1)
    plot(t(1:length(k)),k)
    title("time domain")
    
    subplot(subfigs,1,2)
    spectrogram(k,64,32,100,Fs,"yaxis");
    title("First Noise Removal");
    
    subplot(subfigs,1,3)
    spectrogram(x,64,32,100,Fs,"yaxis");
    title("Original Signal")
    
    
    [S,F,T] = spectrogram(filtered,64,32,100,Fs);
    
    P = abs(S.^2);
    P = P./max(P);

    P(P<0.5) = 0;
    
    kernal = [0.5, 0, 0.5;...
              1, -1, 1;...
              0.5, 0, 0.5];
    
    
    Fil = conv2(P,kernal,'same');
    Fil(Fil<0) = 0;
    Fil = Fil .* P;
    subplot(subfigs,1,4)
    imshow(Fil)
    
    mu = hampel(spectro_clean(Fil,F),5,1);
    subplot(subfigs,1,5)
    plot(1:length(mu),mu)
    
    R = DetFrame(mu,16,22)
    
    
end