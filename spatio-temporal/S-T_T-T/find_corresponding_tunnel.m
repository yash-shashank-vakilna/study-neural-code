function [tunnelInd,tunnelCoord] = find_corresponding_tunnel(mea_tunnels,mea_sub, chan_no, SoT)
% Finds nearest tunnel depending on S/T

% establishing tunnel templates and regList
if string(SoT) == "S"
    nearestTunnelCoordTempMat = [0,7 ; 6,0 ; 0,6 ; 7,0];
else
    nearestTunnelCoordTempMat = [6,0 ; 0,6 ; 7,0 ; 0,7];
end
regList = ["EC","DG","CA3","CA1"];

%finding the appropriate tunnels
subInd = (contains(regList, string(mea_sub.par.subregion)));
tunnelCoord = findTunnelCoord(nearestTunnelCoordTempMat(subInd,:),mea_sub.coordinates{chan_no});

%finding the index of this tunnel
for chanI = 1:length(mea_tunnels.coordinates)
    if find_distance(tunnelCoord,mea_tunnels.coordinates{chanI}) == 0
        tunnelInd = chanI;
        break;
    else
        tunnelInd = 0;
    end
end


end

