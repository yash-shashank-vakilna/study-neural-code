
cd('C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data')
folderNames = dir('*0001');
fl =30; fh = 100; folder_name = "low-gamma-mea";

for fi = 1:7
    disp("working: " + folderNames(fi).name)
    cd("./"+folderNames(fi).name+"/raw-mea")
%     h5_file_address = strcat(dataInfo{fi,1},'.h5');
%     s=hdf5_into_struct(h5_file_address, pwd , dataInfo{fi,2});
    FilterMEAfolder(pwd, fl, fh)
    mkdir("../"+folder_name)
    movefile("./filtered_mea_*", "../"+folder_name)
    cd('../..')
end
    
% clear mea