%% 批量转换bin文件
filePath = 'I:\200001';
cd(filePath);
fileList = dir([filePath, '\*.bin']);
for idxFile = 1 : length(fileList)
    binName = fileList(idxFile).name;
    fileName = [filePath, '\', fileList(idxFile).name];
    fid = fopen(fileName,'r');
    data = fread(fid,inf,'double');
    matName = [binName(1:end-3),'mat'];
    save(matName,'data');
    fclose(fid);
end
% mat数据拼接
fileList = dir([filePath,'\*.mat']);
Data = [];
for idxFile = 1:length(fileList)
    fileName = [filePath, '\', fileList(idxFile).name];
    dataLoad = load(fileName);
    data = dataLoad.data(:,1);
    Data = [Data;data];
end
save pureBackgroundNoise20181018.mat Data;
audiowrite('pureBackgroundNoise20181018.wav',Data/max(Data),44100);