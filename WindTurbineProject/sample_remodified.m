clear; clc

% ��ƴ�ͨ���߸�ͨ�˲���
% 600 -- 2000Hz bandpass filter
% d = fdesign.bandpass('N,F3dB1,F3dB2', 12, 1000, 3000, 44100);
% Hd = design(d,'butter');
% d = fdesign.highpass('N,F3dB', 12, 500, 44100);
% Hd = design(d,'butter');
% [b,a] = sos2tf(Hd.sosMatrix,Hd.ScaleValues);
% [b,a] = sos2tf(SOS,G); 
% % % ��ͨ�˲������

numerator = [ 0.160173, 0, -0.160173;
              0.160173, 0, -0.160173;
              0.148663, 0, -0.148663;
              0.148663, 0, -0.148663 ];
denominator = [ 1, -1.654943, 0.808912;
                1, -1.947480, 0.955044;
                1, -1.827619, 0.840246;
                1, -1.547690, 0.627149 ];
% b = [0.761120526108669,-9.13344631330403,50.2339547231722,-167.446515743907,376.754660423791,-602.807456678066,703.275366124410,-602.807456678066,376.754660423791,-167.446515743907,50.2339547231722,-9.13344631330403,0.761120526108669];
% a = [1,-11.4542303890564,60.1449943175383,-191.440749052144,411.393468206038,-628.783723870067,700.897537908594,-574.110991737200,342.961053444744,-145.717322191752,41.7984791383758,-7.26782023033453,0.579304455263937];
checkCycle = 0;
sampleRate = 44100;
pieceLength = 512;  %�����
peakMinPiece = 103;%318 173
peakMaxPiece = 173;%379 243
peakOffsetPiece = 32;
peakPiece = 10;%�޸� ����ȡ0.1s
peakMinPoint = peakMinPiece * pieceLength;%��ֵ����С���
peakMaxPoint = peakMaxPiece * pieceLength;%��ֵ�������
peakOffsetPoint = peakOffsetPiece * pieceLength;
peakPoint = peakPiece * pieceLength;
smoothLength = 51;
frameLength = 262144;%֡��,2��n����,5.9443��
energyThreshold = 1.1;%��������ֵ
ampThreshold = 50;%Ұ��ȥ����ֵ
Fs = 44100;
filePath = 'C:\Users\���Ժ�\Desktop\�龯�ļ�\mat';
% cd(filePath);
thresh = [];
len = [];

% ��ȡ�ļ������е�mat�ļ�
fileList = dir([filePath, '\*.mat']);
for idxFile = 1 : length(fileList)
    % ��ʼ������
    nextStart = 1;
    frameLastData = zeros(frameLength, 1);
    circleStartPoint = [];
    circleEndPoint = [];
    peakStartPoint = [];
    peakEndPoint = [];
%     peakEnergyRatio = [];
    circleStartPoint = [];
    circleEndPoint = [];
    circle_r = [];
    circleVar = [];
%     circleRatio_1 = [];
%     circleRatio_2 = [];
%     circleRatio_3 = [];
%     circleRatioMax = [];
    circleCount = 0;
    filterOrder   = 20;    % ����
    fn1  = 1e3;           % ��ֹƵ��
    fn2  = 3e3;           % ��ֹƵ��
    % fs  = 48e3;             % ������
    Wn  = [fn1 fn2]/(sampleRate/2);        % ��ֹƵ��
    fff = [0 Wn 1];
    aaa = [ 0  1  0];          % ���������ͨ��
    up  = [ 0.001 1.02 0.001];   % �����ͨ���ķ�ֵ�Ͻ���
    lo  = [-0.001 0.98 -0.001];   % �����ͨ���ķ�ֵ�½���
    b   = fircls(filterOrder,fff,aaa,up,lo);   % Display plots of bands
