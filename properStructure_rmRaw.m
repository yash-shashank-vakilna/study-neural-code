cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\data
fnames = dir; fnames = {fnames(3:end).name};
nspikes=4;ISImax=50;min_mbr=0.4;

for fi = 1
    cd(string(fnames(fi)+"\spikes"))
    meaNames = dir("*.mat"); meaNames = {meaNames.name};
    for meaI = 1:length(meaNames)
        orientation = dataInfo(meaI,2);
        load(meaNames{meaI})
        mea.spike_data = mea.spike_data';
        try
            mea = rmfield(mea,'raw_data');
        catch
            disp 'no raw'
        end
        [ burst_cell ] = mea_detect_burst( mea,  nspikes, ISImax, min_mbr  ) ;
        mea.burst_data = burst_cell;
%         if meaI < 5
%             meafName =  erase(meaNames{meaI},"mea_");
%             meafName =  erase(meafName,".mat");
%             mea.subregion = repmat(meafName(str2cell(meafName)),19,1);
%         else
%             if strcmpi(orientation, 'cw')
%                 mea.subregion = [repmat({'CA1-EC'},10,1);repmat({'NONE'},4,1)...
%                     ;repmat({'DG-CA3'},10,1);repmat({'EC-DG'},10,1);repmat({'CA3-CA1'},10,1)];
%             else
%                 mea.subregion = [repmat({'EC-DG'},10,1);repmat({'NONE'},4,1)...
%                     ;repmat({'CA3-CA1'},10,1);repmat({'CA1-EC'},10,1);repmat({'DG-CA3'},10,1)];
%             end
%         end
        save(meaNames{meaI}, 'mea')
    end
    cd ../..
end

        