function [ fig ] = computeLogScalogram( x, figno )
%Creates log CWT scalogram with raw data on the top subplot
%   x is spike cutout
ts =0:1/25e3:2;
fig = figure(figno); clf
%plot raw data
p(1)=subplot(211);
plot(ts, x)
% title("subregion:"+subName+" channel:" + chanName +" Spike number:"+ Spiki)
ylabel("Voltage (s.d.u)")
set(gca,'FontSize', 16)
hold on 
% plot CWT - morelet
p(2)=subplot(212);
    
cwt(x,'amor',25e3)
D = cwt(x,'amor',25e3);
imageobj = imhandles(gca);
imageobj.CData = log10(abs(D));
L = [0.001 0.01 0.05 0.1 0.3];
l = log10(L);
hC = colorbar;
% Choose appropriate
% or somehow auto generate colorbar labels
set(hC,'Ytick',l,'YTicklabel',L);
AX = gca;
freq = log2([4 11 30 140 300].*1e-3);
AX.YLabel.String = "Frequency (Hz)";
AX.YTick = freq;
AX.YLim = [-inf log2(300e-3)];
AX.YTickLabel = ["4","11","30","140","300"];

set(gca,'FontSize', 16,'CLim',[l(1) l(end)])
linkaxes(p,'x');
hold off


end

