function svmplot(labels,dataset,model,demension1,demension2)
% svmplot by faruto 
% 2009.12.03 
% Email:patrick.lee@foxmail.com  
if nargin == 3 
    demension1 = 1;
    demension2 = 2;
end
%% 
minX = min(dataset(:,demension1));
maxX = max(dataset(:,demension1));
minY = min(dataset(:,demension2));
maxY = max(dataset(:,demension2));

gridX = (maxX - minX)./100;
gridY = (maxY - minY)./100;

minX = minX - 10 * gridX;
maxX = maxX + 10 * gridX; 
minY = minY - 10 * gridY; 
maxY = maxY + 10 * gridY;  

[bigX, bigY] = meshgrid(minX:gridX:maxX, minY:gridY:maxY);

%%  
% model.Parameters(1) = 3;  
ntest=size(bigX, 1) * size(bigX, 2); 
test_dataset=[reshape(bigX, ntest, 1), reshape(bigY, ntest, 1)]; 
test_label = zeros(size(test_dataset,1), 1);  
[Z, acc,preb] = svmpredict(test_label, test_dataset, model);  
bigZ = reshape(Z, size(bigX, 1), size(bigX, 2));  

%% 
% clf; 
hold on; 
grid on;  
ispos = ( labels == labels(1) ); 
pos = find(ispos); 
neg = find(~ispos);
h1 = plot(dataset(pos, demension1), dataset(pos, demension2), 'bo','linewidth',1); 
% h2 = plot(dataset(neg(2:110), demension1), dataset(neg(2:110), demension2), 'g*');
% h3 = plot(dataset(neg(111:190), demension1), dataset(neg(111:190), demension2), 'b*');
% h4 = plot(dataset(neg(191:300),demension1),dataset(neg(191:300),demension2),('y*'));
% h5 = plot(model.SVs(:,demension1),model.SVs(:,demension2),'r+' ); 
% legend([h1,h5],'正常样本','支持向量','Location','SouthEast');
legend(h1,'正常样本','Location','NorthEast');
[C,h] = contour(bigX, bigY, bigZ,-1:0.5:-0.5,'r','linewidth',2); 
% clabel(C,h,'Color','r'); 
xlabel('主成分1','FontSize',12); 
ylabel('主成分2','FontSize',12); 
end