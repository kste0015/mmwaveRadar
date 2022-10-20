clear all; close all; clc;

load("frame_extractor.mat")

min_frame = 16;
max_frame = 22;


x = data(1,:);

frame = FrameFilt(x,Fs);

[received_frame, T] = DetFrame(frame,min_frame,max_frame);

figure 
spectrogram(data(2,:),kaiser(256,5),220,512,Fs,'yaxis');

figure
subplot(2,1,1)
%     spectrogram(x,kaiser(256,5),220,512,Fs,'yaxis');
spectrogram(x,64,32,100,Fs,"yaxis");

k = 1:length(frame);
subplot(2,1,2)
plot(k,frame)
xlabel('Valid Time samples')
ylabel('Frequency')
hold on
for j = 1:length(T)
    start = T(j);
    ki = start:start+min_frame;
    plot(ki,ki.*0+received_frame(j),'r-','LineWidth',2)
end
hold off


