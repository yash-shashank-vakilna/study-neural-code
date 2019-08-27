% cd '\\BREWERSERVER\Shared\Yash\Data library\Data 1\Sweep data\8sd\ECDGCA3CA1 19908 160518 160610 d22 5minspont0001\mat files_FilteredData\mat files_PeakDetectionMAT_PLP2ms_RP1ms\ptrain_mat files'
cd '\\BREWERSERVER\Shared\Yash\Data library\Data 1\Raw Data\ECDGCA3CA1 19908 160518 160610 d22 5minspont0001\mat files_FilteredData\mat files_PeakDetectionMAT_PLP2ms_RP1ms\ptrain_mat files'
load('ptrain_mat files_37.mat')
fs=25e3;
L7 = peak_train(1*fs:length(peak_train-fs));
ts = linspace(1,299,length(L7));
clear peak_train
load('ptrain_mat files_41.mat')
M7 = peak_train(1*fs:length(peak_train-fs));
figure(1)
subplot(211)
    plot(ts,L7)
    ylabel L7
    ylim([0 1])
    yticklabels([])
    set(gca,'FontSize',16)
subplot(212)
    plot(ts,M7)
    ylabel M7
    ylim([0 1])
    yticklabels([])
    set(gca,'FontSize',16)