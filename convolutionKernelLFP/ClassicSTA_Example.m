%Classic correlation analysis: Spike-Triggered Average (STA)
%Example of using the ComputeClassicSTA.dll library
%Author: Raul C. Muresan, 14.05.2007
%ATTENTION: If you supply the time stamps and the samples for a single trial, make sure that the time stamps are relative to the beginning of the trial
%The time stamps and samples should be given in vectors in row format (values along the row, not along the column)

clear all;

%Some example values for the parameters
iTrialLength = 2000;        %Suppose we have a sampling frequency of 1 kHz. We choose a trial length of 2000 ms.
iCorrelationWindow = 100;   %We are interested in a cross correlogram of -100..100 ms.
iTrialNumber = 20;          %Suppose we have 20 trials
fFiringRate = 10;           %Suppose an average firing rate of 10 Hz => 20 Spikes per trial

%Produce some random time stamps (spikes of the neuron)
iaTimeStampsNeuronA = sort(round(iTrialLength * iTrialNumber * rand(1,iTrialNumber * fFiringRate * iTrialLength / 1000)),'ascend');

%Produce an LFP
daLFPSamplesB = zeros(1,iTrialLength*iTrialNumber);
for i=1:iTrialLength*iTrialNumber;
    daLFPSamplesB(i) = sin(2*3.14/50*1000*i);
end
    

%Compute the spike triggered average
%The function expects 5 parameters:
% 	1. CorrelationWindow	- Integer Number; Scalar					- The size of the cross correlation window (eg. 80 for a cross correlation with lags of -80..+80); use the same units as the sampling of your time stamps
% 	2. TrialLength			- Integer Number; Scalar					- The size of the trial in sampling units
% 	3. TimeStampsA			- Vector of Integer Numbers: Time Stamps	- The vector holding the time stamps of the neuron
% 	4. SamplesB				- Vector of Double Numbers: Samples			- The vector holding the samples of the continuous signal
% 	5. Normalize			- Integer Number; Scalar					- Set to 1 if you want to normalize the correlogram or to 0 otherwise
%   ATTENTION: the function returns NaN (Not a Number) values if there is no matching time stamp of events in the binary signal with the continuous samples (that start at time t=0!!)

STA = ComputeClassicSTA(iCorrelationWindow,iTrialLength,iaTimeStampsNeuronA,daLFPSamplesB,1);

%Plot the classic STA correlogram
x = -100:1:100;
bar(x,STA,'r');