function [boundary] = SVDDPlot3D(dataset,model)
% SVDD三维分类面绘制
% 2018/10/17
% Author:YuSongHao
demension1 = 1;
demension2 = 2;
demension3 = 3;
%%
minX = min(dataset(:, demension1));
maxX = max(dataset(:, demension1));%第一列上的最大最小值
minY = min(dataset(:, demension2));
maxY = max(dataset(:, demension2));%第二列上的最大最小值
minZ = min(dataset(:, demension3));
maxZ = max(dataset(:, demension3));%第三列上的最大最小值
%两个属性=三列

n = 100;n1 = 10;

gridX = (maxX - minX) ./ n;%元素除法
gridY = (maxY - minY) ./ n;
gridZ = (maxZ - minZ) ./ n;
minX = minX - n1 * gridX;
maxX = maxX + n1 * gridX;
minY = minY - n1 * gridY;
maxY = maxY + n1 * gridY;
minZ = minZ - n1 * gridZ;
maxZ = maxZ + n1 * gridZ;
[bigX, bigY ,bigZ] = meshgrid(minX:gridX:maxX, minY:gridY:maxY,minZ:gridZ:maxZ);%meshgrid：生成网格---三维
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
legend('分类超球面','正常样本','故障样本');
hold off;
end