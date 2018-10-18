fid = fopen('20000101122320.bin','r');
data = fread(fid,inf,'double');
figure
plot(data);
save 20000101122320.mat data;
audiowrite('20000101122320.wav',data/(2*max(data)),44100);
fclose(fid);