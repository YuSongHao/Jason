function svmplot3D(labels,dataset,model,demension1,demension2,demension3)
% svmplot by faruto,changed by Ongleyi

%% ��ת����ע����
% faruto and liyang , LIBSVM-farutoUltimateVersion 
% a toolbox with implements for support vector machines based on libsvm, 2009. 
% 
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
% support vector machines, 2001. Software available at
% http://www.csie.ntu.edu.tw/~cjlin/libsvm
%%

if nargin == 3
    demension1 = 1;
    demension2 = 2;
    demension3 = 3;
end

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
model.Parameters(1) = 3; 
ntest=size(bigX, 1) * size(bigY, 1)* size(bigZ, 1);
test_dataset=[reshape(bigX, ntest, 1), reshape(bigY, ntest, 1), reshape(bigZ, ntest, 1)];
test_label = zeros(size(test_dataset,1), 1);
[W, acc,decision_values] = libsvmpredict(test_label, test_dataset, model);
bigW = reshape(W, size(bigX, 1), size(bigX, 2),size(bigX, 3));
%%
ispos = ( labels == labels(1) );
pos = find(ispos);
neg = find(~ispos);
mu=0;
%  for mu = -1:0.5:1
     figure;
     grid on;
     h1 = plot3( dataset(pos, demension2),dataset(pos, demension1),dataset(pos, demension3), 'r+','Linewidth',2);
     box on;hold on;
     h2 = plot3( dataset(neg, demension2),dataset(neg, demension1),dataset(neg, demension3), 'b*','Linewidth',2);
     box on;hold on;
     h3 = plot3( model.SVs(:,demension2),model.SVs(:,demension1),model.SVs(:,demension3),'go' ,'MarkerSize',10);
     box on;hold on;
     legend([h1,h2,h3],'������','������','֧������');     
     hold on;
     contour3D(y,x,z,bigW,mu);
%      title(['This is figure for mu=' num2str(mu)])
%  end