clear;clc;
[data,Fs] = audioread('ÔëÉù¹À¼Æ.wav');
data = data/max(data);
FftLength = 2048;
FftData = abs(fft(data,FftLength))';
Fata = FftData(1,1:0.5*FftLength);
FreqAxe = 0:Fs/FftLength:(0.5*FftLength-1)*Fs/FftLength;
plot(FreqAxe,10*log10(Fata),'color',[0,0.45,0.79]);
save FftData.mat FftData
[PSKData,Fs] = audioread('ÉÚÉùÂö³å.wav');
PSKData = PSKData/max(PSKData);
FftPSKData = fft(PSKData,FftLength)';
PhasePSKData = angle(FftPSKData);
AmplitudePskData = abs(FftPSKData);
FftData = load('FftData.mat');
FftData = FftData.FftData;
AmpSubSpectPSKData = AmplitudePskData-FftData;


