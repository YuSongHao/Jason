%% SVDD����ʵ��
%  author:YuSongHao
%  2018.05.10
clear;clc;
%% ���ݴ洢����һ��
load('pca_normal.mat');
zhuchengfen1 = pca_normal(:,1);
zhuchengfen2 = pca_normal(:,2);
zhuchengfen1 = (zhuchengfen1 - min(zhuchengfen1))/(max(zhuchengfen1)-min(zhuchengfen1));
zhuchengfen2 = (zhuchengfen2 - min(zhuchengfen2))/(max(zhuchengfen2)-min(zhuchengfen2));
PcaNormal = [zhuchengfen1,zhuchengfen2];
% scatter(PcaNormal(:,1),PcaNormal(:,2));
%% SVDDģ��ѵ��
Length = length(PcaNormal);
TrainDataPrecent = 0.8;
TestDataPrecent = 0.2;
TrainLabel = ones(Length * TrainDataPrecent,1);
TestLabel = ones(Length * TestDataPrecent,1);
TrainData = PcaNormal(1:TrainDataPrecent * Length,:);
TestData = PcaNormal(TrainDataPrecent * Length+1:end,:);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 2 -g 8 -c 1');%RBF
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 1 ');%���Ժ�
svmplot(TrainLabel,TrainData,Model);
Model = svmtrain(TrainLabel,TrainData,'-s 5 -t 3');%sigmoid��
svmplot(TrainLabel,TrainData,Model);
% [reslabel,accuracy] = svmpredict(TestLabel,TestData,Model);