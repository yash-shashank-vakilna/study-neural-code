% Using allregionresult cell array it populates to_plot cell array
% Concatenates allregionresults and seggregate regionswise

tunnelF = 0;
load ./data/spike-height-v-insta-power/spike-height-v-insta-phase.mat

if tunnelF
    tunnelSetSeparatedResult = formatTunnelResultsbySeggregate (allregionresults);
    allregionresults = tunnelSetSeparatedResult;
    regList = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
else
    regList = ["EC","DG","CA3","CA1"];
end
to_plot = cell(1,4);
allregionresults = tunnelSetSeparatedResult;
for regi = 1:4
    to_plot{regi} = cell(1,2);
    for fi = [ 3 4 5 6 7]
        to_plot{regi}{1} = [to_plot{regi}{1}; cell2mat(allregionresults{fi}{regi}(:,1))];
        to_plot{regi}{2} = [to_plot{regi}{2}; cell2mat(allregionresults{fi}{regi}(:,2))];
    end
end

%% plot spike-height-v-phase

figure(2)
for regi = 1:4
    p(regi)=subplot(2,2, figno(regi));
%     scatter(to_plot{regi}{2},to_plot{regi}{1},'.')
    x_min = -180; x_max = 180; x_n = 100; y_min = 100; y_max = 5*1e3; y_n = 100;
    cl_max = 250; cl_min = 10; cl_n =10; x_log =0; y_log =1;
    fax =  plothist3_log_cl(rad2deg(to_plot{regi}{2}),to_plot{regi}{1}, x_min, x_max, y_min, y_max,...
					 cl_min, cl_max,  x_log, y_log, x_n, y_n);
    xlabel('\theta Phase (deg)')
    ylabel('Spike Height (\muV)')
    title(regList(regi))
%     set(gca, 'FontSize', 16, 'XScale','log','YScale','log')
end
linkaxes(p, 'xy')