%%EC-CA1
subregions={1:13,14:26,27:39,40:52}; %CA1-EC, DG-CA3, EC-DG, CA3-CA1
average_pair=zeros(1,length(result_array{1,2}));
average_adj=zeros(1,length(result_array{1,2}));
n_pair=0;n_adj=0;
for i=subregions{4}
    
    if (not(strcmp(result_array{i,4},'pair')))
        average_adj=average_adj+result_array{i,2};
        n_adj=n_adj+1;
    else
        average_pair=average_pair+result_array{i,2};
        n_pair=n_pair+1;
    end
    
end
average_pair=average_pair./n_pair;
average_adj=average_adj./n_adj;

time = linspace(1,300,375);
figure(1)
plot(time,smooth(average_pair),time,smooth(average_adj))
set(gca,'fontsize',16)
legend('paired tunnels','adjacent tunnels')
xlabel('time(s)')
ylabel('ISPC(AU)')
title('ISPC between tunnels of CA3-CA1')

% %%
% average_pair=zeros(1,length(result_array{1,2}));
% 
% n_pair=0;
% for i=1:19
%     
%  
%         average_pair=average_pair+result_array{i,2};
%         
%     
%     n_pair=n_pair+1;
% end
% average_pair=average_pair./n_pair;
% 
% n_pair
% time = linspace(1,300,375);
% figure(1)
% % plot(time,smooth(y));
% plot(time,smooth(average_pair))
% set(gca,'fontsize',16)
% % legend('paired tunnels','adjacent tunnels')
% xlabel('time(s)')
% ylabel('ISPC(AU)')
% title('ISPC between neighboring wells of CA3')
% 
