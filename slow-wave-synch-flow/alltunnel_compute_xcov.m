load ../mea_IO_basic/cw_intertunnels_labels.mat
load ../mea_IO_basic/dataInfo.mat
regNames = ["EC-DG", "DG-CA3", "CA3-CA1", "CA1-EC"];
fName= dir('*0001'); fName = string({fName(:).name});  
allregionresults=cell(1,7);
no_features = 2;                                                             % change the no of features 
time_scale = 1;
%%
for fi=3%:length(fName)
    %% Looping through mea recordings
    cd(fName{fi})
    load ./theta-mea/filtered_mea_tunnels.mat
    
    if strcmpi(dataInfo.orientation{fi}, 'CW')
        chan_labels = cw_intertunnels_labels;
    else
        chan_labels = convert_labels_2_ccw_190405(cw_intertunnels_labels);
    end
    
    for regi = 1%:length(regNames)
        %selecting data based on pairiness and region
        chani = strcmpi(chan_labels(:,2), regNames(regi)) & strcmpi(chan_labels(:,2), 'pair');
        chan_list = chan_labels(chani, 1);

        %seggregating chan_labels
        seg_chan_labels = cell(length(chan_list),2);
        for labi = 1:length(cw_intertunnels_labels(:,1))
            seg_chan_labels(labi, :) = strsplit(cw_intertunnels_labels{labi,:}, '-');
        end
        %passing to compute_xcov_subset
        [ result_array ] = compute_xcov_neighbor_subset_190418...
            ( mea, mea, seg_chan_labels,  time_scale );
        %storing result
        allregionresults{fi}{regi} = result_array;
    end
end