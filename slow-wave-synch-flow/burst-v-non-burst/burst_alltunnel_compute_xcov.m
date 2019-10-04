load ../mea_IO_basic/cw_intertunnels_labels.mat
load ../mea_IO_basic/dataInfo.mat
regNames = ["EC-DG", "DG-CA3", "CA3-CA1", "CA1-EC"];
cd ../data/
fName= dir('*0001'); fName = string({fName(:).name});  
allregionresults=cell(1,7);
low_freq = 4;
time_scale = 4*1/low_freq; overlap = 0.5;
%%
for fi=3:length(fName)
    %% Looping through mea recordings
    cd(fName{fi})
    load ./theta-mea/filtered_mea_tunnels.mat
    spikeMEA = load('./spikes/mea_tunnels.mat');
    
    if strcmpi(dataInfo.orientation{fi}, 'CW')
        chan_labels = cw_intertunnels_labels;
    else
        chan_labels = convert_labels_2_ccw_190405(cw_intertunnels_labels);
    end
    
    for regi = 1:length(regNames)
        %selecting data based on pairiness and region
        chani = strcmpi(chan_labels(:,2), regNames(regi)) & strcmpi(chan_labels(:,3), 'pair');
        chan_list = chan_labels(chani, 1);
        
        %Burst data
        mea.burst_data = spikeMEA.mea.burst_data;
        
        %seggregating chan_labels
        seg_chan_labels = cell(length(chan_list),2);
        for labi = 1:length(chan_list)
            seg_chan_labels(labi, :) = strsplit(chan_list{labi,:}, '-');
        end
        %passing to compute_xcov_subset
        if_burst = 0;
        [ result_array ] = compute_xcov_neighbor_subset_burst_191001( mea,...
            seg_chan_labels,  time_scale, overlap, if_burst );
        %storing result
        allregionresults{fi}{regi} = result_array;
    end
    cd ..
end
%% Standardize FF dirn so that +ve lag is FF and -ve is FB
[allregionresults] = standadrize_wrt_FF_dir (allregionresults);
disp 'FF-FB corrected'
