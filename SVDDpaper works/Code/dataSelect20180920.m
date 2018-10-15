clear;clc;
%%1KHz低通滤波版本
Fs = 64000;
SampleLength = Fs*1;
d = fdesign.bandpass('N,F3dB1,F3dB2', 8,1000,32000, Fs);%带通滤波
Hd = design(d,'butter');
load('NorPulse.mat');
NorPulse = [];

load('Kangbao_2.0MW_084251_Normal.mat');
% data = filter(Hd,data);
load('Kangbao_084251_TimePoint.mat');
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
NorPulse = [NorPulse,Pulse];
save Pulse084251.mat Pulse;
clear data i TimePoint Pulse;

load('Ningxia_2.0MW_133710_Normal.mat');
% data = filter(Hd,data);
load('Ningxia_133710_TimePoint.mat');
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
NorPulse = [NorPulse,Pulse];
save Pulse133710.mat Pulse;
clear data i TimePoint Pulse;

load('Ningxia_2.0MW_150028_Normal.mat');
% data = filter(Hd,data);
load('Ningxia_150028_TimePoint.mat');
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
NorPulse = [NorPulse,Pulse];
save Pulse150028.mat Pulse;
clear data i TimePoint Pulse;

% % 扩充正常样本by故障中的正常脉冲
load('Ningxia_2.0MW_143406_LightningStrike.mat');
% data = filter(Hd,data);
TimePoint = [2.11,4.59,9.49,12,16.82,19.3,24.14,26.58,31.42,33.82,38.76,41.22,46.06,48.56,53.53,55.90,60.83,63.28,68.126,70.529,75.391,77.895,82.757,85.218,90,92.518,97.381,99.87,104.718,107.135,112.113,114.545,119.378,121.78,126.613,129,133.833,136.133,141,143.387,148.337,150.783,155.762,158.193,163,165.46,170.3,172.7,177.46,179.81,184.89,187.26];
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
NorPulse = [NorPulse,Pulse];
save Pulse143406.mat Pulse;
clear data i TimePoint Pulse;
load('Ningxia_2.0MW_143837_LightningStrike.mat');
% data = filter(Hd,data);
TimePoint = [2.19,4.56,9.49,11.87,16.847,19.45,24.236,26.67,31.5,34,38.84,41.33,46.15,48.5,53.5,55.9,60.819,63.274,68.103,70.5,75.317,77.67,82.69,85.138,90,92.5,97.5,99.86,104.77,107.274,112,114.48,119.22,121.66,126.54,129,133.74,136.146,141.137,143.586,148.5,151,155.728,165.526,170.516,173,177.728,160.3,185.121,187.647,192.437,194.886,199.846,200.341,207.162,209.734,214.571,217.112,222,224.433,229.593,232,237,239.48,244.608,247,252.144,254.67,259.814,262.48,267.58,270.242,275.48,278.143,283.503,286.122,291.543,294.254,299.815,302.572,308.147,310.89,316.557,319.391,324.828,327.631,333.130,335.81,341,343.526,348.624,351.211,355.878,358.343,363.117,365.335,370.11,372.544,377.358,379.786,384.6,387.134,392,394.493,399.292,401.705,406.612,409,413.88,416.36,421.279,423.706,428.56,431,435.785,438.225];
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
NorPulse = [NorPulse,Pulse];
save Pulse143837.mat Pulse;
clear data i TimePoint Pulse;
load('Ningxia_2.0MW_144705_LightningStrike.mat');%部分正常脉冲具有排水口啸叫声的时频特性
% data = filter(Hd,data);
TimePoint = [0.572,3,7.765,10.278,15.269,17.65,22.523,25,29.884,32.363,37.266,39.63,44.511,47,51.76,54.31,59.258,61.637,66.453,68.776,73.764,76.172,81,83.436,88.253,90.69,95.535,98,102.673,105.188,110,112.436,117.224,119.575,124.649,127,132,134.434,139.154,141.633,146.483,149,153.656,156.285,161.2,163.593,168.357,170.835,175.664,178.186,183.165,185.516,190.447,192.80,197.729,200,205,207.38,212.367,214.747,219.707,222.151,227,229.366,234.268,236.762,241.665,244,249,251.522,256.482,258.812,263.685,266.171,271,273.232,278.2,280.683,285.59,288,293,295.224,300.301,302.651,307.582,310,314.873,317.307,322.238,324.609,329.602,332,337,339.266,344.269,346.657,351.571,354];
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
NorPulse = [NorPulse,Pulse];
save Pulse144705.mat Pulse;
clear data i TimePoint Pulse;
save NorPulse.mat NorPulse;

