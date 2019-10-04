function [allregionresults] = standadrize_wrt_FF_dir (allregionresults)
%Fixes sign of lags so that +ve lags are FF and -ve are FB

no_mea = length(allregionresults);
for fi = 1:no_mea
    if ~(isempty(allregionresults{fi}))
        for regi = 1:2
            for chani=1:size(allregionresults{fi}{regi},1)-1
                allregionresults{fi}{regi}{chani,2} = -allregionresults{fi}{regi}{chani,2};
            end
        end
    end
end
            
end

