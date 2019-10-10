function [idx] = find_in_channel_list(channel_list,chan_name)
%Returns the index of chan_name in channel_list
chan_name = replace(chan_name, ' ','');
channel_list = replace(channel_list, ' ','');
idx = find(strcmpi(cellstr(channel_list), char(chan_name)));
end

