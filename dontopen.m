clear all; close all; clc;

F0 = 100; %Hz

phase_offset = 20; %Hz

Fs = 40e3;
t = 0:1/Fs:10;

fan = chirp(t,F0,10,F0);
Ben = chirp(t,F0-phase_offset,10,F0+phase_offset);

your_ears = fan+Ben;

plot(t,your_ears)

sound(your_ears,Fs)