clear;clc;
filePath = 'L:\MHM\ҶƬ������\����\����';
Fs = 6.4e4;
% ��ȡ�ļ������е�mat�ļ�
fileList = dir([filePath, '\*.mat']);
for idxFile = 1 : length(fileList)
    % read data
    fileName = [filePath, '\', fileList(idxFile).name];
    dataLoad = load(fileName);
    data = dataLoad.data(1,:);
    data = data/max(data);
    remove_mat = fileList(idxFile).name;
    remove_mat(end-3:end) = [];
    filename_wav = [remove_mat,'.wav'];
    audiowrite(filename_wav,data,Fs);
end
% mkdir myfolder
% movefile sample_remodified.m myfolder