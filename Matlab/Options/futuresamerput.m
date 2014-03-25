function [price,la]=futuresamerput(s,k,r,T,sigma,N)
%s is the current price of the underlying asset, k is the exercise price 
%of the option,r is the risk-free rate,q is the dividend,T is the maturity length, sigma 
%is the volatility of the asset price, and N is the interval number. 

deltaT=T/N;
u=exp(sigma*sqrt(deltaT));
d=exp(-sigma*sqrt(deltaT));
p=(1-d)/(u-d);
la=zeros(N+1);
for i=1:N+1
    la(i,i)=max(0,k-s*u^(N-i+1)*d^(i-1));
end;
for i=2:N+1
    for j=i-1:(-1):1
        la(i,j)=max(exp(-r*deltaT)*(p*la(i-1,j)+(1-p)*la(i,j+1)),k-s*u^(N-i+1)*d^(j-1));
    end;
end;
price=la(N+1,1);