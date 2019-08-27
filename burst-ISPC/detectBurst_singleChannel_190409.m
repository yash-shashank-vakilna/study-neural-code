function [ burst_detection,  burst_event, outburst_cell] = detectBurst_singleChannel_190409( peak_train, nspikes, ISImax, min_mbr )
%Detect burst in a single channel of peak trains
fs=25e3;
ISImaxsample=ISImax/1000*fs; % ISImax [sample]
burst_detection = 0;  burst_event=0; outburst_cell=0;
if sum(peak_train)>0
    timestamp=find(peak_train); % Vector with dimension [nx1]
    allisi  =[-sign(diff(timestamp)-ISImaxsample)];
    allisi(find(allisi==0))=1;  % If the difference is exactly ISImax, I have to accept the two spikes as part of the burst
    edgeup  =find(diff(allisi)>1)+1;  % Beginning of burst
    edgedown=find(diff(allisi)<-1)+1; % End of burst

    if ((length(edgedown)>=2) & (length(edgeup)>=2))
        barray_init=[];
        barray_end=[];

        if (edgedown(1)<edgeup(1))                    
            barray_init=[timestamp(1), timestamp(edgedown(1)), edgedown(1), ...
                (timestamp(edgedown(1))-timestamp(1))/fs];
            edgedown=edgedown(2:end);
        end

        if(edgeup(end)>edgedown(end))
            barray_end= [timestamp(edgeup(end)), timestamp(end), length(timestamp)-edgeup(end)+1, ...
                 (timestamp(end)-timestamp(edgeup(end)))/fs];
            edgeup=edgeup(1:end-1);
        end

        barray= [timestamp(edgeup), timestamp(edgedown), (edgedown-edgeup+1), ...
            (timestamp(edgedown)-timestamp(edgeup))/fs];      % [init end nspikes duration-sec]
        barray= [barray_init;barray;barray_end];
        burst_detection=barray(find(barray(:,3)>=nspikes),:); % Real burst statistics

        [r,c]=size(burst_detection);
        acq_time=fix(length(peak_train)/fs); % Acquisition time  [sec]
        mbr=r/(acq_time/60);                 % Mean Bursting Rate [bpm]
        clear  edgeup edgedown

        % THRESHOLD EVALUATION
        if (mbr>=min_mbr) % Save only if the criterion is met

            % OUTSIDE BURST Parameters
            %%%%%%%%%%%%%%%%%%%%%% !!!!!WARNING!!!!! %%%%%%%%%%%%%%%%%%%%%%
            tempburst= [(burst_detection(:,1)-1), (burst_detection(:,2)+1)];
            % There is no check here: the +1 and -1 could be
            % dangerous when indexing the peak_train vector
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            out_burst=reshape(tempburst',[],1);
            out_burst=[1;out_burst; length(peak_train)];
            out_burst= reshape(out_burst, 2, [])';
            [rlines, clines]=size(out_burst);                    
            outburst_cell= cell(rlines,7);

            for k=1:rlines
                outb_period=(out_burst(k,2)-out_burst(k,1))/fs; % duration [sec] of the non-burst period
                outbspikes= find(peak_train(out_burst(k,1):out_burst(k,2)));                        

                n_outbspikes=length(outbspikes);
                mfob=n_outbspikes/outb_period;       % Mean frequency in the non-burst period
                isi_outbspikes= diff(outbspikes)/fs; % ISI [sec] - for the spikes outside the bursts
                f_outbspikes =1./isi_outbspikes;     % frequency between two consecutive spikes outside the bursts

                outburst_cell{k,1}= out_burst(k,1);  % Init of the non-burst period
                outburst_cell{k,2}= out_burst(k,2);  % End of the non-burst period
                outburst_cell{k,3}= n_outbspikes;    % Number of spikes in the non-burst period
                outburst_cell{k,4}= mfob;            % Mean Frequency in the non-burst period
                outburst_cell{k,5}= outbspikes;      % Position of the spikes in the non-burst period
                outburst_cell{k,6}= isi_outbspikes;  % ISI of spikes in the non-burst period
                outburst_cell{k,7}= f_outbspikes;    % Frequency of the spikes in the non-burst period
            end                                        
            ave_mfob= mean(cell2mat(outburst_cell(:,4))); % Avearge frequency outside the burst - v1: all elements
            % ave_mfob= mean(nonzeros(cell2mat(outburst_cell(:,4)))); % Average frequency outside the burst - v2: only non zeros elements

            % INSIDE BURST Parameters
            binit= burst_detection(:,1); % Burst init [samples]
            burst_event =sparse(binit, ones(length(binit),1), peak_train(binit)); % Burst event
            bp= [diff(binit)/fs; 0];     % Burst Period [sec] - start-to-start
            ibi= [((burst_detection(2:end,1)- burst_detection(1:end-1,2))/fs); 0]; % Inter Burst Interval, IBI [sec] - end-to-start                    
            burst_detection=[burst_detection, ibi, bp];
%             lastrow=[acq_time, length(find(peak_train)), r, sum(burst_detection(:,3)), mbr, ave_mfob];

%             burst_detection=[burst_detection, ibi, bp; lastrow];
            % burst_detection=[init, end, nspikes, duration, ibi, bp;
            %  acquisition time, total spikes, total bursts, total burst spikes, mbr, average mfob]
%             burst_detection_cell{el,1}= burst_detection; % Update the cell array
%                     burst_event_cell{el,1}= burst_event;         % Update the cell array
%                     outburst_spikes_cell{el,1}= outburst_cell;   % Update the cell array
        end
    end
end
end
