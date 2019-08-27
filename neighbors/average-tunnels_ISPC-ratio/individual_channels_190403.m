load regionwise_filtered_results
region_array_names = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
seggregated_results_into_mat=cell(4,2);
titled_result=cell(4,1);
ts = linspace(1,299,length(result_array{53,2}));
for i=1:4                                                                   %seggregating results from the resulat_array table
    ind=strcmpi(result_array(:,3),region_array_names{i});
    regionwise_result = result_array(ind,:);
    ind_pair = strcmpi(regionwise_result(:,4),'pair');
    seggregated_results_into_mat{i,1} = (cell2mat(regionwise_result(ind_pair,2)));   %select paired tunnels
    seggregated_results_into_mat{i,2} = (cell2mat(regionwise_result...               %select adj tunnels
        (not(ind_pair),2)));
    titled_result{i} =  ((regionwise_result(not(ind_pair),:)));                %selecting adjacent results
end


%%
%averaging 2 sets and storing separately
%performing double anova

length_array = length(seggregated_results_into_mat{2,2}(1,:));
cw_results = zeros(length_array,4);
ccw_results = cw_results;

cw_index = { [0 0 0 0 1 1 1 1]; not([1 0 1 0 1 0 1 0]); ...
    not([0 0 0 0 1 1 1 1]);[1 0 1 0 1 0 1 0]};

for i=1:4
    cw_results(:,i) = mean(cell2mat(titled_result{i}(boolean(cw_index{i}),2)),1)';
end

for i=1:4
    ccw_results(:,i) = mean(cell2mat(titled_result{i}(not(boolean(cw_index{i})),2)),1)';
end
%%
figure(1)
hold on
for i=1:4
plot(ts,smooth(ccw_results(:,i)))
end
set(gca,'FontSize',16)
legend(region_array_names)
hold off
%%

% [p,t,stats] = anova1(cw_results);
% [c,m,h,nms] = multcompare(stats);
% figure
[p,t,stats] = anova1(ccw_results);
xticklabels(region_array_names)
set(gca,'FontSize',16)
ylim([0 1])
[c,m,h,nms] = multcompare(stats);
%chosen ccw based on multcompare
%%

results = cell(1,4);
cw_index = { [0 0 0 0 1 1 1 1]; not([1 0 1 0 1 0 1 0]); ...
    not([0 0 0 0 1 1 1 1]);[1 0 1 0 1 0 1 0]};

for i=1:4
    results{i} = (titled_result{i}(boolean(cw_index{i}),:));
end
%%
%plotting
color_arr = {'black','blue','red','grey'};
for regi=1:4
    figure(regi)
    hold on
    for pairi=1:4
        subplot(4,1,pairi)
        plot((results{regi}{pairi,2}),color_arr{regi})
        if pairi==1
            title(region_array_names{regi}) 
        end
        ylabel(replace(results{regi}{pairi,1},'and','-'))
        set(gca,'FontSize',16)
    end
    hold off
    
end
%%

%plotting
color_arr = {'black','blue','red','green'};
for regi=1:4
    figure(regi)
    hold on
%     subplot(4,1,regi)
    for pairi=1:4
        plot(ts,pairi + (results{regi}{pairi,2}),color_arr{pairi})
        set(gca,'FontSize',16)
    end
    ylabs = (results{regi}(:,1));
    ylabs = cellfun(@(x) replace(x,'and','-'),ylabs,'UniformOutput',false);
    yticks(gca,0.5+[1 2 3 4])
    yticklabels(ylabs)
    title(region_array_names{regi}) 
    hold off
    
end