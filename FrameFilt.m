function filtered_frame = FrameFilt(frame,Fs)
    
    k = hampel(extract_chirps(frame,0.02),3,2);
    
    filtered = highpass(k, 3e6,10e6);
    
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
    
    filtered_frame = hampel(spectro_clean(Fil,F),5,1);

    
end

