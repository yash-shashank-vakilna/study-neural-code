function [ filtered_mea] = highpass_filter_mea_190521(mea,fL )
%Loops over mea and filters it using designed_filt
% mea=mea_EC;
% f_l=4; f_h=11; for theta
% if_downsample flag for downsample
%theta - 4-11 gamma 30-80 Hz

fs=25e3;
length_mea=length(mea.channel_names);
filtered_data=cell(length_mea,1);

% specify Nyquist freuqency
nyquist = fs/2;

% transition width
trans_width = 0.05; % fraction of 1, thus 20%

% filter order
filt_order = round2largestEven(round(3*(fs/fL(1))));

% frequency vector (as fraction of Nyquist
ffrequencies  = [ 0 (1+trans_width)*fL (1+trans_width)*fL nyquist]/nyquist;

% shape of filter (must be the same number of elements as frequency vector
idealresponse = [ 0 0 1 1 ];

% get filter weights
fir_f = firls(filt_order, ffrequencies, idealresponse, [100 1]);

for chani=1:length_mea                                                      %filtering
    filtered_data{chani}=filtfilt(fir_f,1, double(mea.raw_data{chani}));      
    fprintf('%d channel filtered\n',chani)
end
% save('raw_filtered_mea_ec','filtered_data');

filtered_mea=mea;
filtered_mea.filtered_data=filtered_data;
filtered_mea.par.down_fs=25e3;

end

