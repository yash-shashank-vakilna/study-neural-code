function tunnelSetSeparatedResult = formatTunnelResultsbySeggregate (allregionresults, regList)
tunnelResultRegion = cell(1,7);
regList = ["CW","CW","ccw","ccw","ccw"];
chan_order = {[25:34; 15:24; 35:44; 1:10],...
    [1:10; 35:44; 15:24; 25:34]}; %{CW, ccw}

for regi = 3:4
    for chani = 1:4
        tunnelResultRegion{regi}{chani} = allregionresults{regi}{5}(chan_order{1}(chani,:),:);
    end
end
  
for regi = 5:7
    for chani = 1:4
        tunnelResultRegion{regi}{chani} = allregionresults{regi}{5}(chan_order{2}(chani,:),:);
    end
end

end