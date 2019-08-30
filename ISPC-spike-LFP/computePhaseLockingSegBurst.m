function [ burstAngleDistro,  nonburstAngleDistro] = computePhaseLockingSegBurst ( peak_train, LFP_train, burst_train )
%for all the angles corresponding to non-zero values of peak train, the
%code extracts angle series using hilbert transform 
%Also seggregates burst and non-burst data

angleS = angle(hilbert(LFP_train));
total_phase_lag = sign(peak_train).*angleS;

burstAngleDistro = full(total_phase_lag(burst_train));
nonburstAngleDistro = full(total_phase_lag(not(burst_train)));

burstAngleDistro( burstAngleDistro==0) = [];
nonburstAngleDistro( nonburstAngleDistro==0) = [];

end

