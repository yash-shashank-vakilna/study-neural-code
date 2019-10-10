function [corr_val, lag_for_max_corr, lags] = compute_xcov_2_channels_peaks(x_1, x_2, p_1, p_2, time_scale, fs, if_zscore)
%Computes cross-covariance over time after dividing the signal in pieces
%based on peaks in [p_1, p_2]

%divide both into pieces
%time_scale = 1; %s

%% merging peaks and extracting filtered segments
p_1 = find(p_1);
p_2 = find(p_2);

time_scale = time_scale*fs/1e3;
maxlag = round(time_scale/2);

start_stop_matrix = [];
for p_n = p_1'
    p_2_start = p_n - time_scale; p_2_stop = p_n + time_scale;
    if p_2_start < 1, p_2_start = 1; end
    if p_2_stop > 300*fs, p_2_stop = 300*fs; end
    matched_peaks = find( p_2 > p_2_start & p_2 < p_2_stop);
    if ~isempty(matched_peaks)
        start_stop_matrix = [start_stop_matrix; [p_2_start, p_2_stop]];
    end
end

if isempty(start_stop_matrix)
    corr_val = [];
    lag_for_max_corr = [];
    lags = [];
    return
end

if if_zscore
    x_1 = zscore(x_1);
    x_2 = zscore(x_2);
end

%% Compute cross-correlation 
corr_val = zeros(1,length(start_stop_matrix));
lag_for_max_corr = corr_val;
c_i=1;
% loop over pieces
for psi=1:size(start_stop_matrix,1)
    px_1 = x_1(start_stop_matrix(psi,1):start_stop_matrix(psi,2));    
    px_2 = x_2(start_stop_matrix(psi,1):start_stop_matrix(psi,2));
    %compute cross-covariance 
    [p, lags] = xcorr(px_1, px_2, maxlag);
    maxcorr_ind = find(p == (max(p)));
%     maxcorr_ind = maxcorr_ind(end);
%     figure(2); 
%     plot(-lags./(fs/1e3), p)
%     xlabel("<- FB                  Lags(ms)                  FF ->"), ylabel 'Cross-correlation'
    %concatenate
    corr_val(c_i) = p(maxcorr_ind);
    lag_for_max_corr(c_i) = lags(maxcorr_ind);
    c_i = c_i+1;
end
%time-series for easy plotting
lag_for_max_corr = lag_for_max_corr./(fs/1e3);
lags = lags./(fs/1e3);
end

