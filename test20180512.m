%% SVDD����ʵ�飺��ͬ�˺��������Һͳͷ�����C�µ�֧���������߻���
%  author:YuSongHao
%  2018.05.12
sigma = 0.005:0.05:1;
for i = 1:4
    filename = ['nsv_c',num2str(i),'.mat'];
    load(filename);
    plot(sigma,nsv);
    hold on
end