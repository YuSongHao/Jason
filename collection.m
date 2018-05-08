% preprocessing module
% data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\山东潍坊滨海风场\mat\20171214113806.mat');
% Fs = 6.4e4;
% data = data.data;
% [m_1,n_1] = size(data);
%     if m_1>n_1
%     data = data';
%     end
%%异常数据    
%排水口
% data = data(1,9*Fs:83*Fs);%151358
% save Ningxia_2.0MW_151358_Paishuikou.mat data
% data = data;%135813
% save Ningxia_2.0MW_135813_Paishuikou.mat data
% data = data;%134935
% save Ningxia_2.0MW_134935_Paishuikou.mat data
% data = data(1,16*Fs:204*Fs);%111650_1;
% save Weifang_3.0MW_111650_1_Paishuikou.mat data
% data = data(1,240*Fs:380*Fs);%111650_2;
% save Weifang_3.0MW_111650_2_Paishuikou.mat data
% data = data(1,25*Fs:242*Fs);%105658;
% save Weifang_3.0MW_105658_Paishuikou.mat data
% data = data(1,64*Fs:301*Fs);%113806
% save Weifang_3.0Mw_113806_Paishuikou.mat data

%%正常数据
%宁夏硝池子
data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\NingXia\mat\2017127133710.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data;%133710
save Ningxia_2.0MW_133710_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\NingXia\mat\2017126150028.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data;%150028
save Ningxia_2.0MW_150028_Normal.mat data
clear;
%天唯康保
data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304084251.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,:);%084251
save Kangbao_2.0MW_084251_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304093424.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,:);%093424
save Kangbao_2.0MW_093424_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304112302.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,16*Fs:48*Fs);%112302_1
save Kangbao_2.0MW_112302_1_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304112302.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,80*Fs:105*Fs);%112302_2
save Kangbao_2.0MW_112302_2_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304120028.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,40*Fs:76*Fs);%120028
save Kangbao_2.0MW_120028_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304120737.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,1:102*Fs);%120737
save Kangbao_2.0MW_120737_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\天唯康保风场\mat\20170304121413.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,:);%121413
save Kangbao_2.0MW_121413_Normal.mat data
clear;

%塞罕坝
data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\围场县塞罕坝风场\mat\20161125155159.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(2,1:52*Fs);%155159_1
save Saihanba_2.0MW_155159_1_Normal.mat data
data = Data(2,82*Fs:184*Fs);%155159_2
save Saihanba_2.0MW_155159_2_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\2.0WM\围场县塞罕坝风场\mat\20161125154028.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(2,12*Fs:74*Fs);%154028
save Saihanba_2.0MW_154028_Normal.mat data
clear;


%山东潍坊
data = load('L:\MHM\windturbine\BladeData\NormalBlade\3.0WM\山东潍坊滨海风场\mat\20171214110804.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,95*Fs:226*Fs);%110804_1
save Weifang_3.0MW_110804_1_Normal.mat data
data = Data(1,232*Fs:342*Fs);%110804_2
save Weifang_3.0MW_110804_2_Normal.mat data
clear;

data = load('L:\MHM\windturbine\BladeData\NormalBlade\3.0WM\山东潍坊滨海风场\mat\20171214112818.mat');
Fs = 6.4e4;
Data = data.data;
[m_1,n_1] = size(Data);
    if m_1>n_1
    Data = Data';
    end
data = Data(1,5*Fs:162*Fs);%112818
save Weifang_3.0MW_112818_Normal.mat data


    
    
    
    
    
    
    
    
    
    
    
    
    
    
%张家口尚义1.5MW故障信号（叶片开裂,雷击导致）
% data = data(1,109*Fs:end);%153000
% save Zhangjiakou_1.5MW_153000_cracking.mat data
% data = data(1,50*Fs:233*Fs);%154412
% save Zhangjiakou_1.5MW_154412_cracking.mat data
% data = data(1,1:160*Fs);%155906
% save Zhangjiakou_1.5MW_155906_cracking.mat data
% %宁夏硝池子2.0MW故障信号（雷击）
% data = data;%样本均从头至尾可用143406,143837,144705
% save Ningxia_2.0MW_144705_LightningStrike.mat data
% %天唯康保2.0MW故障信号（叶片开裂）
% data = data(2,110*Fs:445*Fs);%101339_2
% save Kangbao_2.0MW_101339_2_Cracking.mat data
% data = data(1,110*Fs:445*Fs);%101339_1
% save Kangbao_2.0MW_101339_1_Cracking.mat data
% %塞罕坝2.0MW故障信号（叶片开裂）
% data = data(2,:);%125216_2
% save Saihanba_2.0MW_125216_2_Cracking.mat data
% data = data(2,1:130*Fs);%120132_2;
% save Saihanba_2.0MW_120132_2_Cracking.mat data
% data = data(2,25*Fs:end);%115515_2;
% save Saihanba_2.0MW_115515_2_Cracking.mat data
% data = data(2,:);%120910_2
% save Saihanba_2.0MW_120910_2_Cracking.mat data
% %山东潍坊3.0MW故障信号（雷击）
% data = data(1,281*Fs:330*Fs);
% save Weifang_3.0MW_95707_1_LightningStrike.mat data
% data = data(1,345*Fs:398*Fs);
% save Weifang_3.0MW_95707_2_LightningStrike.mat data
% data = data(1,10*Fs:67*Fs);%95114
% save Weifang_3.0MW_95114_LightningStrike.mat data
% %山东潍坊3.0MW故障信号(接闪器)
% data = data(1,60*Fs:159*Fs);%102402
% save Weifang_3.0MW_102402_LightningReceptor.mat data
% data = data(1,128*Fs:155*Fs);%101727_1
% save Weifang_3.0MW_101727_1_LightningReceptor.mat data
% data = data(1,173*Fs:204*Fs);%101727_2
% save Weifang_3.0MW_101727_2_LightningReceptor.mat data

