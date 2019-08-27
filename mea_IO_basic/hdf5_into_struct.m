function [status] = hdf5_into_struct(h5_file_address, destination_folder, orientation)
%converts hdf5 file into formatted structs
    status=0;
    infochannel = h5read(h5_file_address,'/Data/Recording_0/AnalogStream/Stream_0/InfoChannel');
    channeldata = h5read(h5_file_address,'/Data/Recording_0/AnalogStream/Stream_0/ChannelData');
    channel_names_per_subregion = ...
        {["A4","A5","B3","B4","B5","C2","C3","C4","C5","D1","D2","D3","D4","D5","E1","E2","E3","E4","E5"];
        ["H1","H2","H3","H4","H5","J1","J2","J3","J4","J5","K2","K3","K4","K5","L3","L4","L5","M4","M5"];
        ["M8","M9","L8","L9","L10","K8","K9","K10","K11","J8","J9","J10","J11","J12","H8","H9","H10","H11","H12"];
        ["E8","E9","E10","E11","E12","D8","D9","D10","D11","D12","C8","C9","C10","C11","B8","B9","B10","A8","A9"];
        ["A6","A7","B6","B7","C6","C7","D6","D7","E6","E7","F6","F7","G6","G7","H6","H7","J6","J7","K6","K7","L6",...
        "L7","M6","M7","F1","F2","F3","F4","F5","G1","G2","G3","G4","G5","F8","F9","F10","F11","F12","G8","G9","G10","G11","G12"]};
    if strcmpi(orientation, 'ccw')
         temp = channel_names_per_subregion;
         channel_names_per_subregion(2) = temp(4);
         channel_names_per_subregion(4) = temp(2);
    end
    channelnamesh5 = infochannel.Label;
    subregion_list = {'EC','DG','CA3','CA1','tunnels'};
    mea_names = {'mea_EC','mea_DG','mea_CA3','mea_CA1','mea_tunnels'};

    %%

    load mea_coordinates.mat
    mkdir(destination_folder)
    cd(destination_folder)
    no_region = length(channel_names_per_subregion);
    for subi = 1:no_region
        no_channels = length(channel_names_per_subregion{subi});
        [ mea ] = create_mea( no_channels);                                    %create empty mea
        for chani = 1:no_channels                                              %populate channel data
            ind = (strcmpi(channelnamesh5,channel_names_per_subregion{subi}(chani)));
            mea.channel_names(chani) = channel_names_per_subregion{subi}(chani);
            mea.raw_data{chani} = channeldata(:,ind);
            fprintf('%d-mea %d-channel converted\n',subi,chani)
        end
        mea.par.fs = 25e3;
        mea.coordinates = coordinates{subi};
        hInfo = hdf5info(h5_file_address);
        mea.par.name = hInfo.Filename;
        mea.channel_names = str2cell(channel_names_per_subregion{subi});
        %% tunnel labels
        if any(subi == 1:4)
            mea.subregion = repmat({subregion_list{subi}},19,1);
        else 
            if strcmpi(orientation, 'cw')
                mea.subregion = [repmat({'CA1-EC'},10,1);repmat({'NONE'},4,1)...
                    ;repmat({'DG-CA3'},10,1);repmat({'EC-DG'},10,1);repmat({'CA3-CA1'},10,1)];
            else
                mea.subregion = [repmat({'EC-DG'},10,1);repmat({'NONE'},4,1)...
                    ;repmat({'CA3-CA1'},10,1);repmat({'CA1-EC'},10,1);repmat({'DG-CA3'},10,1)];
            end
        end
        %%
        save(mea_names{subi},'mea','-v7.3');

    end
    status=1;
end

