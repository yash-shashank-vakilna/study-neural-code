load folderWiseResult.mat
for fi = 1:7
    for regI = 1:5
        
        if regI < 5
            folderWiseResult{fi}{regI}{2} = folderWiseResult{fi}{regI}{1}{regI,2};
            folderWiseResult{fi}{regI}{1} = folderWiseResult{fi}{regI}{1}{regI,1};
            
        else
            folderWiseResult{fi}{5} = folderWiseResult{fi}{5}{1,2};
        end
    end
end