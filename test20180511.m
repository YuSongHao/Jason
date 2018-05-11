%% SVDD仿真实验
%  author:YuSongHao
%  2018.05.11
clear;clc;
%% 数据存储及归一化
load('pca_normal.mat');
zhuchengfen1 = pca_normal(:,1);
zhuchengfen2 = pca_normal(:,2);
zhuchengfen1 = (zhuchengfen1 - min(zhuchengfen1))/(max(zhuchengfen1)-min(zhuchengfen1));
zhuchengfen2 = (zhuchengfen2 - min(zhuchengfen2))/(max(zhuchengfen2)-min(zhuchengfen2));
PcaNormal = [zhuchengfen1,zhuchengfen2];
% scatter(PcaNormal(:,1),PcaNormal(:,2));
%% SVDD模型训练
Length = length(PcaNormal);
TrainDataPrecent = 0.8;
TestDataPrecent = 0.2;
TrainLabel = ones(Length * TrainDataPrecent,1);
TestLabel = ones(Length * TestDataPrecent,1);
TrainData = PcaNormal(1:TrainDataPrecent * Length,:);
TestData = PcaNormal(TrainDataPrecent * Length+1:end,:);
%% 核函数选择
figure(1)%画图例
scatter(TrainData(:,1),TrainData(:,2),'b');
hold on
x = 0:0.1:1;
y = 0:0.2:2;
z = 0:0.3:3;
s = 0:0.4:4;
plot(x,'b','linewidth',1.5);
plot(y,'r','linewidth',1.5);
plot(z,'y','linewidth',1.5);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 1 -d 3');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 0');%RBF
svmplot(TrainLabel,TrainData,Model);

%% 核宽度参数选择
% sigma = [0.1,0.25,0.5,1];
% g = 1./(2*power(sigma,2));
% g1 = 0.005;
% s = sqrt(0.5/g1);
figure(2);
scatter(TrainData(:,1),TrainData(:,2),'b');
hold on
plot(x,'b','linewidth',1.5);
plot(y,'r','linewidth',1.5);
plot(z,'y','linewidth',1.5);
plot(s,'black','linewidth',1.5);

figure(2);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 50 -c 0.1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 0.1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.5 -c 0.1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.005 -c 0.1');%RBF
svmplot(TrainLabel,TrainData,Model);
%% 惩罚因子C选择
figure(3)
scatter(TrainData(:,1),TrainData(:,2),'b');
hold on
plot(x,'b','linewidth',1.5);
plot(y,'r','linewidth',1.5);
plot(z,'y','linewidth',1.5);
plot(s,'black','linewidth',1.5);
figure(4)
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 0.1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 0.05');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 0.01');%RBF
svmplot(TrainLabel,TrainData,Model);
%% σ和C对支持向量个数的影响
sigma = 0.005:0.05:1;
gamma = 0.5./power(sigma,2);
nsv_c4 = [];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 20000 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 165.29 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 45.35 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 20.81 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 11.90 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 7.69 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 5.38 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 3.97 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 3.05 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 2.42 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 1.96 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 1.62 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 1.37 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 1.17 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 1.01 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.88 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.77 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.68 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.61 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 0.55 -c 0.8');
nsv_c4 = [nsv_c4,Model.totalSV];

nsv = nsv_c4;
save nsv_c4.mat nsv 

