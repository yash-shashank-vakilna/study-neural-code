%performs ISPC on the new array
 load \\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\theta_filtered\filtered_mea_tunnels.mat
 [ tunnels_result_array ] = compute_ISPC_neighbor_190228( mea, mea , 1 );

%%
%Formatting results stored in regionwise_filtered_result
% load regionwise_filtered_results
load cw_intertunnels_labels
ccw_intertunnels_labels = convert_labels_2_ccw_190405(cw_intertunnels_labels);
tunnels_result_array = [tunnels_result_array ccw_intertunnels_labels(:,2:3)];
ind=strcmpi(ccw_intertunnels_labels(:,3),'none');
tunnels_result_array(ind,:)=[];
region_array_names = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
no_region = length(region_array_names);
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
%%
%averaging 2 sets and storing separately
length_array = length(seggregated_results_into_mat{2,2}(1,:));
cw_results = zeros(length_array,4);
ccw_results = cw_results;

cw_index = { [1 0 1 0 1 0 1 0]; not([0 0 0 0 1 1 1 1]); not([1 0 1 0 1 0 1 0]);...
    [0 0 0 0 1 1 1 1]};

for i=1:4
    cw_results(:,i) = mean(cell2mat(titled_result{i}(logical(cw_index{i}),2)),1)';
end

for i=1:4
    ccw_results(:,i) = mean(cell2mat(titled_result{i}(not(logical(cw_index{i})),2)),1)';
end
%%
h_mat = ones(no_region,1);
h = h_mat;
for n=1:-0.01:0.4
    for pairi = 1:no_region
        data = ccw_results(:,pairi);
        data = data(data < 2*n*max(data) & data > (1/(n))*min(data) );
        h(pairi,1)=adtest(data);
%         figure(pairi), qqplot(data,fitdist(data,'Normal')); title(region_array_names(pairi)); 
        figure(pairi), histfit(data); title(region_array_names(pairi)); 
        text(0,80,sprintf('ad-test- %d\n',h(pairi,1)))
        xlim([0 1]), ylim([0 80]);
    end
    h_mat = [h h_mat];
    if not(h(1) || h(2) || h(3) || h(4))
        break
    end
    length(data) 
end
% n=1:-0.01:0.3;
% figure(3)
% imagesc(n,1:4,h_mat), set(gca, 'ydir', 'normal')
% yticks(1:4), yticklabels(region_array_names)
%%

h_mat = zeros(no_region,2);
for pairi =1:no_region
    histfit(cw_results(:,pairi),20);
    title(strcat('Histogram for ISPC for cw in: ',region_array_names{pairi}));
    saveas(gca,strcat('hist_',region_array_names{pairi},'_cw'),'png')
    pd = fitdist(cw_results(:,pairi),'Normal');
    qqplot(cw_results(:,pairi),pd)
    title(strcat('QQ-plot for ISPC for cw in: ',region_array_names{pairi}));
    saveas(gca,strcat('qq_',region_array_names{pairi},'_cw'),'png')
    h_mat(pairi,1)=adtest(cw_results(:,pairi));
end
    %% CCW
for pairi =1:no_region
%     histfit(ccw_results(:,pairi),20);
%     title(strcat(' ',region_array_names{pairi}));
%     set(gca,'fontsize',16)
%     saveas(gca,strcat('hist_',region_array_names{pairi},'_ccw'),'png')
    pd = fitdist(ccw_results(:,pairi),'Normal');
    figure(pairi)
    qqplot(ccw_results(:,pairi),pd)
    title(strcat('',region_array_names{pairi}));
    set(gca,'fontsize',16)
    saveas(gca,strcat('qq_',region_array_names{pairi},'_ccw'),'png')
    h_mat(pairi,2)=adtest(ccw_results(:,pairi));
end

