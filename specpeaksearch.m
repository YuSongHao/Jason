%%
%  Spectral Peak Search Æ×·åËÑË÷
%  author : YuSongHao
%  2018.05.07
%  
function [] = specpeaksearch(data,Fs,WindowLength)
FreqResolution = Fs/WindowLength;
TimeResolution = WindowLength/Fs;
FreqAxe = 0:FreqResolution:FreqResolution*(WindowLength-1);
TimeAxe = 0:TimeResolution:TimeResolution*(WindowLength-1);
WindowNumber = fix(length(Data)/WindowLength);
FreqPeaks = zeros(1,WindowNumber);
[row,cal] = size(Data);
if row>=cal
    Data = Data';
end
Data = Data(1,1:WindowLength*WindowNumber);
Data = reshape(Data,[WindowLength,WindowNumber]);
FFTData = fft(Data,WindowLength);
FFTData = abs(FFTData(1:WindowLength/2,:));
for FrameNumber = 1:WindowNumber
    temp = FFTData(:,FrameNumber);
    [value,location] = max(temp);
    FreqPeaks(1,FrameNumber) = location * FreqResolution;
end
TimeAxeData = 0:TimeResolution:TimeResolution * (WindowNumber-1);
scatter(TimeAxeData,FreqPeaks,'b');
xlabel('Time/s');
ylabel('Frequency/Hz');
end

