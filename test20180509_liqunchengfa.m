clear;clc;
Fs = 64000;
t = 2048/Fs;
Ft = load('ft_1.mat');
Ft = Ft.ft;
z_count = [];
q_count = [];
%% --故障脉冲可视化--
for i = 1:5
eval(['load ' 'Pulse' num2str(i) '.mat']);
PulseLength = length(Pulse);
TimeAxePulse = 0:t:t*(PulseLength-1);
% figure(i);
%% 离群惩罚
PulseDiff = diff(Pulse);
DisThreshold = 1000;%离群阈值设为130Hz
for Differ = 1:length(PulseDiff)
    if abs(PulseDiff(1,Differ)) >= DisThreshold
        Pulse(1,Differ+1) = Pulse(1,Differ) + sign(PulseDiff(1,Differ)) * 10;%惩罚量设为变化方向上10Hz
        Differ = 1;
        PulseDiff = diff(Pulse);   
    end
end
order = 3;
d_fitting = polyfit(TimeAxePulse,Pulse,order); 
ft = polyval(d_fitting,TimeAxePulse); 
scatter(TimeAxePulse,Pulse,'r');
hold on
plot(TimeAxePulse,ft,'color','r','linewidth',4);
xlabel('Time/S');
ylabel('Frequency/Hz');
ylim([2000 3000]);
hold off
ft = ft(1,1:length(Ft));
Pulse = Pulse(1,1:length(Ft));
Z = corrcoef(Ft,ft);
Q = corrcoef(Ft,Pulse);
z = Z(1,2);
q = Q(1,2);
z_count = [z_count,q];
q_count = [q_count,q];
end 
% %% 正常脉冲
% for i = 1:10
% eval(['load ' 'NormalPulse' num2str(i) '.mat']);
% PulseLength = length(NormalPulse);
% TimeAxePulse = 0:t:t*(PulseLength-1);
% figure(i);
% % %% 离群惩罚
% PulseDiff = diff(NormalPulse);
% DisThreshold = 1000;%离群阈值设为1000Hz
% for Differ = 1:length(PulseDiff)
%     if abs(PulseDiff(1,Differ)) >= DisThreshold
%         NormalPulse(1,Differ+1) = NormalPulse(1,Differ) + sign(PulseDiff(1,Differ)) * 10;%惩罚量设为变化方向上10Hz
%         Differ = 1;
%         PulseDiff = diff(NormalPulse);   
%     end
% end
% order = 3;
% d_fitting = polyfit(TimeAxePulse,NormalPulse,order); 
% ft = polyval(d_fitting,TimeAxePulse); 
% % scatter(TimeAxePulse,NormalPulse,'r');
% % hold on
% % plot(TimeAxePulse,ft,'color',[0,0.49,0.79],'linewidth',4);
% % xlabel('Time/S');
% % ylabel('Frequency/Hz');
% % ylim([2000 3000]);
% % hold off
% ft = ft(1,1:length(Ft));
% NormalPulse = NormalPulse(1,1:length(Ft));
% Z = corrcoef(Ft,NormalPulse);
% z = Z(1,2);
% z_count = [z_count,z];
% end 
% Z_count = [z_count(1),z_count(6),z_count(7),z_count(2),z_count(8),z_count(9),z_count(3),z_count(10),z_count(11),z_count(4),z_count(12),z_count(13),z_count(5),z_count(14),z_count(15)];





