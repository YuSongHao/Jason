clear;clc;
FilePath = ('E:\叶片样本库\故障\排水口');
cd(FilePath);
DataLoad = load('Ningxia_2.0MW_151358_Paishuikou.mat');
TimePoint = [16.85,24.735,32.851,40.851,49.254,57.582];%PSK151358
data = DataLoad.data;
Fs = 64000;
d = fdesign.bandpass('N,F3dB1,F3dB2', 32, 2000,20000, Fs);
hd = design(d,'butter');
data = filter(hd,data);
data = data(1,(TimePoint(1)-0.5)*Fs+1:(TimePoint(end))*Fs);
output = simplesubspec(data,1024,512,20,20,0.001);
[TimeAxeData,FreqPeaks] = specpeaksearch(output,Fs,2048);
TimePointAfter = TimePoint - (TimePoint(1)-0.5);
f = diff(TimePointAfter)/3;%定位正常+哨音脉冲
TimePointWhole = zeros(1,(length(TimePointAfter)-1)*3);
for EachPeriod = 1:length(f)
    TimePointWhole(1,EachPeriod*3-2) = TimePointAfter(1,EachPeriod); 
    TimePointWhole(1,EachPeriod*3-1) = TimePointAfter(1,EachPeriod)+f(1,EachPeriod);
    TimePointWhole(1,EachPeriod*3) = TimePointAfter(1,EachPeriod)+2*f(1,EachPeriod);
end
TimePointStartor = TimePointWhole;
TimePointEndor = TimePointWhole+1.15;
NormalTimeStartor = [TimePointStartor(2),TimePointStartor(3),TimePointStartor(5),TimePointStartor(6),TimePointStartor(8),TimePointStartor(9),TimePointStartor(11),TimePointStartor(12),TimePointStartor(14),TimePointStartor(15)];
NormalTimeEndor = NormalTimeStartor + 1.15;
%% Normal Pulse Extraction
FreqTimePeaks = [FreqPeaks;TimeAxeData];
for PulseNumber = 1:10
    PulseTemp = [];
    for i = 1:length(TimeAxeData)    
        if TimeAxeData(:,i) >= NormalTimeStartor(:,PulseNumber) && TimeAxeData(:,i) <= NormalTimeEndor(:,PulseNumber)
                PulseTemp = [PulseTemp,FreqPeaks(:,i)];
        end
    end
    NormalPulse = PulseTemp;
    save filename NormalPulse;
    oldname = 'filename.mat';
    filename = ['NormalPulse',num2str(PulseNumber),'.mat'];
    command = ['rename' 32 oldname 32 filename];
    status = dos(command);
end












%% Pulse Extraction
FreqTimePeaks = [FreqPeaks;TimeAxeData];
for PulseNumber = 1:5
    PulseTemp = [];
    for i = 1:length(TimeAxeData)    
        if TimeAxeData(:,i) >= TimePointAfter(:,PulseNumber) && TimeAxeData(:,i) <= TimePointAfter(:,PulseNumber)+1.15
                PulseTemp = [PulseTemp,FreqPeaks(:,i)];
        end
    end
    Pulse = PulseTemp;
    save filename Pulse;
    oldname = 'filename.mat';
    filename = ['Pulse',num2str(PulseNumber),'.mat'];
    command = ['rename' 32 oldname 32 filename];
    status = dos(command);
end


% for i = 1:length(PulsePointStartor)-1
%     X1 = TimePointAfter(1,i)*Fs+1;
%     X2 = TimePointAfter(1,i)*Fs + 73600;
%     Pulse(:,i) = data(1,(X1):(X2));
% end 
% peak = zeros(fix(73600/2048),5);
% for index = 1:5
% figure(index);
% peak(:,index) = specpeaksearch(Pulse(:,index),Fs,2048);
% end