function [CorrConnectivityMatrix,LagConnectivitymatrix] = computeXcorrConnectivityMatrice...
    (mea, iScaleSegmentSize, iCorrelationWindow, iTrialLength, fs)
%Computes connectivty matrix using max(Scaled Cross correlation) 


noChannels = length(mea.spike_data);
CorrConnectivityMatrix = zeros(noChannels);
LagConnectivitymatrix = CorrConnectivityMatrix;
lags=-iCorrelationWindow:1:iCorrelationWindow;
lags = lags.*(1e3/fs);                                          %converting to ms


for chani=1:noChannels
    for chanj=chani:noChannels
        if chani == chanj
            CorrConnectivityMatrix(chani, chanj) = 1;
            LagConnectivitymatrix(chani, chanj) = 0;
            continue
        end
        %format spike trains into appropritate inputs
        iChannelSpikes = find(mea.spike_data{chani})';                 
        jChannelSpikes = find(mea.spike_data{chanj})';
        %skipping if spike vector is empty
        if isempty(iChannelSpikes) || isempty(jChannelSpikes)
            continue;
        end
        %compute
        ReturnMatrix = ComputeScaledCC_BB...
            (iScaleSegmentSize,iCorrelationWindow,iTrialLength,iChannelSpikes,jChannelSpikes,0);
        disp("************"+"computed for chani= "+chani+" chanj= "+chanj+"************")
        cor = ReturnMatrix(1,:);
        if ((any(cor)))
            %populate connectivity matrices
            CorrConnectivityMatrix(chani, chanj) = max(cor);
            maxLagI = find (cor == max(cor));
            LagConnectivitymatrix(chani, chanj) = lags(maxLagI(1));
        else 
            % if no correlation exists , then NaN
            CorrConnectivityMatrix(chani, chanj) = NaN;
            LagConnectivitymatrix(chani, chanj) = NaN;
        end
    end
end

end

