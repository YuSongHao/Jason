function cycle = ExtractCycle(handledata,type)
    Fs = 44100;
    frameLength = 262144;
    pieceLength = 512; %包络点
    smoothLength = 51; %平滑取点数
    filterOfCycleExtNum = [2.15209512141093e-05,0,-8.60838048564371e-05,0,0.000129125707284656,0,-8.60838048564371e-05,0,2.15209512141093e-05];
    filterOfCycleExtDen = [1,-7.16724071346125,22.9052562700252,-42.5910085210018,50.3741251499111,-38.8005815092689,19.0099471806714,-5.41920898111322,0.688887685664053];
%     freqz(filterOfCycleExtNum,filterOfCycleExtDen,512,Fs);

    %     filePath = 'Data/ningxia';
    % filePath = 'Data';
%     fileList = dir([filePath, '\*.mat']);
    %3.0MW 7.0-8.6s；2.0MW 4.3-8.6；1.5MW 3.9-5.8
    if type == 1.5
        cycleLowerLimit = 3.9;
        cycleUpperLimit = 5.8;
    else if type == 2.0
            cycleLowerLimit = 4.3;
            cycleUpperLimit = 8.6;
        else
            cycleLowerLimit = 7.0;
            cycleUpperLimit = 8.6;
        end
    end
    cycle = [];
    handledata = filter(filterOfCycleExtNum, filterOfCycleExtDen, handledata);
    pieceData = reshape(handledata, pieceLength, length(handledata)/pieceLength);
    pieceData = max(pieceData);
    pieceDataSmooth = smooth(pieceData, smoothLength);%取包络平滑处理

    [C,LAGS] = xcorr(pieceDataSmooth,'unbiased');%无偏差自相关
    C = C((length(LAGS)+1)/2:length(LAGS));
    SmoothC = smooth(C, smoothLength);%平滑
    [pks,locs] = findpeaks(SmoothC,'minpeakdistance',Fs/512);%寻找极值
    L = length(pks);
        for i = 1:L
            if locs(i) < 100 || locs(i) > length(C)-100
                locs(i) = 0;
            end
        end
        locs(locs == 0)= [];
        x = diff(locs);%计算间隔
        x = x * pieceLength / Fs;%采样点数转为时间
        if isempty(x)
        else if length(locs) > 3
                upperLimitCheck = (x <= (cycleUpperLimit/3));
                lowerLimitCheck = (x >= (cycleLowerLimit/3));
                if ismember(0,upperLimitCheck) || ismember(0,lowerLimitCheck)
                else
                    cycle = mean(x) * 3;
                end
            else
                upperLimitCheck = (x <= (cycleUpperLimit));
                lowerLimitCheck = (x >= (cycleLowerLimit));
                if ismember(0,upperLimitCheck) || ismember(0,lowerLimitCheck)
                else
                    cycle = mean(x);
                end
            end
        end
end