function [SR, t_series] = computeSpikeRate( x, t_scale, fs)
%Computes power for x as specified by nscale
% t_scale in ms
n_scale = round(t_scale*fs/1e3);
SR = zeros(1,length(1:n_scale:length(x)-n_scale));
t_series = SR;
c_i = 1;

for ps=1:n_scale:length(x)-n_scale+1
    SR(c_i) = length(find(x(ps:ps+n_scale-1)));   
    t_series(c_i) = (c_i*n_scale)/fs;
    c_i = c_i+1;
end


end

