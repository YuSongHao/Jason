filepath = '201842694843.bin';
nchannels = 1;
sensitivity = 1;
data = MPS_read(filepath,nchannels,sensitivity);
data = data/max(data);
audiowrite('201842694843.wav',data,64000);