function [ price, profit ] = AmericanPutOptionsLSM( K, T, r, S, sigma, nPath, nInterval )
%   
%   Detailed explanation goes here
    sMatrix = getSimulationMatrix(nPath, nInterval, S, T, r, sigma);
    discount = exp(-r*T/nInterval);
    profit = K - sMatrix;
    inMoneyIndice = (profit>0);
    profit = profit.*inMoneyIndice;
    for i = (nInterval-1):-1:1
        indice = inMoneyIndice(:,i);
        x = sMatrix(indice,i);
        y = profit(indice,i+1)*discount;
        p = polyfit(x, y, 2);
        Eprofit = zeros([nPath, 1]);
        Eprofit(indice, 1) = polyval(p, x);
        pos = ((profit(:,i)-Eprofit)>0);
        profit(:, i) = profit(:, i).*pos;
    end
    current = zeros(nPath, 1);
    for i = 1:nInterval
        lines = (profit(:,i)>0);
        profit(lines, (i+1):end) = 0;
        current(lines,1) = profit(lines,i)*(discount^i);
    end
    price = mean(current);
end