%%
deviate_cell=cell(no_region, 3);
for pairi =1:no_region
    pd = fitdist(ccw_results(:,pairi),'Normal');
    figure(pairi)
    qqplot(ccw_results(:,pairi),pd)
    title(strcat('QQ-plot for ISPC for ccw in: ',region_array_names{pairi}));
    ax=gca;
    transformed_data = [ax.Children(1).XData', ax.Children(1).YData' ];
    transformed_data = [transformed_data, zeros(length(transformed_data),1)];
    norm_line = [ax.Children(3).XData', ax.Children(3).YData'];
    norm_line = [norm_line, zeros(length(norm_line),1)];
    dev = zeros(length(transformed_data),1);
    for di = 1:length(transformed_data)
        dev(di) = point_to_line_190426(transformed_data(di,:), norm_line);
    end
    deviate_cell(pairi,:) = [region_array_names(pairi), {transformed_data},  {dev}];
    pairi
end
%%
%plotting gaussian error plots
for chani = 1:no_region
    figure(chani)
    plot(deviate_cell{chani,2}(:,1)', deviate_cell{chani,3})
    xlabel('Quantiles of Normal distribution')
    ylabel('Error from Normal distribution (au)')
    title("Error plot for "+string(region_array_names{chani}))
    set(gca,'fontsize',16,'xlim',[0 1],'YLim',[0 0.1])
    saveas(gcf,"Error-plot-ccw-"+string(region_array_names{chani}),'png')
end
%%
%ploting slope of errors
for chani = 1:no_region
    figure(chani)
    normal_quantiles = (deviate_cell{chani,2}(1:end-1,1));
    diff_error = diff(deviate_cell{chani,3});
    findpeaks(diff_error, normal_quantiles , 'Threshold', 5e-3,'Annotate')
    xlabel('Quantiles of Normal distribution')
    ylabel('Slope of error (au)')
    title("Diff error plot for "+string(region_array_names{chani}))
    set(gca,'fontsize',16,'YLim',[-0.045 0.045])
    saveas(gcf,"Diff-error-plot-ccw-"+string(region_array_names{chani}),'png')
end
%%
%seggregate after choosing cw vs ccw set of tunnels
cw_index = { [1 0 1 0 1 0 1 0]; not([0 0 0 0 1 1 1 1]); not([1 0 1 0 1 0 1 0]);...
    [0 0 0 0 1 1 1 1]};
results = cell(1,4);

for i=1:4
    results{i} = (titled_result{i}(not(logical(cw_index{i})),:));
end
%%
%plot all 4 subregion ISPC differently stacked 
color_arr = {'black','blue','red','green'};
reg_threshold_q = [0.88, 0.55, 0.56, 0.80];
        
for regi=1:4
    figure(regi)
    clf
    hold on
    for pairi=1:4
        subplot(4,1,pairi)
        data = (results{regi}{pairi,2});
        data = (data > quantile(data, reg_threshold_q(regi) ));
        bar(ts,data)
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
    saveas(gcf, strcat('bin_',region_array_names{regi}), 'png')
end
%%
per_mat=[];
for regi=1:4
    figure(regi)
    clf
    hold on
    for pairi=1:4
        subplot(4,1,pairi)
        da = (results{regi}{pairi,2});
        data(pairi,:) = (da > quantile(da, reg_threshold_q(regi) )); 
    end
    bin_and = data(1,:) & data(2,:) & data(3,:) & data(4,:);
    per_mat(regi) = sum(bin_and) /length(da);
end
%%
% point_to_line([0, 0.5], [0,0;1,0])
function d = point_to_line_190426(pt, v)
      a = v(1,:) - v(2,:);
      b = pt - v(2,:);
      d = norm(cross(a,b)) / norm(a);
end

function d_min = distancefline(pt,v)
    x = linspace(v(1,1), v(2,1), 1000);
    y = linspace(v(1,2), v(2,2), 1000);
    d_min = 1e4;
    for pi = 1:length(x)
        d = sqrt( (pt(1)-x(pi)).^2 + (pt(2)-y(pi)).^2 );
        if d<d_min, d_min = d; end
    end
end