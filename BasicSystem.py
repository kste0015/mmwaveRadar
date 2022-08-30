# here we simply generate a signal and convert it to a complex discrete signal
import numpy as np
from matplotlib import pyplot as plt
from scipy import signal as sig

def signal(t,f, phi, A):
    """
    This function represents a continuous time version of the sampled signal we will obtain.
    """
    return A*np.cos(2*np.pi*f*t + phi)


def filter(sample_freq, cut_off, signal):
    wn = 2*np.pi*cut_off
    b,a = sig.butter(10,wn,fs=sample_freq)
    y = sig.filtfilt(b,a,signal)
    return y

if __name__ == '__main__':
    
    f0 = 205e6
    f_lo = 200e6
    theta = (45/2)
    f0_bandwidth = 100e6


    final_sample_rate = 10e6
    n = int(1 + (2*(f0+f_lo+f0_bandwidth))//final_sample_rate)
    sample_rate = n*final_sample_rate

    diff = np.abs(f0-f_lo)
    duration = 10000/diff
    cut_off = 50e6
 

    T = 1/sample_rate
    t = np.arange(0,duration,T)
    sig1 = sig.chirp(t,f0,t[-1],f0+f0_bandwidth)
    sig2 = sig.chirp(t,f_lo,t[-1],f_lo,phi=theta)
    sig2_q = sig.chirp(t,f_lo,t[-1],f_lo,phi=theta+90)

    i = sig1*sig2
    q = sig1*sig2_q

    i_filt = filter(sample_rate,cut_off,i)
    q_filt = filter(sample_rate,cut_off,q)

    t_output = t[::n]
    output_signal = i_filt[::n] + q_filt[::n] * 1j

    fig, axs = plt.subplots(4,1,figsize=(10,6))

    axs[0].set_title('Original signals')
    axs[0].plot(t,sig1,t,sig2)
    axs[1].set_title('Mixed signals')
    axs[1].plot(t,i)
    axs[2].set_title('Inphase filtered signal')
    axs[2].plot(t,i_filt)
    axs[3].set_title('Quadrature filtered signal')
    axs[3].plot(t,q_filt)
    plt.subplots_adjust(hspace=0.6)

    plt.figure()
    f,t,sxx = sig.spectrogram(i,sample_rate)
    plt.pcolormesh(t,f,sxx,shading='gouraud')

    plt.figure()
    plt.plot(t_output, output_signal.real, t_output,output_signal.imag)

    plt.figure()
    f,t,sxx = sig.spectrogram(i_filt[::n],final_sample_rate)
    plt.pcolormesh(t,f,sxx,shading='gouraud')

    plt.show()