% load('NorPulse.mat');
%%峰峰值+频谱重心
% MaxMax = max(NorPulse)-min(NorPulse);
% [NProw,NPcal] = size(NorPulse);
% SpecCenter = zeros(1,NPcal);
% for Nfft = 1:NPcal
% %     FftPulse = abs(fft(NorPulse(:,Nfft)));
% %     FftPulse = FftPulse(1:Fs/2,:);
% %     Freq = Fs/SampleLength;
%     FftPulse = pwelch(NorPulse(:,Nfft));
%     Freq = Fs/(2*length(FftPulse));
%     FreqAxe = 0:Freq:(length(FftPulse)-1)*Freq;
%     SumWeightSpectrum = sum(FreqAxe * FftPulse);
%     SumAmp = sum(FftPulse);
%     SpecCenter(:,Nfft) = SumWeightSpectrum/SumAmp;
% end
% clear NProw NPcal Nfft Freq FreqAxe FftPulse SumAmp SumWeightSpectrum;
% FeatureVector = [MaxMax;SpecCenter]';
%特征归一化
% [Frow,Fcal] = size(FeatureVector);
% for i = 1:Fcal
%     maxValue = max(FeatureVector(:,i));
%     minValue = min(FeatureVector(:,i));
%     FeatureVector(:,i) = (FeatureVector(:,i)-minValue)/(maxValue-minValue);
% end
%% PCA+时域
% FeatureVector = featureExtraction(NorPulse);
% FeatureVector = FeatureVector';
% %特征归一化
% [Frow,Fcal] = size(FeatureVector);
% for i = 1:Fcal
%     maxValue = max(FeatureVector(:,i));
%     minValue = min(FeatureVector(:,i));
%     FeatureVector(:,i) = (FeatureVector(:,i)-minValue)/(maxValue-minValue);
% end
% centerF = mean(FeatureVector);
% FeatureVector = FeatureVector-centerF;
% [coeff,later,com] = pca(FeatureVector);
% FeatureAfterOptim = later(:,1:2);
% latent = com./sum(com);
% con = latent;
% for i  =1:12
%         latent(i,:) = sum(con(1:i,:));
% end 
% plot(FeatureAfterOptim(:,1),FeatureAfterOptim(:,2),'bo');
% xlim([-0.1 1.1]);
% ylim([-0.1 1.1]);
% grid on;
% xlabel('峰峰值');
% ylabel('频谱重心');

