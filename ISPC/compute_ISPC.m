function [coher_val, ts] = compute_ISPC(x_1,x_2, time_scale,fs,if_window, overlap)
%Computes ISPC over time after dividing the signal in pieces
%Mike x cohen book

%divide both into pieces
%time_scale = 1; %s
%if_window flag for using hamming window 
if(~exist('if_window','var') && if_window)
    x_1=x_1.*hamming(length(x_1));
    x_2=x_2.*hamming(length(x_2));
end

if ~exist('overlap','var')
        overlap=0.2;
         disp 'computing ISPC for overlap = 0.2'
end
slide=1-overlap;
n_scale = round(time_scale*fs*slide);

coher_val = zeros(1,length(1:n_scale:length(x_1)));
c_i=1;
% loop over pieces
for ps=1:n_scale:length(x_1)-n_scale
    px_1 = x_1(ps:ps+n_scale-1);    
    px_2 = x_2(ps:ps+n_scale-1);
    %compute analytic signal
    as_1 = hilbert(px_1);
    as_2 = hilbert(px_2);
    %compute ISPC
    p_d_1 = angle(as_1);
    p_d_2 = angle(as_2);
    p_ispc = abs(mean(exp(1i*(p_d_1-p_d_2))));  
    %concatenate
    coher_val(c_i) = p_ispc;
    c_i = c_i+1;
end
%time-series for easy plotting
ts = linspace(1,1+((length(coher_val)-1)*n_scale/fs),length(coher_val));
end

