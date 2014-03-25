function [ price, tree ] = AmericanPutBT( s,k,r,T,sigma,N )
%AMERICANPUTBT Summary of this function goes here
%   Detailed explanation goes here

%s is the current price of the underlying asset, k is the exercise price 
%of the option,r is the risk-free rate,q is the dividend,T is the maturity length, sigma 
%is the volatility of the asset price, and N is the interval number. 

deltaT=T/N;
u=exp(sigma*sqrt(deltaT));
d=exp(-sigma*sqrt(deltaT));
p=(1-d)/(u-d);
tree=zeros(N+1);

for i=1:N+1
    tree(i,i)=max(0,k-s*u^(N-i+1)*d^(i-1));
end;
for i=2:N+1
    for j=i-1:(-1):1
        tree(i,j)=max(exp(-r*deltaT)*(p*tree(i-1,j)+(1-p)*tree(i,j+1)),k-s*u^(N-i+1)*d^(j-1));
    end;
end;
price=tree(N+1,1);

tree = zeros(N+1);

end

