import numpy as np
from matplotlib import pyplot as plt
import scipy.signal 

class chirp:
    def __init__(self, slope, bandwidth, f0):
        self.slope = slope
        self.bandwidth = bandwidth
        self.f0 = f0
        self.duration = self.bandwidth/self.slope

    def signal_t(self, t, t0):

        signal = scipy.signal.chirp(t, f0=0, f1=1500, t1=T)
        return signal

# class Radar:
#     def __init__(self, time_cof):
#         self.time_cof = time_cof
#         # add necassery tasks

#     def send_signal(self):
#         pass

#     def process_signal(self):


def plot_spectrogram(title, w, fs):

    ff, tt, Sxx = scipy.signal.spectrogram(w, fs=fs, nperseg=256, nfft=576)
    plt.pcolormesh(tt, ff[:145], Sxx[:145], cmap='gray_r', shading='gouraud')
    plt.title(title)
    plt.xlabel('t (sec)')
    plt.ylabel('Frequency (Hz)')
    plt.grid()
    # def signal_fft()


if __name__ == "__main__":

    fs = 500
    T = 1
    t = np.arange(0, int(T*fs)) / fs 
    w = scipy.signal.chirp(t,f0=0,f1= 5*fs, t1=T)

    
    plot_spectrogram(f'Quadratic Chirp, f(0)=1500, f({T})=250', w, fs)
    plt.plot(t,w)
    plt.show()

    # In the below functions we are will return the time intervals that the frames collide

class FrameConfig:

    def __init__(self, ):
            # chirpStartIdx, chipEndIdx, numLoops, numFrames, framePeriodicity, triggerSelect, frameTriggerDelay
        pass

class ChirpConfig:

    def __init__(self, ):
        # id, f0, idleTime, adcStartTime, rampEndTime, txOutPower, txPhaseShifter, freqSlopeConst, txStartTime, numAdcSamples, digOutSampleRate, hpfCornerFreq1, hpfCornerFreq2, rxGain
        pass



# example chirp

# Bens recomended chirp frame chirp1 = ChirpConfig(0,77,2,0,50,0,0,0,0,10000,0,0,0,30) 
