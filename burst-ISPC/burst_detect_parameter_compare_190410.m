load \\BREWERSERVER\Shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\mea_tunnels.mat
nspikes=4;ISImax=50;min_mbr=0.4; 
data = mea.peak_train{1};
clear mea

[ burst_detection,  burst_event, outburst_cell] = detectBurst_singleChannel_190409(data, nspikes, ISImax, min_mbr );

n_bursts = length(burst_detection);
sf = 25e3; ts =1/sf:1/sf:300;
figure(2)
plot(ts,data./100)
hold on
burst_seg = [];
for buri = 1:n_bursts
    burst_seg =  [ (burst_detection(buri,1):burst_detection(buri,2))./sf];
    line(burst_seg, -10*ones(length(burst_seg),1),'col','r','linewidth',3)
end
xlabel('Time (s)'); ylabel('Amplitude (\mu V)');
set(gca,'FontSize',16)

%%
nspikes=10;ISImax=100;min_mbr=0.4; 
[ burst_detection,  ~, ~] = detectBurst_singleChannel_190409(data, nspikes, ISImax, min_mbr );
n_bursts = length(burst_detection);

hold on
burst_seg = [];
for buri = 1:n_bursts
    burst_seg =  [ (burst_detection(buri,1):burst_detection(buri,2))./sf];
    line(burst_seg, -1000*ones(length(burst_seg),1),'col','g','linewidth',3)
end