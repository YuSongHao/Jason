%%==================================================
% Function: read one MPS-140801 Data File
% Parameter: filePath(char), the path of '*.bin' to be read;
%            nChannels(integer), save channels of MPS-140801
%            sensitivity(double or vector), sensitivity of each channel
%            data(matrix), the data to be get
% Usage : If sensitivity is double, it sets sensitivity for all the channels,
%         If sensitivity is vector, it sets sensitivity for each channel.
%         Each channel is stored in the column of data.
% Other : The format of file is (header + channelData). The length of header is
%         70 + 7 * nChannels. The channelData is stored in turns with the format
%         of IEEE floating point and big-endian byte ordering.
% Author : jiapeidong
% Date : 2016/08/23
%%==================================================

function data = MPS_read( filePath, nChannels, sensitivity)

%% input check
% check for filePath
fid = fopen( filePath,'r','b');
if( fid == -1)
    error('File can not open.');
end

% check for nChannels
isValid = (length(nChannels) == 1) & (nChannels >=1 ) & (nChannels <=8 );
isValid = isValid & ( fix(nChannels) == nChannels);
if (~isValid)
    error('Number of channel error.\n nChannel is %s', char(nChannels));
end

% check for sensitivity
isValid = (length(sensitivity) == 1) || (length(sensitivity) == nChannels);
isValid = isValid & isvector(sensitivity);
if(~isValid)
    error('sensitivity error.');
end

%% deal with file
fseek(fid, 70 + nChannels * 7,-1);
data = fread(fid, inf, 'float', 'b');
data = reshape(data, [nChannels, length(data) / nChannels]);
data = data';
if(length(sensitivity) == 1)
    data = data / sensitivity;
else
    for iChannel = 1 : nChannels
        data(:, iChannel) = data(:, iChannel) / sensitivity(iChannel);
    end
end