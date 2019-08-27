fs =25e3;
ts = 0:1/fs:100;
sinw = sin(ts);
cosw = cos(ts);
angS = angle(hilbert(sinw))./(pi/180);
angC = angle(hilbert(cosw))./(pi/180);
figure(1)
p(1)=subplot(211);
plot(ts,sinw), ylabel('sine-wave')
set(gca, 'FontSize', 16)
grid on
title('Demonstrating 0 phase point')
p(2)=subplot(212);
plot(ts,angS),ylabel('angle-series-sine')
set(gca, 'FontSize', 16)
grid on
% p(3)=subplot(413);
% plot(ts,cosw), ylabel('cos-wave')
% grid on
% p(4)=subplot(414);
% plot(ts,angC), ylabel('angle-cos-wave')
% grid on
xlabel('Time (s)')
linkaxes(p,'x')
