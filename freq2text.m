function [ascii, IF, Bw] = freq2text(frame, text)
    
    
%     find most appropriate IF and bandwidth
    IF0 = 3e6;
    bandwidth0 = 4e6;
    x0 = [IF0,bandwidth0];
    x = fminsearch(@(x0) (sum((frame-text2freq(text,x0(2),x0(1))).^2)),x0);
    
    IF = x(1);
    bandwidth = x(2);
    
%     match recieved frequencies with the best text
    ascii = round(255*(frame-IF)/bandwidth);
    
    Bw = bandwidth;
    
end

