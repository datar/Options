tic;
% nPath Ҫ���ɵ�·������
% nInterval ���� 
% K S sigma ִ�м۸� �ֻ��۸� ������
% T r ���뵽�ڵ����� �����޷���������
% �����һ��Ϊһ�����ڵĻ���r���������ʣ����뵽��������T=0.25
% �����3����Ϊ���ڵĻ���r���������µ����ʣ����뵽��������T=1
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
