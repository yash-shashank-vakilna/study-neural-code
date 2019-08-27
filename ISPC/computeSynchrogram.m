function [synchrogram,lags] = computeSynchrogram(x1, x2, timeScale, maxLag, fs)
%Computes ISPC vs lag between x1 and x2
%maxLag,timeScale in ms

%converting to sf-units
maxLag = maxLag*fs/1e3;
timeScale = round(timeScale*fs/1e3);
synchrogram = zeros(1, length(-maxLag:timeScale:maxLag));
lags = synchrogram; i=1;
for lagi=-maxLag:timeScale:maxLag
    if lagi >0
        %introduce the lag in x2 by removing starting values of x1
        x1Lagged = x1(lagi+1:end);
        %remove end values of x2
        x2Lagged = x2(1:end-lagi);
        
    else
        %introduce the lag in x2 by removing starting values of x1
        x2Lagged = x2(abs(lagi)+1:end);
        %remove end values of x2
        x1Lagged = x1(1:end-abs(lagi));
    end
    %compute ISPC and average 
    ISPCtime = compute_ISPC(x1Lagged, x2Lagged, 1,fs, 1, 0.2);
    %store
    synchrogram(i) = mean(ISPCtime);
    lags(i) = lagi/fs*1e3;
    disp("Computed for lag: " + lags(i)+" ms") 
    i=i+1;
end


end

