% load 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\mea_IO_basic\dataInfo.mat' 
cd('C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data')
folderNames = dir('*0001');
fl =30; fh = 140;

for fi = 4:7
    disp("working: " + folderNames(fi).name)
    cd("./"+folderNames(fi).name+"/raw-mea")
%     h5_file_address = strcat(dataInfo{fi,1},'.h5');
%     s=hdf5_into_struct(h5_file_address, pwd , dataInfo{fi,2});
    FilterMEAfolder(pwd, fl, fh)
    mkdir ../gamma-mea
    movefile ./filtered_mea_* ../gamma-mea
    cd('../..')
end
    
% clear mea