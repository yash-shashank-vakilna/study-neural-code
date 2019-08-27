%performs ISPC on the new array
 load '1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001/theta-mea\filtered_mea_tunnels.mat'
 [ tunnels_result_array ] = compute_ISPC_neighbor_190228( mea, mea , 1 );

%%
%format and seggregate results
load cw_intertunnels_labels
tunnels_result_array = [tunnels_result_array cw_intertunnels_labels(:,2:3)];
ind=strcmpi(cw_intertunnels_labels(:,3),'none');
tunnels_result_array(ind,:)=[];
region_array_names = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
seggregated_results_into_mat=cell(4,2);
titled_result=cell(4,1);
ts = linspace(1,299,length(tunnels_result_array{53,2}));
for i=1:4                                                                   %seggregating results from the resulat_array table
    ind=strcmpi(tunnels_result_array(:,3),region_array_names{i});
    regionwise_result = tunnels_result_array(ind,:);
    ind_pair = strcmpi(regionwise_result(:,4),'pair');
    seggregated_results_into_mat{i,1} = (cell2mat(regionwise_result(ind_pair,2)));   %select paired tunnels
    seggregated_results_into_mat{i,2} = (cell2mat(regionwise_result...               %select adj tunnels
        (not(ind_pair),2)));
    titled_result{i} =  ((regionwise_result(not(ind_pair),:)));                %selecting adjacent results
end
% save titled_results_mea_1.mat titled_result
% %%
% clear all
% load titled_results_mea_1.mat
%%
%averaging 2 sets and storing separately
% load data_2_ISPC
length_array = length(seggregated_results_into_mat{2,2}(1,:));
cw_results = zeros(length_array,4);
ccw_results = cw_results;

cw_index = { [0 0 0 0 1 1 1 1] ; not([1 0 1 0 1 0 1 0]); ...
    not([0 0 0 0 1 1 1 1]);[1 0 1 0 1 0 1 0]};

for i=1:4
    cw_results(:,i) = mean(cell2mat(titled_result{i}(logical(cw_index{i}),2)),1)';
end

for i=1:4
    ccw_results(:,i) = mean(cell2mat(titled_result{i}(not(logical(cw_index{i})),2)),1)';
end
%%
%Perform ANOVA

% [p,t,stats] = anova1(cw_results);
% [c,m,h,nms] = multcompare(stats);
% figure
[p,t,stats] = anova1(ccw_results);
xticklabels(region_array_names)
set(gca,'FontSize',16)
ylim([0 1])
ylabel 'Inter-tunnnel phase synchrony (ISPC (AU))'
title ECDGCA3CA1_19908_160518_160610_d22_5minspont0001 Interpreter none
[c,m,h,nms] = multcompare(stats);
%%
%seggregate after choosing cw vs ccw set of tunnels
results = cell(1,4);
cw_index = { [0 0 0 0 1 1 1 1]; not([1 0 1 0 1 0 1 0]); ...
    not([0 0 0 0 1 1 1 1]);[1 0 1 0 1 0 1 0]};

for i=1:4
    results{i} = (titled_result{i}(logical(cw_index{i}),:));
end

%%
%plotting tunnels averages 4 
figure(1)
hold on
for i=1:4
plot(ts,smoothdata(ccw_results(:,i),'gaussian',9),'LineWidth',2)
% plot(ts,(ccw_results(:,i)),'LineWidth',1.5)
end
set(gca,'FontSize',16)
legend(region_array_names)
ylabel 'Inter-tunnnel phase synchrony (ISPC (AU))'
title ECDGCA3CA1_19908_160518_160610_d22_5minspont0001 Interpreter none
hold off
%%
%performing cross correlation in ispc time series
%between a set of tunnel and next set 
%e.g. xcorr bet average EC-DG and average DG-CA3
c_max=zeros(1,4);
next_i=[2 3 4 1];
for i=1:4
    c_max(i)= max(xcorr(ccw_results(i,:),ccw_results(next_i(i),:)));
end
bar(c_max) 
xticklabels({'EC-DG & DG-CA3', 'DG-CA3 & CA3-CA1', 'CA3-CA1 & CA1-EC', 'CA1-EC &EC-DG'})
ylabel(' xcorr betn consecutive sets of tunnels')

%%

%plot all 4 subregion ISPC stacked
color_arr = {'black','blue','red','green'};
for regi=1:4
    figure(regi)
    hold on
    for pairi=1:4
        subplot(4,1,pairi)
        plot(ts,smoothdata(results{regi}{pairi,2}),color_arr{regi})
        if pairi==1
            title(region_array_names{regi}) 
        end
        ylabel(replace(results{regi}{pairi,1},'and','-'))
        set(gca,'FontSize',16)
        if pairi<4
        set(gca,'xticklabel',{[]})
        end
    end
    hold off
end
%%

%plot all 4 subregion ISPC differently stacked 
color_arr = {'black','blue','red','green'};
for regi=1:4
    figure(regi)
    hold on
%     subplot(4,1,regi)
    for pairi=1:4
        plot(ts,pairi + smoothdata(results{regi}{pairi,2}),color_arr{pairi})
        set(gca,'FontSize',16)
    end
    ylabs = (results{regi}(:,1));
    ylabs = cellfun(@(x) replace(x,'and','-'),ylabs,'UniformOutput',false);
    yticks(gca,0.5+[1 2 3 4])
    yticklabels(ylabs)
    title(region_array_names{regi}) 
    hold off
    
end
%%
%TODO: check cw vs ccw array issue