load('H:\MHM\windturbine\贵阳龙塘山风场1.5MW\mat\2018815163937.mat');
data = data';
TimePoint = [0.5,1.5,2.56,3.86,4.95,6.176,7.22,8.36,9.55,10.71,11.80,12.94,14.13,15.32,16.43,17.5,18.7,19.88,21.06,22.2,23.34,24.4,25.6,26.86,28,29.14,30.31,31.4,32.58,33.75,34.94,36.19,37.34,38.5,39.67,41,42.19,43.49,44.475,45.65,47,48.16,49.4,50.56,51.79,53,54.124,55.265,56.475,57.77,59,60.175,61.367,62.51,63.8,65,66.141,67.23,68.56,69.77,71,72.29,73.5,74.7,75.91,77.13,78.31,79.6,80.8,82,83.32,84.68,86,87.33,88.65,89.86,91.33,92.75,95.5,97,98.42,99.88,101.18,102.7,104.121,105.52,106.89,108.5,109.87,111.24,112.625,113.88,115.315,116.481,117.838,118.89,120.2,121.315,122.493,123.685,124.89,126,127.165,128.37,129.522,130.61,131.738,132.839];
Fs = 64000;
SampleLength = Fs*1;
Pulse = zeros(Fs*1,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
save Pulse163937.mat Pulse;

load('H:\MHM\windturbine\BladeData\NormalBlade\3.0WM\山东潍坊滨海风场\mat\20171214105658.mat');
TimePoint =[71.53,76.06,78.20,81.03,85.58,93.05,96.13,100.39,103.14,107.67,110.58,120.00,122.33,125.06,127.43,129.56,132.20,136.88,156.00,158.80,161.54,163.30,165.54,180.00,182.96,186.90,190.00,192.00,194.27,197.20,201.62,204.72,208.90,211.65,216.00,218.61,221.26,223.42,230.70,233.32,238.00,262.17,264.51,276.67,281.36,284.00,288.28,291.21,295.49,298.54,302.96,305.71,310.24,331.62,370.51];
Fs = 64000;
SampleLength = Fs*1;
Pulse = zeros(SampleLength,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
save Pulse105658.mat Pulse;
clear data TimePoint i Pulse;

% WeiFang-3.0MW-NormalBlade-20171214110804.wav
load('H:\MHM\windturbine\BladeData\NormalBlade\3.0WM\山东潍坊滨海风场\mat\20171214110804.mat');
TimePoint =[112.58,115.00,119.76,122.00,126.81,129.28,134.35,136.35,141.86,143.35,148.71,156.17,158.00,163.47,165.64,168.29,170.68,173.00,178.00,180.19,185.00,187.00,192.53,194.38,199.54,201.85,204.46,206.85,209.27,214.00,216.00,218.00,221.34,223.43,236.25,238.40,243.58,245.74,248.42,250.48,252.58,258.00,265.17,267.43,272.28,274.32,277.05,279.68,282.00,287.30,289.11,291.76,296.00,301.36,303.76,306.45,308.45,311.03,313.34,316.00,323.10,325.10,327.35,330.00,332.45,335.54,337.70,340.00];
Fs = 64000;
SampleLength = Fs*1;
Pulse = zeros(SampleLength,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
save Pulse110804.mat Pulse;
clear data TimePoint i Pulse;

% WeiFang-3.0MW-NormalBlade-20171214112818.wav   
load('H:\MHM\windturbine\BladeData\NormalBlade\3.0WM\山东潍坊滨海风场\mat\20171214112818.mat');
TimePoint = [5.64,7.86,13.05,14.86,16.21,27.55,30.19,32.74,34.97,37.67,40.00,42.19,44.17,46.61,49.33,52.00,56.79,58.74,61.56,64.00,65.00,67.55,68.57,71.26,72.76,75.91,78.55,79.60,82.00,83.00,86.00,93.27,100.53,105.33,107.71,110.00,112.71,115.00,117.43,119.00,122.20,126.83,129.25,131.18,136.69,141.62,143.83,145.00,149.00,151.00,153.83,156.00,158.20,161.00,163.48,165.83,167.00,170.83,173.00,175.00,178.13,180.00,194.83,196.25,199.17,202.00,204.18,209.48];
Fs = 64000;
SampleLength = Fs*1;
Pulse = zeros(SampleLength,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
save Pulse112818.mat Pulse;
clear data TimePoint i Pulse;

%% WeiFang3.0 排水口
% WeiFang-3.0MW-NormalBlade-20171214111650.wav
load('H:\MHM\windturbine\BladeData\NormalBlade\3.0WM\山东潍坊滨海风场\mat\20171214111650.mat');
TimePoint = [63.09,70.32,76.58,83.70,91.25,98.30,105.52,112.90,120.00,127.42,134.46,141.90,156.37,163.73,178.34,185.35,192.67,200.00,243.35,257.75,265.23,301.33,308.93,316.00,323.33,337.93,352.21,359.62,367.00,381.26];
Fs = 64000;
SampleLength = Fs*1;
Pulse = zeros(SampleLength,length(TimePoint));
for i = 1:length(TimePoint)
    Pulse(:,i) = data(1,TimePoint(i)*Fs:TimePoint(i)*Fs+Fs*1-1);
end
save Pulse111650.mat Pulse;
clear data TimePoint i Pulse;



