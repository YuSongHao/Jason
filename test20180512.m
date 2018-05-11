%% SVDD仿真实验：不同核函数参数σ和惩罚因子C下的支持向量曲线绘制
%  author:YuSongHao
%  2018.05.12
sigma = 0.005:0.05:1;
for i = 1:4
    filename = ['nsv_c',num2str(i),'.mat'];
    load(filename);
    plot(sigma,nsv);
    hold on
end