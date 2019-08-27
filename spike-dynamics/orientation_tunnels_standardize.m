ori = {'ccw','cw','cw','cw','cw','ccw','ccw'}; 
cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\data'
folderAddr = dir('*0001');
folderAddr = {folderAddr.name};

for fi = 1:7
    cd(folderAddr{fi}+"/spikes/")
    load('mea_tunnels')
    mea.par.orientation = ori{fi};
    if strcmpi(ori{fi}, 'cw')
     mea.subregion = [repmat({'CA1-EC'},10,1);repmat({'NONE'},4,1)...
         ;repmat({'DG-CA3'},10,1);repmat({'EC-DG'},10,1);repmat({'CA3-CA1'},10,1)];
    else
     mea.subregion = [repmat({'EC-DG'},10,1);repmat({'NONE'},4,1)...
          ;repmat({'CA3-CA1'},10,1);repmat({'CA1-EC'},10,1);repmat({'DG-CA3'},10,1)]; 
    end
    save('mea_tunnels','mea','-v7.3')
    cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\data'
end