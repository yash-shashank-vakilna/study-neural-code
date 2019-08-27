function [ccw_intertunnel_labels] = convert_labels_2_ccw_190405(cw_intertunnel_labels)
%converts cw_intertunnel_labels to ccw_intertunnel_labels
ccw_intertunnel_labels = cw_intertunnel_labels;
cw_order = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
ccw_order = {'CA1-EC', 'CA3-CA1','DG-CA3','EC-DG'};
no_regions = length(cw_order);
for regi = 1:no_regions
    bool_ind = strcmpi(cw_intertunnel_labels(:,2) , cw_order{regi});                %find indices corresponding cw orientation
    [ccw_intertunnel_labels{bool_ind,2} ] = deal( ccw_order{regi});                                       %replace with ccw labels 
end

end
