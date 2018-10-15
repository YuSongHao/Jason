%% ģ���������ݷֲ���10%����
%  
%  author:YuSongHao
%  Date:2018.10.09
% 
%% ���ݷּ�
clear;clc;
dir = 'H:\�о����γ�����\�豸�������ܼ�⼼��\����ҵ�õĺ���';
cd(dir);
load('NorPulse.mat');
NorPulse = NorPulse(:,67:end);%084251���ݷ���
[Nrow,Ncal] = size(NorPulse);
NorPulse = NorPulse(:,randperm(Ncal));
initalNormalData = NorPulse(:,1:floor(Ncal/10));% 10%
incrementalNormalData1 = NorPulse(:,floor(Ncal/10)+1:floor(Ncal/10)*2);
incrementalNormalData2 = NorPulse(:,floor(Ncal/10)*2+1:floor(Ncal/10)*3);
incrementalNormalData3 = NorPulse(:,floor(Ncal/10)*3+1:floor(Ncal/10)*4);
incrementalNormalData4 = NorPulse(:,floor(Ncal/10)*4+1:floor(Ncal/10)*5);
incrementalNormalData5 = NorPulse(:,floor(Ncal/10)*5+1:floor(Ncal/10)*6);
incrementalNormalData6 = NorPulse(:,floor(Ncal/10)*6+1:floor(Ncal/10)*7);
incrementalNormalData7 = NorPulse(:,floor(Ncal/10)*7+1:floor(Ncal/10)*8);
incrementalNormalData8 = NorPulse(:,floor(Ncal/10)*8+1:floor(Ncal/10)*9);
incrementalNormalData9 = NorPulse(:,floor(Ncal/10)*9+1:floor(Ncal/10)*10);
load('FauPulse.mat');
[Frow,Fcal] = size(FauPulse);
FauPulse = FauPulse(:,randperm(Fcal));
initalFaultData = FauPulse(:,1:floor(Fcal/10));% ��ʼ10%������10% 
incrementalFaultData1 = FauPulse(:,floor(Fcal/10)+1:floor(Fcal/10)*2);
incrementalFaultData2 = FauPulse(:,floor(Fcal/10)*2+1:floor(Fcal/10)*3);
incrementalFaultData3 = FauPulse(:,floor(Fcal/10)*3+1:floor(Fcal/10)*4);
incrementalFaultData4 = FauPulse(:,floor(Fcal/10)*4+1:floor(Fcal/10)*5);
incrementalFaultData5 = FauPulse(:,floor(Fcal/10)*5+1:floor(Fcal/10)*6);
incrementalFaultData6 = FauPulse(:,floor(Fcal/10)*6+1:floor(Fcal/10)*7);
incrementalFaultData7 = FauPulse(:,floor(Fcal/10)*7+1:floor(Fcal/10)*8);
incrementalFaultData8 = FauPulse(:,floor(Fcal/10)*8+1:floor(Fcal/10)*9);
incrementalFaultData9 = FauPulse(:,floor(Fcal/10)*9+1:floor(Fcal/10)*10);
% ��ʼѵ��
SampleGroup = [initalNormalData,initalFaultData];
[Srow,Scal] = size(SampleGroup);
feature = zeros(Scal,8);
energy = zeros(Scal,8);
for i =1:Scal
    pulseTemp = SampleGroup(:,i);
    wpt = wavelet_packetdecomposition_reconstruct(pulseTemp,5,'haar');
    E = wavelet_energy_spectrum(wpt,5);
    E = wenergy(wpt);
    energy(i,:) = [E(4),E(3),E(8),E(7),E(5),E(6),E(16),E(15)];%��������˳��������򣬵õ�2-10K����8��Ƶ��
%     energy(i,:) = E(1,3:10);%����Ĭ��˳���������
%     wpt = wavelet_packetdecomposition_reconstruct(pulseTemp,3,'haar');
%     E = wavelet_energy_spectrum(wpt,3);
%     energy(i,:) = E(1,2:4);
    feature(i,:) = energy(i,:)/sum(energy(i,:));
end
[Frow,Fcal] = size(feature);
maxVector = [];
minVector = [];
for i = 1:Fcal
    maxValue = max(feature(:,i));
    minValue = min(feature(:,i));
    feature(:,i) = (feature(:,i)-minValue)/(maxValue-minValue);
    maxVector = [maxVector,maxValue];
    minVector = [minVector,minValue];
