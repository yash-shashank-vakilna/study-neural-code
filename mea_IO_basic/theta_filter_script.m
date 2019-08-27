load 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\mea_IO_basic' 
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
folderNames = dir('*0001');
for fi = 1:7
    disp("working: " + folderNames(fi).name)
    cd(folderNames(fi).name)
    h5_file_address = strcat(dataInfo{fi,1},'.h5');
    s=hdf5_into_struct(h5_file_address, pwd , dataInfo{fi,2});
    thetaFilterMEA(pwd)
    cd ..
end
    
% clear mea