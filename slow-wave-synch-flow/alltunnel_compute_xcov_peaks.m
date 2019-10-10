cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\slow-wave-synch-flow'
load ../mea_IO_basic/cw_intertunnels_labels.mat
load ../mea_IO_basic/dataInfo.mat
regNames = ["EC-DG", "DG-CA3", "CA3-CA1", "CA1-EC"];
cd ../data/
fName= dir('*0001'); fName = string({fName(:).name});  
allregionresults=cell(1,7);
low_freq = 4; 
n=0.5;                                                                       %cycles in every piece
time_scale = round(n*1/low_freq*1e3); if_zscore = 1;
%%
for fi=3:length(fName)
    %% Looping through mea recordings
    cd(fName{fi})
    load ./theta-mea/filtered_mea_tunnels.mat
    
    if strcmpi(dataInfo.orientation{fi}, 'CW')
        chan_labels = cw_intertunnels_labels;
    else
        chan_labels = convert_labels_2_ccw_190405(cw_intertunnels_labels);
    end
    
    for regi = 1:length(regNames)
        %selecting data based on pairiness and region
        chani = strcmpi(chan_labels(:,2), regNames(regi)) & strcmpi(chan_labels(:,3), 'pair');
        chan_list = chan_labels(chani, 1);

        %seggregating chan_labels
        seg_chan_labels = cell(length(chan_list),2);
        for labi = 1:length(chan_list)
            seg_chan_labels(labi, :) = strsplit(chan_list{labi,:}, '-');
        end
        %passing to compute_xcov_subset
        [ result_array ] = compute_xcov_neighbor_subset_peaks_191007( mea, mea, seg_chan_labels,  time_scale, if_zscore );
        %storing result
        allregionresults{fi}{regi} = result_array;
    end
    cd ..
end
%% Standardize FF dirn so that +ve lag is FF and -ve is FB
[allregionresults] = standadrize_wrt_FF_dir (allregionresults);
disp 'FF-FB corrected'
