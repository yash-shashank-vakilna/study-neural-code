function [edges] = convertCenters2edges(centers)
%Converts bin-centers to bin-edges

d = diff(centers)/2;
edges = [centers(1)-d(1), centers(1:end-1)+d, centers(end)+d(end)];
end

