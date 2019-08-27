function [ burst_train ] = convert_to_burst_train_190410(burst_detection , length_recording)
%converts the output of burst_detection algorithm to burst_train
%   The format of input = n_burst X 2 matrix = [start_burst, stop_burst]

n_bursts = size(burst_detection,1);
burst_train = zeros(length_recording, 1);
if(burst_detection == 0)
    burst_train = logical(burst_train);
    return
end                                                                    %convert to milli-seconds

for buri = 1:n_bursts
    burst_seg =  (burst_detection(buri,1):burst_detection(buri,2));
    burst_train(burst_seg) = 1;
end
burst_train = logical(burst_train);
end

