function [corr_val, maxlag_val, ts] = compute_xcov_2_channels(x_1,x_2, time_scale,fs, overlap)
%Computes cross-covariance over time after dividing the signal in pieces
%Mike x cohen book

%divide both into pieces
%time_scale = 1; %s
%if_window flag for using hamming window 
if ~exist('overlap','var')
        overlap=0.2;
         disp 'computing xcov for overlap = 0.2'
end
slide=1-overlap;
n_scale = round(time_scale*fs*slide);

corr_val = zeros(1,length(1:n_scale:length(x_1)));
maxlag_val = corr_val;
c_i=1;
% loop over pieces
for ps=1:n_scale:length(x_1)-n_scale
    px_1 = x_1(ps:ps+n_scale-1);    
    px_2 = x_2(ps:ps+n_scale-1);
    %compute cross-covariance 
    [p, lags] = xcov(px_1, px_2, 'coeff');
    maxlag_ind = lags(lags == max(lags));
    maxlag_ind = maxlag_ind(end);
    %concatenate
    corr_val(c_i) = p(maxlag_ind);
    maxlag_val(c_i) = lags(maxlag_ind);
    c_i = c_i+1;
end
%time-series for easy plotting
ts = ((1:n_scale:length(x_1)-n_scale) + n_scale/2)./fs;
end

