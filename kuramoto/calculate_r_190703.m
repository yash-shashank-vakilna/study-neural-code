function [space_average_r, r_data] = calculate_r_190703(mea_in, time)
%calculates time varying kuramoto order parameter (r)
%time in ms
%band assumed to be theta

fs=mea_in.par.down_fs;
n_scale = time.*fs/1e3;                                                     %initialize parameters
recording_samples_length = length(mea_in.filtered_data{1});
no_channels=length(mea_in.filtered_data);                                         
                                                                           
angle_data = cell(no_channels,1);                                           %perform hilbert transform and get angles
r_data = cell(no_channels,1);

for chani=1:no_channels                                                     %calculate angle time series
    angle_data{chani}=angle(hilbert(mea_in.filtered_data{chani}));
    fprintf('angle calculated: %d\n',chani)
end

                                                                            
for chani=1:no_channels                                                     %time average phase series
    length_r_series = length(1:n_scale:recording_samples_length);
    temp_r_series=zeros(length_r_series,1);
    angle_i=1;
    
    for n_ind=1:n_scale:recording_samples_length                             %performing time average
        temp_r_series (angle_i)= abs(mean(exp...
            (1i*(angle_data{chani}(n_ind:n_ind+n_scale-1)))));
        angle_i=angle_i+1;
    end
    
    r_data{chani}=temp_r_series;
end

space_average_r = zeros(length_r_series,1);
for chani=1:no_channels                                                     %space average
    space_average_r = space_average_r + r_data{chani};
end
space_average_r = space_average_r./no_channels;

end

