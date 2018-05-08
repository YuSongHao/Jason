function [FreqPeaks] = specpeaksearch(data,Fs,WindowLength)
%%
%  Spectral Peak Search --谱峰搜索--
%  author : YuSongHao
%  2018.05.07
%  
FreqResolution = Fs/WindowLength;
TimeResolution = WindowLength/Fs;
FreqAxe = 0:FreqResolution:FreqResolution*(WindowLength-1);
TimeAxe = 0:TimeResolution:TimeResolution*(WindowLength-1);
WindowNumber = fix(length(data)/WindowLength);
FreqPeaks = zeros(1,WindowNumber);
[row,cal] = size(data);
if row>=cal
    data = data';
end
data = data(1,1:WindowLength*WindowNumber);
data = reshape(data,[WindowLength,WindowNumber]);
FFTData = fft(data,WindowLength);
FFTData = abs(FFTData(1:WindowLength/2,:));
for FrameNumber = 1:WindowNumber
    Temp = FFTData(:,FrameNumber);
    MeanTemp = mean(Temp);
    [value,location] = max(Temp);
% ——峰值比次峰值
%     Temp(location,1) = mean(Temp);
%     [valuesecond,locationsecond] = max(Temp);
%     if value >= 1.5*valuesecond
%        FreqPeaks(1,FrameNumber) = location * FreqResolution;
%     else
%        FreqPeaks(1,FrameNumber) = 1000;
%     end
% ——峰值比平均值
    if value >= 40 * MeanTemp
        FreqPeaks(1,FrameNumber) = location * FreqResolution;
    else
        FreqPeaks(1,FrameNumber) = 1000;
    end    
end
TimeAxeData = 0:TimeResolution:TimeResolution * (WindowNumber-1);
scatter(TimeAxeData,FreqPeaks,'b');
xlabel('Time/s');
ylabel('Frequency/Hz');
end

