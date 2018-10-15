function [NormalData,FaultData,Feature] = incrementalTrain(initalN,initalF,increN,increF,coeff,MaxV,MinV,centerF)
% ����ѵ��
    if nargin == 8
        FaultData = [initalF,increF];
    else
        FaultData = initalF;
    end
    NormalData = [initalN,increN];
    [Nrow,Ncal] = size(NormalData);
    newSampleGroup = [NormalData,FaultData];
    [row,cal] = size(newSampleGroup);
    feature = zeros(cal,8);
    energy = zeros(cal,8);
    for i = 1:cal
    pulseTemp = newSampleGroup(:,i);
    wpt = wavelet_packetdecomposition_reconstruct(pulseTemp,5,'haar');
    E = wavelet_energy_spectrum(wpt,5);
%     E = wenergy(wpt);
    energy(i,:) = [E(4),E(3),E(8),E(7),E(5),E(6),E(16),E(15)];%��������˳��������򣬵õ�2-10K����8��Ƶ��
%     energy(i,:) = E(1,3:10);
    feature(i,:) = energy(i,:)/sum(energy(i,:));
    end
    for i = 1:8
        feature(:,i) = (feature(:,i)-MinV(i))/(MaxV(i)-MinV(i));
    end
    feature = feature-centerF;
    Feature = feature*coeff(:,1:3);
    figure;
    scatter3(Feature(1:Ncal,1),Feature(1:Ncal,2),Feature(1:Ncal,3),'bo');
    hold on 
    scatter3(Feature(Ncal+1:end,1),Feature(Ncal+1:end,2),Feature(Ncal+1:end,3),'ro');
    xlabel('���ɷ�1');
    ylabel('���ɷ�2');
    zlabel('���ɷ�3');
    grid on;
end

