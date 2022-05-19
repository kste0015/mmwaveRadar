import numpy as np
from matplotlib import pyplot as plt
import math

class chirp:
    def __init__(self, slope, bandwidth, f0):
        self.slope = slope
        self.bandwidth = bandwidth
        self.f0 = f0
        self.duration = self.bandwidth/slope

    def _signal_value(self, t):
        return math.cos(self.slope*np.square(t)+self.f0*t)


    def signal_t(self, t, t0):
        t_shifted = t-t0
        signal = np.zeros_like(t)
        signal[(t_shifted>0&t_shifted<self.duration)] = self._signal_value(t[(t_shifted>0&t_shifted<self.duration)])

        return signal

if __name__ == "__main__":
    thing = chirp(slope = 1, bandwidth=10, f0=10)