%     freqz(b,1,512,sampleRate);
    % read data
    fileName = [filePath, '\', fileList(idxFile).name];
    dataLoad = load(fileName);
    data = dataLoad.Data(:,1);
    for idxFilter = 1 : 4
           b = denominator(idxFilter, :);
           a = numerator(idxFilter, :);
           data = filter(a, b, data);
    end
    data = filter(b,1,data);
%     plot(data)
%     data = data';
    % ��֡����
    frameCount = floor(length(data)/frameLength);
    for idxFrame = 1 : frameCount
        % ��õ�ǰ֡����
        frameData = data((idxFrame-1)*frameLength+1 : idxFrame*frameLength);
        % ��ȡ�������� �� ��һ֡�͵�ǰ֡ƴ��
        handleData = [frameLastData; frameData]; % length : 2 * frameLength
        frameLastData = frameData;
%         for idxFilter = 1 : 4
%            b = denominator(idxFilter, :);
%            a = numerator(idxFilter, :);
%            handleData = filter(a, b, handleData);
%         end
        %handleData = filter(Hd, handleData);
%         for idxFilter = 1 : 4
%             b = denominator(idxFilter, :);
%             a = numerator(idxFilter, :);
%             handleData = filter(a, b, handleData);
%         end
        if(checkCycle)
            cycle = ExtractCycle(handleData, 2);
            if(isempty(cycle))
            else
            peakMinPoint = (cycle / 3 - 0.3) * Fs;%��ֵ����С���
            peakMaxPoint = (cycle / 3 + 0.3) * Fs;%��ֵ�������
            peakMinPiece = peakMinPoint / pieceLength;
            peakMaxPiece = peakMaxPoint / pieceLength;
            disp(['cycle change to : ', num2str(cycle)]);
            end
            checkCycle = 0;
        end
        handleDataMean = mean(abs(handleData));
        % ��ȡ���� 
        pieceData = reshape(handleData, pieceLength, length(handleData)/pieceLength);
        pieceData = max(pieceData);
        % ƽ��piece
        pieceDataSmooth = smooth(pieceData, smoothLength);
        % ��ȡƽ��piece�ļ�ֵ
        [peakValue, peakIndex] = findpeaks(pieceDataSmooth,'minpeakdistance',peakMinPiece);
        %disp(num2str(peakIndex));
        % ��ȡ��ֵ��ʼ����ֹʱ��
        startPoint = (peakIndex - peakOffsetPiece - 1) * pieceLength;
        endPoint = (peakIndex + peakOffsetPiece - 1) * pieceLength - 1;
        
        % ������ֵ������ж�
        startPiece = peakIndex - peakOffsetPiece - 1;
        endPiece = peakIndex + peakOffsetPiece - 1;
        
        startPoint_2 = (peakIndex - peakPiece - 1) * pieceLength;
        endPoint_2 = (peakIndex + peakPiece - 1) * pieceLength - 1;%�޸ģ���ʼ��

        %% �����ֵ������������ֵ�ͷ�ֵ���
        peakExist = ones(length(peakIndex), 1);
%         EnergyRatio = [];
        for idxPeak = 1 : length(peakIndex)
            % ����ֵ��ʼ����ֹ��Խ��
            minStartPoint = max(2 * peakOffsetPoint, nextStart);
            if startPoint(idxPeak) <= minStartPoint || endPoint(idxPeak) > length(handleData)
                peakExist(idxPeak) = 0;
                peakDataEnergy = 0;
%                 EnergyRatio(peakIndex) = 0;
                continue;
            end
            [value,locs] = findpeaks(pieceDataSmooth(startPiece(idxPeak):endPiece(idxPeak)));
            peakData = handleData(startPoint(idxPeak) : endPoint(idxPeak));
            peakData_2 = handleData(startPoint_2(idxPeak) : endPoint_2(idxPeak));
            peakDataEnergy = pwelch(peakData);%����ȡĬ�ϣ��ɵȷֳ�8�飬ÿ�鳤��Ϊ2^n
            peakEnergy = pwelch(peakData_2);%�޸� ����
            peakBeforeData = handleData(startPoint(idxPeak) - 2 * peakOffsetPoint : startPoint(idxPeak) - 1);
            peakBeforeDataEnergy = pwelch(peakBeforeData);
            specBefore = sum(peakDataEnergy) / sum(peakBeforeDataEnergy);
            disp(['ǰ�������� ��',num2str(specBefore)]);
            EnergyRatio = sum(peakEnergy)/sum(peakDataEnergy);%�޸� ��ֵ
            disp(['���������� ��',num2str(EnergyRatio)]);
            peakDataMax = max(abs(peakData));
            ratio = peakDataMax / handleDataMean;
            thresh = [thresh;ratio];
            %disp(['ratio : ', num2str(specBefore)]);
            %disp(['max value : ', num2str(peakDataMax)]);
            if specBefore < energyThreshold || peakDataMax >= ampThreshold * handleDataMean || EnergyRatio<0.44 %�޸� ��ֵ�о�
               peakExist(idxPeak) = 0;
            end
        end
        % ɾ������������������
        startPoint(peakExist==0) = [];
        endPoint(peakExist==0) = [];
        peakIndex(peakExist==0) = [];
        startPiece(peakExist==0) = [];
        endPiece(peakExist==0) = [];
%         EnergyRatio(peakExist==0) = [];
        
        for idx = 1 : length(startPoint)
            disp(['Peak value : ', num2str(startPoint(idx) + (idxFrame - 2) * frameLength)]);
%             figure
%             plot(pieceDataSmooth(startPiece(idx):endPiece(idx)));           
        end
        % ������ֹ�㣬��ͼʹ��
        peakStartPoint = [peakStartPoint; startPoint + (idxFrame - 2) * frameLength];
        peakEndPoint = [peakEndPoint; endPoint + (idxFrame - 2) * frameLength];
%         peakEnergyRatio = [peakEnergyRatio,EnergyRatio];
        %% �ж����� �� �������������ֵ�Ĳ�ֵС����ֵ
        nextStart = 0;
        if (length(startPoint) < 3)
            continue;
        end
        idxPeak = 2;
        while idxPeak <= length(startPoint) - 1
            lastPeakDiff = startPoint(idxPeak)-startPoint(idxPeak-1);
            nextPeakDiff = startPoint(idxPeak+1)-startPoint(idxPeak);
            if nextPeakDiff < peakMaxPoint && lastPeakDiff < peakMaxPoint
                circleCount = circleCount+1;
                circleStartPoint(circleCount) = startPoint(idxPeak - 1) + (idxFrame - 2) * frameLength;
                circleEndPoint(circleCount) = endPoint(idxPeak + 1) + (idxFrame - 2) * frameLength;
                nextStart = endPoint(idxPeak + 1) - frameLength;
                freqCenter = zeros(3, 1);
                circleEnergy = [];
                for idxCenter = 1 : 3
                    peakData = handleData(startPoint(idxPeak - 2 + idxCenter) : endPoint(idxPeak - 2 + idxCenter));
                    [energyData, W] = pwelch(peakData);
                     circleEnergy = [circleEnergy,energyData];
                    freqCenter(idxCenter) = sum(W.* energyData)/sum(energyData);
                end
                
                r1 = corrcoef(circleEnergy(1:1115,1),circleEnergy(1:1115,2));
                r2 = corrcoef(circleEnergy(1:1115,2),circleEnergy(1:1115,3));
                r3 = corrcoef(circleEnergy(1:1115,1),circleEnergy(1:1115,3));
                r(1) = r1(1,2);
                r(2) = r2(1,2);
                r(3) = r3(1,2);
                circle_r(circleCount) = min(r);
                
                freqCenter = freqCenter * sampleRate / (2 * pi);
                circleVar(circleCount) = var(freqCenter, 1);
                if(circleVar(circleCount)<7500)
                    circleExist(circleCount) = 0;
                else circleExist(circleCount) = 1;
                end
%                 circleRatio_1(circleCount) = sum(circleEnergy(:,1))/sum(circleEnergy(:,2));
%                 circleRatio_2(circleCount) = sum(circleEnergy(:,2))/sum(circleEnergy(:,3));
%                 circleRatio_3(circleCount) = sum(circleEnergy(:,3))/sum(circleEnergy(:,1));
%                 circleRatioMax(circleCount) = max([circleRatio_1(circleCount),circleRatio_2(circleCount),circleRatio_3(circleCount)]);
%                 if(circleRatioMax(circleCount)>2.5)
%                     circleExist(circleCount) = 0;
%                 end
                disp(['Var : ', num2str( var(freqCenter, 1) )]);
                idxPeak = idxPeak + 3;
            else
                idxPeak = idxPeak + 1;
                checkCycle = 1;
            end
        end
    end
%     circleStartPoint(circleExist == 0) = [];
%     circleEndPoint(circleExist == 0) = [];
%     circleVar(circleExist == 0) = [];
%     circleRatio_1(circleExist == 0) = [];
%     circleRatio_2(circleExist == 0) = [];
%     circleRatio_3(circleExist == 0) = [];
%     circleRatioMax(circleExist == 0) = [];
    
    %% ��ͼ
    figure
        for idxFilter = 1 : 4
            b = denominator(idxFilter, :);
            a = numerator(idxFilter, :);
            handleData = filter(a, b, handleData);
        end
    %data = filter(Hd, data);
    timeAxes = (1 : length(data)) / sampleRate;
    peakStartPoint = peakStartPoint / sampleRate;
    peakEndPoint = peakEndPoint / sampleRate;
    circleStartPoint = circleStartPoint / sampleRate;
    circleEndPoint = circleEndPoint / sampleRate;
%     subplot(2,1,1)
    plot(timeAxes,data,'b')
    hold on
    for i = 1:length(peakStartPoint)
        line([peakStartPoint(i) peakStartPoint(i) peakEndPoint(i) peakEndPoint(i) peakStartPoint(i)],[30 -30 -30 30 30],'color','g');
    end  
    for i = 1:length(circleStartPoint)
        line([circleStartPoint(i) circleStartPoint(i) circleEndPoint(i) circleEndPoint(i) circleStartPoint(i)],[30 -30 -30 30 30],'color','r','linewidth',2);
    end 
%     for i = 1:length(circleStartPoint)
%         line([circleStartPoint(i) circleStartPoint(i) circleEndPoint(i) circleEndPoint(i) circleStartPoint(i)],[0.08 -0.08 -0.08 0.08 0.08],'color','y','linewidth',2);
%     end 
%     for i = 1:frameCount-1
%         line([i*(frameLength/sampleRate) i*(frameLength/sampleRate)],[0.1 -0.1],'color','r')
%     end
    hold off
%      subplot(2,1,2),plot(circleVar,'r-v','markersize',8,'linewidth',2);
%     subplot(3,1,3),plot(circle_r,'linewidth',2);
%     subplot(3,1,3),plot(peakEnergyRatio,'linewidth',2);
%     subplot(4,1,3),plot(circleRatio_1,'linewidth',2);
%     hold on
%     plot(circleRatio_2,'color','r','linewidth',2);
%     plot(circleRatio_3,'color','g','linewidth',2);
%     hold off
%     subplot(4,1,4),plot(circleRatioMax,'linewidth',2);
end