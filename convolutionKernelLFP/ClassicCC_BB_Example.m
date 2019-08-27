%Classic correlation analysis: Cross Correlation for Binary - Binary signals
%Example of using the ComputeClassicCC_BB.dll library
%Author: Raul C. Muresan, 25.06.2007
%ATTENTION: The time stamps should be given in vectors in row format (values along the row, not along the column)

clear all;

%Some example values for the parameters
iTrialLength = 2000;        %Suppose we have a sampling frequency of 1 kHz. We choose a trial length of 2000 ms.
iCorrelationWindow = 100;   %We are interested in a cross correlogram of -100..100 ms.
iTrialNumber = 20;          %Suppose we have 20 trials
fFiringRate = 10;           %Suppose an average firing rate of 10 Hz => 20 Spikes per trial
iJitter = 5;                %Produce two example spike trains such that the second one is a jittered version of the first with this amount of uniform jitter


%Produce some random time stamps in the first neuron
iaTimeStampsNeuronA = sort(round(iTrialLength * iTrialNumber * rand(1,iTrialNumber * fFiringRate * iTrialLength / 1000)),'ascend');

%Produce another random spike stamps by jittering the one before; the larger the jitter the smaller the correlation
iaTimeStampsNeuronB = round(iaTimeStampsNeuronA + 2*iJitter*(0.5 - rand(size(iaTimeStampsNeuronA))));


%Compute the cross correlation on spikes
%The function expects 5 parameters:
% 	1. CorrelationWindow	- Integer Number; Scalar					- The size of the cross correlation window (eg. 80 for a cross correlation with lags of -80..+80); use the same units as the sampling of your time stamps
% 	2. TrialLength			- Integer Number; Scalar					- The size of the trial in sampling units
% 	3. TimeStampsA			- Vector of Integer Numbers: Time Stamps	- The vector holding the time stamps of the first neuron
% 	4. TimeStampsB			- Vector of Integer Numbers: Time Stamps	- The vector holding the time stamps of the second neuron
% 	5. Normalize			- Integer Number; Scalar					- Set to 1 if you want to normalize the correlogram or to 0 otherwise
%   ATTENTION: the function returns NaN (Not a Number) values if the input buffers are empty

CrossCorrelogram = ComputeClassicCC_BB(iCorrelationWindow,iTrialLength,iaTimeStampsNeuronA,iaTimeStampsNeuronB,0);

%Plot the classic cross-correlogram
x = -100:1:100;
bar(x,CrossCorrelogram,'r');