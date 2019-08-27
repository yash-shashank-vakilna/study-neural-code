% burstDetection.m
% Single-channel burst detection
% INPUT:
% peakTrain     =   sparse array (size: [numberOfSamples x 1]) whose non-zero elements
%                   represent the detected spikes
% sf            =   sampling frequency (Hz)
% ISIth         =   ISI threshold as extracted by the logISIH (ms)
% minNumSpikes  =   minimum number of spikes in a burst
% OUTPUT:
% burstTrain    =  matrix (size: [N x 4], N: number of detected bursts) containing:
%                  [sample number of first spike, sample number of last spike, number of
%                           spikes, burst duration in s]
function [burstTrain] = detectBurst_190409(peakTrain, sf, ISIth, minNumSpikes)
th = 100; % [ms]
if ISIth > th       % if ISIth > 100 ms
    maxISI1 = round(th/1000*sf);        % 100 ms
    maxISI2 = round(ISIth/1000*sf);     % ISIth
    flag = 1;
else                % if ISIth < 100 ms
    maxISI1 = round(ISIth/1000*sf);     % ISIth
    flag = 0;
end
timestamp = find(peakTrain);
if ~isempty(timestamp)      % if there is at least one spike
    allisi2 = [0;diff(timestamp) <= maxISI1;0];      % ISI <= maxISI1
    edges2 = diff(allisi2);                          % edges of burst cores: beginning & end
    % edgeup2 & edgedown2 contain the indexes of timestamps that correspond
    % to the beginning and to the end of burst cores respectively (detected
    % with the more restrictive threshold, i.e. maxISI1)
    edgeup2 = find(edges2 == 1);
    edgedown2 = find(edges2 == -1);
    if ((length(edgedown2)>=1) && (length(edgeup2)>=1))    % if there is at least 1 burst core
        numSpikesInBurst = (edgedown2-edgeup2+1);
        validBursts = numSpikesInBurst >= minNumSpikes;
        % if there is at least one VALID burst (i.e. whose number of spikes
        % exceeds the threshold)
        if ~isempty(validBursts)
            edgeup2 = edgeup2(validBursts);
            edgedown2 = edgedown2(validBursts);
            if flag
                tsEdgeup2 = timestamp(edgeup2);
                tsEdgedown2 = timestamp(edgedown2);
                tempIBI = tsEdgeup2(2:end)-tsEdgedown2(1:end-1);
                % if 2 burst cores are separated by less than maxISI2, they
                % are joined
                burst2join = tempIBI<=maxISI2;
                if any(burst2join)
                    edgeup2(find(burst2join)+1)=[];
                    edgedown2(burst2join)=[];
                end
                allisi1 = [0;diff(timestamp)<=maxISI2;0];   % ISI <= maxISI2
                edges1 = diff(allisi1);                     % edges of bursts: beginning & end
                % edgeup1 & edgedown1 contain the indexes of timestamps
                % that correspond to the beginning and to the end of bursts
                % respectively (detected with the largest threshold, i.e. maxISI2)
                edgeup1 = find(edges1 == 1);
                edgedown1 = find(edges1 == -1);
                % %%%%%%
                % we build a matrix allEdgeSort (size: [n x 3], n = number of edges) containing all edges of
                % the 2 burst train, obtained with two different thresholds (i.e. maxISI1 & maxISI2)
                % allEdgeSort = [timestamp    type of edge    burst train
                %                   ...             ...             ...    ]    
                % where:    timestamp: timestamp of edge
                %           type of edge: 1 rising, -1 falling
                %           burst train: 1 maxISI2, 2 maxISI1
                allEdgeUp1 = [timestamp(edgeup1) ones(length(edgeup1),1) 1*ones(length(edgeup1),1)];
                allEdgeDown1 = [timestamp(edgedown1) -1*ones(length(edgedown1),1) 1*ones(length(edgeup1),1)];
                allEdge1 = [allEdgeUp1;allEdgeDown1];
                % %%%%%%
                allEdgeUp2 = [timestamp(edgeup2) ones(length(edgeup2),1) 2*ones(length(edgeup2),1)];
                allEdgeDown2 = [timestamp(edgedown2) -1*ones(length(edgedown2),1) 2*ones(length(edgeup2),1)];
                allEdge2 = [allEdgeUp2;allEdgeDown2];
                % %%%%%%
                allEdge = [allEdge1; allEdge2];
                allEdgeSort = sortrows(allEdge,1);
                % %%%%%%
                % burstBegin: rising edge of maxISI2 train
                burstBegin = find(allEdgeSort(:,2)==1 & allEdgeSort(:,3)==1);
                b = 0;
                for ii = 1:length(burstBegin)   % for each element of burstBegin
                    % if the following edge is a falling edge of maxISI2 train -->
                    % no burst is detected
                    if (allEdgeSort(burstBegin(ii)+1,2)==-1 && allEdgeSort(burstBegin(ii)+1,3)==1)
                        continue
                    else
                        % we look for next falling edge of large ISIth -->
                        % thisBurstEnd
                        thisBurstEnd = find(allEdgeSort(burstBegin(ii):end,2)==-1 & allEdgeSort(burstBegin(ii):end,3)==1,1);
                        thisBurstEnd = thisBurstEnd+burstBegin(ii)-1;
                        % inside window [burstBegin(ii),thisBurstEnd], we
                        % look for rising edge of maxISI1 train
                        subBurstBegin = find(allEdgeSort(burstBegin(ii):thisBurstEnd,2)==1 & allEdgeSort(burstBegin(ii):thisBurstEnd,3)==2);
                        subBurstBegin = subBurstBegin+burstBegin(ii)-1;
                        % if there's more than one rising edge of maxISI1
                        % train inside that window --> we should separate
                        % the corresponding bursts
                        if length(subBurstBegin)>1
                            subBurstBegin = [burstBegin(ii);subBurstBegin(2:end)];
                            subBurstEnd = [subBurstBegin(2:end);thisBurstEnd];
                            for jj = 1:length(subBurstBegin)
                                b = b+1;
                                timestampBegin = allEdgeSort(subBurstBegin(jj),1);
                                tempTimestampEnd = allEdgeSort(subBurstEnd(jj),1);
                                if jj ~= length(subBurstBegin)
                                    spks = find(peakTrain(timestampBegin:tempTimestampEnd-1));
                                else
                                    spks = find(peakTrain(timestampBegin:tempTimestampEnd));
                                end
                                timestampEnd = timestampBegin+spks(end)-1;
                                numSpikesThisBurst = length(spks);
                                duration_s = (timestampEnd-timestampBegin)./sf;
                                burstTrain(b,:) = [timestampBegin timestampEnd numSpikesThisBurst duration_s];
                            end
                        else
                            b = b+1;
                            timestampBegin = allEdgeSort(burstBegin(ii),1);
                            timestampEnd = allEdgeSort(thisBurstEnd,1);
                            numSpikesThisBurst = sum(spones(peakTrain(timestampBegin:timestampEnd)));
                            duration_s = (timestampEnd-timestampBegin)./sf;
                            burstTrain(b,:) = [timestampBegin timestampEnd numSpikesThisBurst duration_s];
                        end
                    end
                end
            else
                % timestamps of edges (up&down)
                tsEdgeup2 = timestamp(edgeup2);
                tsEdgedown2 = timestamp(edgedown2);
                burstTrain = [tsEdgeup2, tsEdgedown2, (edgeup2-edgedown2+1), ...
                    (tsEdgedown2-tsEdgeup2)/sf];
            end
            burstTrain = full(burstTrain);
        else
            burstTrain = [];
        end
    else
        burstTrain = [];
    end
else
    burstTrain = [];
end