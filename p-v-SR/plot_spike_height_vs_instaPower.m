% Using allregionresult cell array it populates to_plot cell array
% Concatenates allregionresults and seggregate regionswise
tunnelF = 0;
load ./data/spike-height-v-insta-power/spike-height-v-insta-power.mat

if tunnelF 
    tunnelSetSeparatedResult = formatTunnelResultsbySeggregate (allregionresults);
    allregionresults = tunnelSetSeparatedResult;
    regList = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
else
    regList = ["EC","DG","CA3","CA1"];
end

to_plot = cell(1,4);
for regi = 1:4
    to_plot{regi} = cell(1,2);
    for fi = [ 3 4 5 6 7]
        to_plot{regi}{1} = [to_plot{regi}{1}; cell2mat(allregionresults{fi}{regi}(:,1))];
        to_plot{regi}{2} = [to_plot{regi}{2}; cell2mat(allregionresults{fi}{regi}(:,2))];
    end
end

%% Plot spike height vs instantaneous phase 
figno = [ 1 2 4 3];
figure(2)
for regi = 1:4
    p(regi)=subplot(2,2, figno(regi));
    x_min = 1e-3; x_max = 1e2; x_n = 100; y_min = 1e2; y_max = 1e4; y_n = 50;
    cl_max = 10000; cl_min = 1;  x_log =1; y_log =1;
    fax =  plothist3_log_cl(to_plot{regi}{2},to_plot{regi}{1}, x_min, x_max, y_min, y_max,...
					 cl_min, cl_max, x_log, y_log, x_n, y_n);
%     xlabel('Instantaneous Power in theta (\muV^2)')
%     ylabel('Spike Height (\muV)')
    title(regList(regi))
end
linkaxes(p, 'xy')
%% Calculate rayleigh test for binned data
[pval, z] = circ_rtest(alpha, w, d);
