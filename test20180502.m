clear;clc;
DataLoad = load('Ningxia_2.0MW_151358_Paishuikou.mat');
data = DataLoad.data;
Fs = 6.4e4;
d = fdesign.bandpass('N,F3dB1,F3dB2', 32, 2000,20000, Fs);
hd = design(d,'butter');
data = filter(hd,data);
audiowrite('data.wav',data,Fs);
Pulse_Width = 1.15;%Âö³å¿í¶ÈÉèÖÃ
FFT_length = 2048;
t = FFT_length/(Pulse_Width*Fs);
TimeAxe = 0:t:(FFT_length/2-1)*t;
f = Fs/FFT_length;
FreqAxe = 0:f:(FFT_length/2-1)*f;
TimePoint = [16.85,24.735,32.851,40.851,49.254,57.582];%PSK151358
distance_TimePoint = diff(TimePoint);
Pulse_startor = zeros(1,3*(length(TimePoint)-1));
for idx = 1:length(Pulse_startor)
    if mod(idx+2,3) == 0
        Pulse_startor(1,idx) = TimePoint(1,(idx+2)/3);
    elseif mod(idx+2,3) == 1||mod(idx+2,3) == 2
        Pulse_startor(1,idx) = Pulse_startor(1,idx-1) + distance_TimePoint(floor((idx+2)/3))/3;
    end    
end
Pulse_endor = Pulse_startor + Pulse_Width;%Âö³å¿í¶È1.15Ãë
FreqMax = zeros(floor(Pulse_Width*Fs/FFT_length),length(Pulse_startor));
for i = 1:length(Pulse_startor)
    Data = data(1,Pulse_startor(i)*Fs+1:Pulse_endor(i)*Fs);
    FFT_window_number = floor(length(Data)/FFT_length);
    Data = Data(1,1:FFT_window_number*FFT_length);
    Data = reshape(Data,[FFT_length,FFT_window_number]);
    for m = 1:FFT_window_number
        Data_FFT = Data(:,m);
        Y = abs(fft(Data_FFT));
        Y = Y(1:FFT_length/2,1);
        plot(FreqAxe,smooth(Y));
        [val,loc] = max(smooth(Y));
        FreqMaxLocation = FreqAxe(1,loc);
        FreqMax(m,i) = FreqMaxLocation;
    end
end
timeaxe = 0:Pulse_Width/FFT_window_number:Pulse_Width/FFT_window_number*(FFT_window_number-1);
temp_PSK_findpeaks = zeros(FFT_window_number,5);
cal_temp = 1;
for jason = 1:3:13
    figure(jason);
    scatter(timeaxe,FreqMax(:,jason),'r');
    temp_PSK_findpeaks(:,cal_temp) = FreqMax(:,jason);
    cal_temp = cal_temp + 1;
    hold on 
    scatter(timeaxe,FreqMax(:,jason+1),'b');
    scatter(timeaxe,FreqMax(:,jason+2),'b');
    hold off
end

for cal = 1:5
    b = ['PEAKS',num2str(cal)];
    eval([b,'=temp_PSK_findpeaks(:,cal);']);
%     scatter(timeaxe,temp_PSK_findpeaks(:,cal),'r');
end
for jsp = 1:15
        order = 3;
    d_fitting = polyfit(timeaxe,FreqMax(:,jsp)',order); 
    ft = polyval(d_fitting,timeaxe); 
    if mod(jsp+2,3) == 0
        scatter(timeaxe,FreqMax(:,jsp),'r');
        hold on 
        plot(timeaxe,ft,'color',[1,0,0]);
        hold off
    else
        scatter(timeaxe,FreqMax(:,jsp),'b');
        hold on 
        plot(timeaxe,ft,'color',[0,0.45,0.74]);
        hold off
    end    
end