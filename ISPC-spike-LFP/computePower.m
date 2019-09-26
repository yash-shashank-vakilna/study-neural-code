function power = computePower( x, t_scale, fs)
%Computes power for x as specified by nscale
% t_scale in ms
x = zscore(x);
n_scale = round(t_scale*fs/1e3);
power = zeros(1,length(1:n_scale:length(x)-n_scale));
c_i = 1;

for ps=1:n_scale:length(x)-n_scale+1
    power(c_i) = sum(x(ps:ps+n_scale-1).^2)/t_scale;    
    c_i = c_i+1;
end


end

