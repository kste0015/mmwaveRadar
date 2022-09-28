# here we simply generate a signal and convert it to a complex discrete signal
import numpy as np
from matplotlib import pyplot as plt
from scipy import signal as sig


def filter(sample_freq, cut_off, signal):
    wn = 2*np.pi*cut_off
    b,a = sig.butter(10,wn,fs=sample_freq)
    y = sig.filtfilt(b,a,signal)
    return y



def IdealRecievedChirp(f0,flo,theta,f0_bandwidth,sample_rate,duration,noise=0.0,cut_off=50e6):

    n = int(1 + (2*(f0+flo+f0_bandwidth))//sample_rate)
    inter_sample_rate = n*sample_rate

    # generating data
    T = 1/inter_sample_rate
    t = np.arange(0,duration,T)
    sig1 = sig.chirp(t,f0,t[-1],f0+f0_bandwidth)
    sig2 = sig.chirp(t,flo,t[-1],flo,phi=theta)
    sig2_q = sig.chirp(t,flo,t[-1],flo,phi=theta+90)

    i = sig1*sig2
    q = sig1*sig2_q

    i_filt = filter(inter_sample_rate,cut_off,i)
    q_filt = filter(inter_sample_rate,cut_off,q)

    # down sampling the high sample rate data to generate realistic sample rates
    output_signal = i_filt[::n] + q_filt[::n] * 1j

    return output_signal
    

if __name__ == '__main__':
    
    # declaring variables
    f0 = 205e6
    f_lo = 200e6
    theta = (45/2)
    f0_bandwidth = 100e6

    plot_start_indx = 100
    plot_duration = 400

    final_sample_rate = 10e6
    n = int(1 + (2*(f0+f_lo+f0_bandwidth))//final_sample_rate)
    sample_rate = n*final_sample_rate

    diff = np.abs(f0-f_lo)
    duration = 10000/diff
    cut_off = 50e6
 
    # generating data
    T = 1/sample_rate
    t = np.arange(0,duration,T)
    sig1 = sig.chirp(t,f0,t[-1],f0+f0_bandwidth)
    sig2 = sig.chirp(t,f_lo,t[-1],f_lo,phi=theta)
    sig2_q = sig.chirp(t,f_lo,t[-1],f_lo,phi=theta+90)

    i = sig1*sig2
    q = sig1*sig2_q

    i_filt = filter(sample_rate,cut_off,i)
    q_filt = filter(sample_rate,cut_off,q)

    # down sampling the high sample rate data to generate realistic sample rates
    t_output = t[::n]
    output_signal = i_filt[::n] + q_filt[::n] * 1j

    fig, axs = plt.subplots(4,1,figsize=(10,6))

    plot_range = range(plot_start_indx, plot_duration+plot_start_indx)

    # high sample rate plots 
    axs[0].set_title('Original signals')
    axs[0].plot(t[plot_range],sig1[plot_range],t[plot_range],sig2[plot_range])
    axs[1].set_title('Mixed signals')
    axs[1].plot(t[plot_range],i[plot_range])
    axs[2].set_title('Inphase filtered signal')
    axs[2].plot(t[plot_range],i_filt[plot_range])
    axs[3].set_title('Quadrature filtered signal')
    axs[3].plot(t[plot_range],q_filt[plot_range])
    plt.subplots_adjust(hspace=0.6)

    plt.figure()
    f,t,sxx = sig.spectrogram(i,sample_rate)
    plt.pcolormesh(t,f,sxx,shading='gouraud')


    # reduced sample rate plots
    output_plot_range = range(plot_start_indx//n,(plot_duration+plot_start_indx)//n)

    plt.figure()
    plt.plot(t_output[output_plot_range], output_signal.real[output_plot_range], t_output[output_plot_range] ,output_signal.imag[output_plot_range])

    plt.figure()
    f,t,sxx = sig.spectrogram(i_filt[::n],final_sample_rate)
    plt.pcolormesh(t,f,sxx,shading='gouraud')

    plt.show()