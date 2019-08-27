function lfp_mea = preprocessMEAfolder190502(meaFolder,  f_l, f_h, downsample_order)
cd(meaFolder)

%getting mea file names and sorting
try
    subregions = ["EC","DG","CA3","CA1","tunnels"]; 
    fNames = dir('*mea*mat'); fNames = string({fNames(:).name});
    for subI =1:length(subregions)
        ind(subI) = find(contains(fNames, subregions(subI)));
    end
    fNames = fNames(ind);
catch
    disp('folder does not contain all mea files')
end

%loading initial file-name as template
%loading, filtering, donwsampling, and concatenating
load(fNames(1));
par = mea.par;
par.subregion = string(par.subregion);
lfp_mea = filter_mea_190308(mea, f_l, f_h, downsample_order);
lfp_mea = rmfield(lfp_mea,'par');

%loading, filtering, donwsampling, and concatenating
for meaI = 2:length(fNames)
    load(fNames(meaI))
    par.subregion = [par.subregion; string(mea.par.subregion)];
    filtered_mea = filter_mea_190308(mea, f_l, f_h, downsample_order);
    lfp_mea = concatenate_mea(lfp_mea, filtered_mea);
    clear mea, clear filtered_mea;
end

%populating par
lfp_mea.par = par;
[~,lfp_mea.par.name] = fileparts(meaFolder);

%saving
output_folder = "\lfp_filtered";
output_folder = string(pwd)+output_folder;
cd(output_folder)
save('filteredMEA',filtered_mea,'-v7.3')

end