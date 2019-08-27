function [ fig ] = computeCWTscalogram( x, subName, chanName, Spiki, figno)
%Creates CWT scalogram with raw data on the top subplot
%   x is spike cutout
ts =0:1/25e3:2;
fig = figure(figno); clf
%plot raw data
p(1)=subplot(211);
plot(ts, x)
title("subregion:"+subName+" channel:" + chanName +" Spike number:"+ Spiki)
ylabel("Voltage (s.d.u)")
set(gca,'FontSize', 16)
hold on 
% plot CWT - morelet
p(2)=subplot(212);
    
cwt(x,'amor',25e3)
AX = gca;
AX.CLim = [0.1 0.3];
freq = log2([4 11 30 140 300].*1e-3);
AX.YLabel.String = "Frequency (Hz)";
AX.YTick = freq;
AX.YLim = [-inf log2(300e-3)];
AX.YTickLabel = ["4","11","30","140","300"];

set(gca,'FontSize', 16)
linkaxes(p,'x');
colorbar off    
hold off


end

