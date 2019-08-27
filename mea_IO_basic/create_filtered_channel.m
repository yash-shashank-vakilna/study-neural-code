fs=25e3;
band_Filt_4_11 = designfilt('bandpassiir','FilterOrder',20, ...
    'PassbandFrequency1',4,'PassbandFrequency2',11, ...
    'PassbandRipple',3, ...
    'StopbandAttenuation1',40,'StopbandAttenuation2',40, ...
    'SampleRate',fs);

% mea_EC.theta_filtered_signal=cell(1,length(mea_EC.raw_data));
% for chani=1%:length(mea_EC.raw_data)
%     mea_EC.theta_filtered_signal{chani}=filtfilt(band_Filt_4_11,mea_EC.raw_data{chani});
% end
%%
figure(1)

data=mea.raw_data{1}(1:60*25e3);
t_raw=linspace(0,60,length(data));
ax(1)=subplot(311);
plot(t_raw, data)
ylim([-12 12])
ylabel('raw data')
set(gca,'FontSize',16)

data_iir=filtfilt(band_Filt_4_11,data);
t_iir=linspace(0,60,length(data_iir));
ax(2)=subplot(312);
plot(t_iir,data_iir*1e2)
ylabel('IIR filter')
set(gca,'FontSize',16)
ylim([-1 1]);
ax(3)=subplot(313);

data_fir=filtered_mea.filtered_data{1}(1:60*mea.par.down_fs);
t_fir = linspace(0,60,length(data_fir));
plot(t_fir,data_fir*1e3)
ylim([-1.2 1.2])
ylabel('FIR filter')
linkaxes(ax,'x')
xlim([0 3])
set(gca,'FontSize',16)