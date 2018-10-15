Feature = Feature(1:510,:);
trainlabel = ones(length(Feature),1);
Model = svmtrain(trainlabel,Feature,'-s 5 -t 2 -g 1 -c 0.1');
[predict_label,accuracy,decision_values] = svmpredict(trainlabel ,Feature,Model);

maxx = max(Feature(:,1));
minx = min(Feature(:,1));
maxy = max(Feature(:,2));
miny = min(Feature(:,2));
maxz = max(Feature(:,3));
minz = min(Feature(:,3));
x = minx:0.02:maxx;
y = miny:0.02:maxy;
z = minz:0.02:maxz;
% [bigX, bigY ,bigZ] = meshgrid(x,y,z);
% ntest=size(bigX, 1) * size(bigY, 1)* size(bigZ, 1);
% test_dataset=[reshape(bigX, ntest, 1), reshape(bigY, ntest, 1), reshape(bigZ, ntest, 1)];

A = [];B = []; C = [] ;
cube = zeros(length(x)*length(y)*length(z),3);
for i = 1:length(x)
    temp = ones(length(y)*length(z),1)*x(i);
    A = [A;temp];
end
cube(:,1) = A;
clear A temp i;
B1 = [];
for i = 1:length(y)
    temp = ones(length(z),1)*y(i);
    B1 = [B1;temp];
end
for i = 1:length(x)
    B = [B;B1];
end
cube(:,2) = B;
clear B B1 temp i;
for i = 1:length(x)*length(y)
    C = [C,z];
end
C = C';
cube(:,3) = C;
clear C i;
save cube.mat cube;

count = 0;
True = [];
for i = 1:length(x)
    X = x(i);
    for j = 1:length(y)
        Y = y(j);
        for k = 1:length(z)
            Z = z(k);
            testdata = [X,Y,Z];
            testlabel = 1;
            acc = svmpredict(testlabel,testdata,Model10);
            count = count+1;
            if acc ==1
                True = [True;cube(i*j*k,1:3)];
            end
            cube(count,4) = acc;
            disp(count);
        end
    end
end 
% figure;
scatter3(Feature(:,1),Feature(:,2),Feature(:,3));
hold on
scatter3(True(:,1),True(:,2),True(:,3));
