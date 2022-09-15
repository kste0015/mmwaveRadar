from numpy import fft
import numpy as np
from matplotlib import pyplot as plt
from scipy import signal as sig
from BasicSystem import RecievedChirp

class DataFrame:
    def __init__(self,flo,bandwidth, Fs, N):
        self.flo = flo
        self.bandwidth = bandwidth
        self.offset_increments = self.bandwidth/256
        self.Fs = Fs
        self.N = N

        self.chirp_duration = self.N/self.Fs

        self.n = np.arange(self.N)

    def get_data_frame(self, data_string, chirp_offset):
        frequencies = self.string_to_frequency(data_string)
        data_frame = [ self.generate_chirp(frequencies[i]) for i in range(len(frequencies))]

        self.dataframe = data_frame
        return self.dataframe

    def generate_chirp(self,f0):
        return RecievedChirp(f0,self.flo,0,0,self.Fs,self.chirp_duration)

    def string_to_frequency(self,string):
        return [(ord(string[i])+1)*self.offset_increments + self.flo for i in range(len(string))]


    def get_fft(self):
        ffts = [fft.fft(self.dataframe[i]) for i in range(len(self.dataframe))]

        self.fft = ffts
        return ffts

if __name__ == "__main__": 

    # This commented section is purely a proof of concept that the RecievedChirp function works
    # The below example was successfull.
    # f0 = 205e6
    # f_lo = 200e6
    # theta = (45/2)
    # f0_bandwidth = 100e6
    # final_sample_rate = 10e6

    # diff = np.abs(f0-f_lo)
    # duration = 10000/diff

    # t, signal = RecievedChirp(f0,f_lo,theta,f0_bandwidth,final_sample_rate,duration)

    # encoding the data frame
    data_string = 'Hello World'
    frame = DataFrame(200e6,5e6,10e6,512)
    frame.get_data_frame(data_string, 0)



    # decoding the data frame

    # finding the locations of the peaks in Hz
    frame.get_fft()
    frame_peaks = []
    for i in range(len(data_string)):
        peaks = sig.find_peaks(frame.fft[i].real**2 + frame.fft[i].imag**2,threshold=1)[0]
        frame_peaks.append(float(peaks)*float(frame.Fs)/float(frame.N))
    
    # converting the frequencies to ascii values
    output_string = ''
    for peak in frame_peaks:
        ascii_value = round((peak) / frame.offset_increments) - 1
        output_string += chr(round(ascii_value))
    print(output_string)















