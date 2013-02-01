function [ price ] = AmericanCallOptionsBT( K, S, sigma, T, r, q, nInterval )
%AMERICANCALLOPTIONSBT Summary of this function goes here
%   Detailed explanation goes here

    %% init parameters
    dt = T/nInterval;
    u = exp(sigma*dt^0.5);
    d = 1/u;
    a = exp((r-q)*dt);
    p = (a-d)/(u-d);
    discountFac = exp(-r*dt);
    
    priceTree = initBinomialTree(S, u, d, nInterval);

    %% price
    profit = max(priceTree - K, 0);
    for i=nInterval:-1:1
        Ep = (p*profit(1:i,i+1)+(1-p)*profit(2:(i+1),i+1))*discountFac;
        profit(1:i,i) = max(profit(1:i,i), Ep);
    end;
    price = profit(1,1);
end
