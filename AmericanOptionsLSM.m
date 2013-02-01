function [ price, profit ] = AmericanOptionsLSM( K, T, r, S, sigma, nPath, nInterval )
%   
%   Detailed explanation goes here
    sMatrix = getSimulationMatrix(nPath, nInterval, S, T, r, sigma);
    discount = exp(-r*T/nInterval);
    profit = K - sMatrix;
    inMoneyIndice = (profit>0);
    profit(~inMoneyIndice) = 0;
    for i = (nInterval-1):-1:1
        indice = inMoneyIndice(:,i);
        x = sMatrix(indice,i)/S;
        y = profit(indice,i+1)*discount;
        Rm = [ ones(size(x)) (1-x) 1/2*(2-4*x-x.^2)];
        ey = zeros([nPath,1]);
        ey(indice,1) = Rm*(Rm\y);
        excutePos = ((profit(:,i) - ey)>0);
        profit(~excutePos,i) = profit(~excutePos,i+1)*discount;
    end
    price = mean(profit(:,1));
end
