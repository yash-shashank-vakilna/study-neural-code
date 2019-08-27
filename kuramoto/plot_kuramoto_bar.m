load filtered_mea_EC
time=1e3;
[space_average_r] = calculate_r_190703(mea_EC, time);
mean_subregion = mean(space_average_r);
SD_subregion = std(space_average_r);
clear mea_EC

load filtered_mea_DG
[space_average_r] = calculate_r_190703(mea_DG, time);
mean_subregion =[mean_subregion mean(space_average_r)];
SD_subregion = [SD_subregion std(space_average_r)];

load filtered_mea_CA3
[space_average_r] = calculate_r_190703(mea_CA3, time);
mean_subregion =[mean_subregion mean(space_average_r)];
SD_subregion = [SD_subregion std(space_average_r)];

load filtered_mea_CA1
[space_average_r] = calculate_r_190703(mea_CA1, time);
mean_subregion =[mean_subregion mean(space_average_r)];
SD_subregion = [SD_subregion std(space_average_r)];