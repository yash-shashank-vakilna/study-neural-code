function [tunnelCoord] = findTunnelCoord(tunnelTemp,subC)
%Finds tunnel coordinate based on the template

nzI = find(tunnelTemp > 0);
subC(nzI) = tunnelTemp(nzI);
tunnelCoord = subC;
end

