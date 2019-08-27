load regionwise_filtered_results
region_array = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
seggregated_results=cell(4,2);
for i=1:4                                                                   %seggregating results from the resulat_array table
    ind=strcmpi(result_array(:,3),region_array{i});
    regionwise_result = result_array(ind,:);
    ind_pair = strcmpi(regionwise_result(:,4),'pair');
    seggregated_results{i,1} = (regionwise_result(ind_pair,2));
    seggregated_results{i,2} = (regionwise_result(not(ind_pair),2));
end
%%