region_file_names = {'mea_EC','mea_DG','mea_CA3',...
    'mea_CA1','mea_tunnels'};
i=5
    load(region_file_names{i});
    coordinates{i} = mea_tunnels.coordinates;

