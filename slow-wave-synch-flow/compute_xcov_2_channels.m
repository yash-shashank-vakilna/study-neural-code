function [corr_val, lag_for_max_corr, ts] = compute_xcov_2_channels(x_1,x_2, time_scale,fs, overlap, if_zscore, maxlag)
%Computes cross-covariance over time after dividing the signal in pieces
%Mike x cohen book

%divide both into pieces
%time_scale = 1; %s
%if_window flag for using hamming window 
if isempty(x_1) || isempty(x_2)
    corr_val = [];
    lag_for_max_corr = [];
    ts = [];
    return
end

if if_zscore
    x_1 = zscore(x_1);
    x_2 = zscore(x_2);
end

if ~exist('overlap','var')
        overlap=0.2;
         disp 'computing xcov for overlap = 0.2'
end
slide=1-overlap;
n_scale = round(time_scale*fs*slide);

corr_val = zeros(1,length(1:n_scale:length(x_1)-n_scale));
lag_for_max_corr = corr_val;
c_i=1;
% loop over pieces
for ps=1:n_scale:length(x_1)-n_scale
    px_1 = x_1(ps:ps+n_scale-1);    
    px_2 = x_2(ps:ps+n_scale-1);
    %compute cross-covariance 
    [p, lags] = xcorr(px_1, px_2, maxlag);
    maxcorr_ind = find(p == abs(max(p)));
    maxcorr_ind = maxcorr_ind(end);
    %concatenate
    corr_val(c_i) = p(maxcorr_ind);
    lag_for_max_corr(c_i) = lags(maxcorr_ind);
    c_i = c_i+1;
end
%time-series for easy plotting
ts = ((1:n_scale:length(x_1)-n_scale) + n_scale/2)./fs;
lag_for_max_corr = lag_for_max_corr ./ fs;
end