end
centerF = mean(feature);
feature = feature-centerF;
[coeff,later,com] = pca(feature);
featureAfterOptim = later(:,1:3);
% �������ӻ�
figure;
scatter3(featureAfterOptim(1:51,1),featureAfterOptim(1:51,2),featureAfterOptim(1:51,3),'bo');
hold on 
scatter3(featureAfterOptim(52:end,1),featureAfterOptim(52:end,2),featureAfterOptim(52:end,3),'ro');
xlabel('���ɷ�1');
ylabel('���ɷ�2');
zlabel('���ɷ�3');
legend('��������','��������');
grid on;
% ͬһ�糡����-��������ģ��
[NormalData,FaultData] = incrementalTrain(initalNormalData,initalFaultData,incrementalNormalData1,incrementalFaultData1,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData2,incrementalFaultData2,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData3,incrementalFaultData3,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData4,incrementalFaultData4,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData5,incrementalFaultData5,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData6,incrementalFaultData6,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData7,incrementalFaultData7,coeff,maxVector,minVector,centerF);
[NormalData,FaultData] = incrementalTrain(NormalData,FaultData,incrementalNormalData8,incrementalFaultData8,coeff,maxVector,minVector,centerF);
[NormalData,FaultData,Feature] = incrementalTrain(NormalData,FaultData,incrementalNormalData9,incrementalFaultData9,coeff,maxVector,minVector,centerF);
% ģ��SVDD����ѵ��
% �������ݷּ� 10%����
NorFea1 = Feature(1:51,:);NorFeatotal1 = Feature(1:51,:);
NorFea2 = Feature(52:102,:);NorFeatotal2 = Feature(1:102,:);
NorFea3 = Feature(103:153,:);NorFeatotal3 = Feature(1:153,:);
NorFea4 = Feature(154:204,:);NorFeatotal4 = Feature(1:204,:);
NorFea5 = Feature(205:255,:);NorFeatotal5 = Feature(1:255,:);
NorFea6 = Feature(256:306,:);NorFeatotal6 = Feature(1:306,:);
NorFea7 = Feature(307:357,:);NorFeatotal7 = Feature(1:357,:);
NorFea8 = Feature(358:408,:);NorFeatotal8 = Feature(1:408,:);
NorFea9 = Feature(409:459,:);NorFeatotal9 = Feature(1:459,:);
NorFea10 = Feature(460:510,:);NorFeatotal10 = Feature(1:510,:);
% ����Ͷ������ѵ��
trainlabel1 = ones(length(NorFeatotal1),1);
Model1 = svmtrain(trainlabel1,NorFeatotal1,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel1,NorFeatotal1,Model1);

trainlabel2 = ones(length(NorFeatotal2),1);
Model2 = svmtrain(trainlabel2,NorFeatotal2,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel2,NorFeatotal2,Model2);

trainlabel3 = ones(length(NorFeatotal3),1);
Model3 = svmtrain(trainlabel3,NorFeatotal3,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel3,NorFeatotal3,Model3);

trainlabel4 = ones(length(NorFeatotal4),1);
Model4 = svmtrain(trainlabel4,NorFeatotal4,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel4,NorFeatotal4,Model4);

trainlabel5 = ones(length(NorFeatotal5),1);
Model5 = svmtrain(trainlabel5,NorFeatotal5,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel5,NorFeatotal5,Model5);

trainlabel6 = ones(length(NorFeatotal6),1);
Model6 = svmtrain(trainlabel6,NorFeatotal6,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel6,NorFeatotal6,Model6);

trainlabel7 = ones(length(NorFeatotal7),1);
Model7 = svmtrain(trainlabel7,NorFeatotal7,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel7,NorFeatotal7,Model7);

trainlabel8 = ones(length(NorFeatotal8),1);
Model8 = svmtrain(trainlabel8,NorFeatotal8,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel8,NorFeatotal8,Model8);

trainlabel9 = ones(length(NorFeatotal9),1);
Model9 = svmtrain(trainlabel9,NorFeatotal9,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel9,NorFeatotal9,Model9);

trainlabel10 = ones(length(NorFeatotal10),1);
Model10 = svmtrain(trainlabel10,NorFeatotal10,'-s 5 -t 2 -g 1 -c 0.1');
svmpredict(trainlabel10,NorFeatotal10,Model10);
% �������ݷּ� 10%����
FauFea1 = Feature(511:522,:);
FauFea2 = Feature(523:534,:);
FauFea3 = Feature(535:546,:);
FauFea4 = Feature(547:558,:);
FauFea5 = Feature(559:570,:);
FauFea6 = Feature(571:582,:);
FauFea7 = Feature(583:594,:);
FauFea8 = Feature(595:606,:);
FauFea9 = Feature(607:618,:);
FauFea10 =Feature(619:630,:);

