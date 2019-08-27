function [ mea ] = create_mea( no_channels)
%creates empty mea based on no channels
mea.raw_data = cell(no_channels,1);
mea.channel_names = strings(no_channels,1);
mea.par=struct;
end

