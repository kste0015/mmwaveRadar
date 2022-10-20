clear all; close all; clc;

%% This script is used to read the binary file produced by the DCA1000
%%% and Mmwave Studio
%%% Command to run in Matlab GUI -
% data = readDCA1000('adc_data.bin');
% 
% csvwrite('adc_data_real.csv', data);

data = readDCA1000('adc_data(1).bin');

% csvwrite("test_data/adc_data_1MHz.bin", data);



%% Thing 
x = data(1,:);

min_index = -1;
max_index = -1;
threshold = 200;
shape = size(x);
len = shape(2);
Fs = 10e6;

t = linspace(0,1,len);

for i = 1:len
    if abs(x(i)) > threshold
        if min_index < 0
            min_index = i;
        end
        max_index = i;
    end
end

t_valid = t(min_index:max_index);
n_valid = 1:length(t_valid);
x_valid = x(min_index:max_index);

L = 512;
index = 0;
start = index*L+400;
X = x_valid(start:start+L);

Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

figure
plot(t,x)
title("Raw DCA1000 Data Frame")

figure 
plot(n_valid(start:start+L),x_valid(start:start+L))

Moving_RMS = sqrt(movmean(x_valid.^2, 50));

figure 
plot(t_valid,x_valid,t_valid,Moving_RMS)

figure
spectrogram(x_valid,'yaxis');


%% extracting data

expected_frequencies = [5.4e6, 7.575e6, 8.1e6, 8.325e6, 2.4e6, 6.525e6, 8.55e6, 7.5e6, 2.475e6];
expected_frequencies = expected_frequencies/2;
associated_character = ['H', 'e', 'l', 'o', ' ', 'W', 'r', 'd', '!'];

chirp_size = 512;
chirps = breakdownframe(x_valid, 10000, 100, 50, 50,chirp_size);

L = chirp_size;
X = chirps;
Y = fft(X,L,2);
f = Fs*(0:(L/2))/L;

P2 = abs(Y/L);
P1 = P2(:,1:L/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);

frequencies = P1(:,1:L/2);

[M, I] = max(frequencies,[],2);
peak_frequencies = f(I);

figure
for i=1:6
    subplot(3,2,i)
    plot(0:(Fs/L):(Fs/2-Fs/L),P1(i,1:L/2))
    title("Row " + num2str(i) + " in the Frequency Domain")
    xline(peak_frequencies(i),'r')
    for j = 1:length(expected_frequencies)
        xline(expected_frequencies(j))
    end
end

figure
for i=1:6
    subplot(3,2,i)
    plot(0:L-1,chirps(i,:))
    title("Row " + num2str(i) + " in the Frequency Domain")
end
%% optimising the expected recieved chirps for the actually recieved chirps
x0=[1e6, 10e6];
IF = fminsearch(@(x) cost(expected_frequencies, x(1), peak_frequencies,Fs,x(2)), x0);

expected_frequencies = expected_frequencies + IF(1);
for i = 1:length(expected_frequencies)
    observed_freq = expected_frequencies(i);
    if observed_freq > Fs/2
        expected_frequencies(i) = IF(2) - observed_freq;
    end
end

%% plotting new expectation
figure
for i=1:9
    subplot(3,3,i)
    plot(0:(Fs/L):(Fs/2-Fs/L),P1(i,1:L/2))
    title("Row " + num2str(i) + " in the Frequency Domain")
    xline(peak_frequencies(i),'r')
    for j = 1:length(expected_frequencies)
        xline(expected_frequencies(j))
    end
end
%% End of visualisation. Next we will actually extract the data

string = '';
for i = 1:length(peak_frequencies)
    [val, char_index] = min((peak_frequencies(i) - expected_frequencies).^2);
    string = append(string,associated_character(char_index));
end

string




