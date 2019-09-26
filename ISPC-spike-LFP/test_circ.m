r = -pi + (pi+pi)*rand(1e5,1);
p=polarhistogram(r,40);
binCounts = p.BinCounts;
binCenter = conv(p.BinEdges, [0.5 0.5], 'valid');
pval = circ_rtest((binCenter),binCounts, unique(diff(binCenter)))