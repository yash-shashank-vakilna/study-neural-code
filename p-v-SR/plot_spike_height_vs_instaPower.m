% Using allregionresult cell array it populates to_plot cell array
% Concatenates allregionresults and seggregate regionswise
to_plot = cell(1,4);

for regi = 1:4
    to_plot{regi} = cell(1,2);
    for fi = [ 3 4 5 6 7]
        to_plot{regi}{1} = [to_plot{regi}{1}; cell2mat(allregionresults{fi}{regi}(:,1))];
        to_plot{regi}{2} = [to_plot{regi}{2}; cell2mat(allregionresults{fi}{regi}(:,2))];
    end
end

%%

figno = [ 1 2 4 3];
figure(1)
for regi = 1:4
    p(regi)=subplot(2,2, figno(regi));
    scatter(to_plot{regi}{2},to_plot{regi}{1},'.')
%     fax =  plot2histloglin(to_plot{regi}{1},to_plot{regi}{2}, x_min, x_max, y_min, y_max,...
% 					 cl_min, cl_max, cl_n, x_n, y_n);
    xlabel('Instantaneous Power (\muV^2)')
    ylabel('Spike Height (\muV)')
    set(gca, 'FontSize', 16, 'XScale','log','YScale','log')
end
linkaxes(p, 'xy')