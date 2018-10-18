function [boundary] = SVDDPlot3D(dataset,model)
% SVDD��ά���������
% 2018/10/17
% Author:YuSongHao
demension1 = 1;
demension2 = 2;
demension3 = 3;
%%
minX = min(dataset(:, demension1));
maxX = max(dataset(:, demension1));%��һ���ϵ������Сֵ
minY = min(dataset(:, demension2));
maxY = max(dataset(:, demension2));%�ڶ����ϵ������Сֵ
minZ = min(dataset(:, demension3));
maxZ = max(dataset(:, demension3));%�������ϵ������Сֵ
%��������=����

n = 100;n1 = 10;

gridX = (maxX - minX) ./ n;%Ԫ�س���
gridY = (maxY - minY) ./ n;
gridZ = (maxZ - minZ) ./ n;
minX = minX - n1 * gridX;
maxX = maxX + n1 * gridX;
minY = minY - n1 * gridY;
maxY = maxY + n1 * gridY;
minZ = minZ - n1 * gridZ;
maxZ = maxZ + n1 * gridZ;
[bigX, bigY ,bigZ] = meshgrid(minX:gridX:maxX, minY:gridY:maxY,minZ:gridZ:maxZ);%meshgrid����������---��ά
x=minX:gridX:maxX;
y=minY:gridY:maxY;
z=minZ:gridZ:maxZ;

%%
% model.Parameters(1) = 3; 
ntest=size(bigX, 1) * size(bigY, 1)* size(bigZ, 1);
test_dataset=[reshape(bigX, ntest, 1), reshape(bigY, ntest, 1), reshape(bigZ, ntest, 1)];
test_label = ones(size(test_dataset,1), 1);
[W, acc,decision_values] = svmpredict(test_label, test_dataset, model);
bigW = reshape(W, size(bigX, 1), size(bigX, 2),size(bigX, 3));
dataPlusLabel = [test_dataset,W];
boundary = [];
for i = 2:length(dataPlusLabel)
    if dataPlusLabel(i,4)*dataPlusLabel(i-1,4)==-1
        boundary = [boundary;dataPlusLabel(i,1:3)];
    end
    disp(['finish :',num2str(i/length(dataPlusLabel)*100),'%']);
end
figure;
grid on;
scatter3(boundary(:,1),boundary(:,2),boundary(:,3),'gx');
hold on;
scatter3(dataset(1:510,1),dataset(1:510,2),dataset(1:510,3),'bo');
scatter3(dataset(511:end,1),dataset(511:end,2),dataset(511:end,3),'ro');
title('Model');
legend('���೬����','��������','��������');
hold off;
end