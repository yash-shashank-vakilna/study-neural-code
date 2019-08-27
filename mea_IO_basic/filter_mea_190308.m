function [ filtered_mea] = filter_mea_190308(mea, f_l, f_h, downSampleRatio)
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

% filter frequency band theta
filtbound = [f_l f_h]; % Hz

% transition width
trans_width = 0.2; % fraction of 1, thus 20%

% filter order
filt_order = round(3*(fs/filtbound(1)));

% frequency vector (as fraction of Nyquist
ffrequencies  = [ 0 (1-trans_width)*filtbound(1) filtbound (1+trans_width)*filtbound(2) nyquist ]/nyquist;

% shape of filter (must be the same number of elements as frequency vector
idealresponse = [ 0 0 1 1 0 0 ];

% get filter weights
fir_f = fir1(filt_order, filtbound./nyquist);

for chani=1:length_mea                                                      %filtering
    filtered_data{chani}=filtfilt(fir_f,1, double(mea.raw_data{chani}));      
    fprintf('%d channel filtered\n',chani)
end
% save('raw_filtered_mea_ec','filtered_data');

%populating filter_mea and putting paramters in par field
filtered_mea=mea;
filtered_mea.filtered_data=filtered_data;
filtered_mea.par.down_fs=25e3;
filtered_mea.par.filterBound = filtbound;
filtered_mea.par.filterTransitinWidth = trans_width;
filtered_mea.par.filterOrder = filt_order;
filtered_mea=rmfield(filtered_mea,'raw_data');

%downsampling
if exist('filter_ratio','var')
    filtered_mea.par.down_fs=25e3/downSampleRatio;
    fs_down = filtered_mea.par.down_fs;
    down_filt_dat = cell(length(filtered_mea.filtered_data),1);
    for chani = 1:length(filtered_mea.filtered_data)                            %downsampling data
        temp = resample(filtered_mea.filtered_data{chani},1,downSampleRatio);
        down_filt_dat{chani} = temp((1*fs_down:299*fs_down-1));
        fprintf('%d channel downsampled\n',chani)
    end

    filtered_mea.filtered_data = down_filt_dat;
    % filtered_mea.par.fs=25e3;  
end

end

