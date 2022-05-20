import numpy as np
from matplotlib import pyplot as plt

class chirp:
    def __init__(self, slope, bandwidth, f0):
        self.slope = slope
        self.bandwidth = bandwidth
        self.f0 = f0
        self.duration = self.bandwidth/slope

    def _signal_value(self, t):
        return np.cos(self.slope*np.square(t)+self.f0*t)


    def signal_t(self, t, t0):
        t_shifted = t-t0
        signal = np.zeros_like(t)
        nonzero = (t_shifted>0)&(t_shifted<self.duration)
        signal[nonzero] = self._signal_value(t[nonzero])

        return signal

if __name__ == "__main__":
    thing = chirp(slope = 1, bandwidth=10, f0=10)
    t = np.linspace(0,20,2000)
    t0 = 5
    plt.plot(t,thing.signal_t(t,t0))
    plt.show()
    