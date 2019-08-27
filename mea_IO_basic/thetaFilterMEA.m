function [status] = thetaFilterMEA(folderAddr)
%filters mea in folderAddr with proper names 
cd(folderAddr)
status = 0;

disp working_EC
load mea_EC
mea = filter_mea_190308(mea, 4, 11);
save('filtered_mea_EC','mea','-v7.3');
clear mea

disp working_DG
load mea_DG
mea = filter_mea_190308(mea, 4, 11);
save('filtered_mea_DG','mea','-v7.3');
clear mea

disp working_CA3
load mea_CA3
mea = filter_mea_190308(mea, 4, 11);
save('filtered_mea_CA3','mea','-v7.3');
clear mea

disp working_CA1
load mea_CA1
mea = filter_mea_190308(mea, 4, 11);
save('filtered_mea_CA1','mea','-v7.3');
clear mea

disp working_tunnels
load mea_tunnels
mea = filter_mea_190308(mea, 4, 11);
save('filtered_mea_tunnels','mea','-v7.3');
status = 1;
end

