%%EC-CA1
average_EC_CA1_tunnel=zeros(1,length(tunnel_channel_result{1,2}));
for i=1:5
    average_EC_CA1_tunnel=average_EC_CA1_tunnel+tunnel_channel_result{i,2};
end
average_EC_CA1_tunnel=average_EC_CA1_tunnel./5;
time = linspace(1,300,375);
figure(1)
plot(time,smooth(average_EC_CA1_tunnel))
set(gca,'fontsize',16)
xlabel('time(s)')
ylabel('ISPC(AU)')
title('ISPC between tunnel channel pairs of CA1-EC')
%%
%EC-DG
average_EC_CA1_tunnel=zeros(1,length(tunnel_channel_result{1,2}));
for i=6:10
    average_EC_CA1_tunnel=average_EC_CA1_tunnel+tunnel_channel_result{i,2};
end
average_EC_CA1_tunnel=average_EC_CA1_tunnel./5;
time = linspace(1,300,375);
figure(1)
plot(time,smooth(average_EC_CA1_tunnel))
set(gca,'fontsize',16)
xlabel('time(s)')
ylabel('ISPC(AU)')
title('ISPC between tunnel channel pairs of EC-DG')
