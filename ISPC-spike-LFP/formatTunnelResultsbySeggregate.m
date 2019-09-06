function tunnelSetSeparatedResult = formatTunnelResultsbySeggregate (allregionresults, regList)
% Converts allregionresult output and seggregate into subregion-list
tunnelSetSeparatedResult = cell(1,7);
if ~(exist('regList','var'))
    regList = ["ccw","CW","CW","CW","CW","ccw","ccw"];
end
chan_order = {[25:34; 15:24; 35:44; 1:10],...
    [1:10; 35:44; 15:24; 25:34]}; %{CW, ccw}

for regi = 1:length(allregionresults)
    if not(isempty(allregionresults{regi}))
        if(strcmpi(regList(regi), "CW"))
            for chani = 1:4
                tunnelSetSeparatedResult{regi}{chani} = allregionresults{regi}{5}(chan_order{1}(chani,:),:);
            end
        else
            for chani = 1:4
                tunnelSetSeparatedResult{regi}{chani} = allregionresults{regi}{5}(chan_order{2}(chani,:),:);
            end
        end
    end
end

end