tic;
% nPath 要生成的路径数量
% nInterval 步数 
% K S sigma 执行价格 现货价格 波动率
% T r 距离到期的期数 单期无风险收益率
% 如果以一年为一个单期的话，r就是年利率，距离到期三个月T=0.25
% 如果以3个月为单期的话，r就是三个月的利率，距离到期三个月T=1
nPath = 10000;
nInterval = 250;
K = 1.05;
S = 1;
T = 1;
r = 0.03;
sigma = 1.2;
[price, profit] = AmericanOptionsLSM(K, T, r, S, sigma, nPath, nInterval);
disp(price);
toc;