% ���ݲ���
load('Pulse084251.mat');
% [NormalData,FaultData,Feature] = incrementalTrain(NormalData,FaultData,Pulse,FauPulse(:,121:end),coeff,maxVector,minVector,centerF);
testdata = Feature(1:510,:);
% testdata = Feature(511:576,:);
% testdata = Feature(577:684,:);
% testdata = Feature(685:792,:);
% % testdata = Feature(793:end,:);
testlabel = zeros(length(testdata),1);
% svmpredict(testlabel,testdata,Model1);
% svmpredict(testlabel,testdata,Model2);
% svmpredict(testlabel,testdata,Model3);
% svmpredict(testlabel,testdata,Model4);
% svmpredict(testlabel,testdata,Model5);
% svmpredict(testlabel,testdata,Model6);
% svmpredict(testlabel,testdata,Model7);
% svmpredict(testlabel,testdata,Model8);
% svmpredict(testlabel,testdata,Model9);
[predict_label,accuracy,decision_values] = svmpredict(testlabel,testdata,Model10);

%% ��ͬ�糡���ݣ�������������ģ��
% ����084251
% load('Pulse084251.mat');
% [NormalData,FaultData,Feature] = incrementalTrain(NormalData,FaultData,Pulse,FauPulse(:,121:end),coeff,maxVector,minVector,centerF);
% [NormalData,FaultData,Feature] = incrementalTrainNormal(NormalData,FaultData,Pulse,coeff,maxVector,minVector,centerF);
% figure;
% scatter3(Feature(1:510,1),Feature(1:510,2),Feature(1:510,3),'bo');
% hold on 
% scatter3(Feature(511:576,1),Feature(511:576,2),Feature(511:576,3),'go');
% scatter3(Feature(577:end,1),Feature(577:end,2),Feature(577:end,3),'ro');
% xlabel('���ɷ�1');
% ylabel('���ɷ�2');
% zlabel('���ɷ�3');
% grid on
% hold off
%% ͬһ�糡��ˮ������ģ��
%  Psk����109��
% load('PskPulse.mat');
% [NormalData,FaultData,Feature] = incrementalTrainNormal(NormalData,FaultData,PskPulse,coeff,maxVector,minVector,centerF);
% figure;
% scatter3(Feature(1:684,1),Feature(1:684,2),Feature(1:684,3),'bo');
% hold on 
% scatter3(Feature(685:793,1),Feature(685:793,2),Feature(685:793,3),'yo');
% scatter3(Feature(794:end,1),Feature(794:end,2),Feature(794:end,3),'ro');
% xlabel('���ɷ�1');
% ylabel('���ɷ�2');
% zlabel('���ɷ�3');
% legend('��������','��ˮ������','��������');
% grid on
% hold off

%% ��������ɽ ����������������
load('Pulse163937.mat');%108��
% [NormalData,FaultData,Feature] = incrementalTrain(NormalData,FaultData,Pulse,coeff,maxVector,minVector,centerF);
[NormalData,FaultData,Feature] = incrementalTrainNormal(NormalData,FaultData,Pulse,coeff,maxVector,minVector,centerF);
figure;
scatter3(Feature(1:576,1),Feature(1:576,2),Feature(1:576,3),'bo');
hold on 
scatter3(Feature(577:684,1),Feature(577:684,2),Feature(577:684,3),'ko');
scatter3(Feature(685:end,1),Feature(685:end,2),Feature(685:end,3),'ro');
xlabel('���ɷ�1');
ylabel('���ɷ�2');
zlabel('���ɷ�3');
grid on
hold off

%% Ϋ�������糡3.0 ����������������
load('NormalPulse30.mat');
[NormalData,FaultData,Feature] = incrementalTrainNormal(NormalData,FaultData,Pulse,coeff,maxVector,minVector,centerF);
figure;
scatter3(Feature(1:684,1),Feature(1:684,2),Feature(1:684,3),'bo');
hold on 
scatter3(Feature(685:875,1),Feature(685:875,2),Feature(685:875,3),'ko');
scatter3(Feature(876:end,1),Feature(876:end,2),Feature(876:end,3),'ro');
xlabel('���ɷ�1');
ylabel('���ɷ�2');
zlabel('���ɷ�3');
grid on
hold off
%% Ϋ�������糡3.0 ��ˮ����������
load('Pulse111650.mat');
[NormalData,FaultData,Feature] = incrementalTrainNormal(NormalData,FaultData,Pulse,coeff,maxVector,minVector,centerF);
figure;
scatter3(Feature(1:875,1),Feature(1:875,2),Feature(1:875,3),'bo');
hold on 
scatter3(Feature(876:905,1),Feature(876:905,2),Feature(876:905,3),'ko');
scatter3(Feature(906:end,1),Feature(906:end,2),Feature(906:end,3),'ro');
xlabel('���ɷ�1');
ylabel('���ɷ�2');
zlabel('���ɷ�3');
grid on
hold off
