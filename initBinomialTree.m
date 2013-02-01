function [ tree ] = initBinomialTree( S, nInterval, u, d )
% init a binomial tree like the format in classic options book
%   !!! IMPORTANT NOTICE u=1/d is 
%   price binomial tree by a matrix like this
%   Price(m,n) = S*u^(n-m)*d^(m-1) where m<=n
%   Price(m,n) = S*d^(n-1)
%   1 us uus uuus ...  
%     ds uds duus
%        dds duds
%            ddds
%   ...
%   for ease to use, each line of the matrix is a path of price, like this
%   1 us uus uuus ...  
%   1 ds uds duus
%   1 ds dds duds
%   1 ds dds ddds
%   ...



%%  CHANGE LOG
%   20130131:
%   1.origin function change the parameters list,from (S,u,d,nInterval) to (S,nInterval,u)
%       this is used for classic form that d=1/d
%   2.add new parameter list (S,nInterval,u,d) that is used for u!=1/d
%
%

narginchk(3,4);

if nargin == 3
    d = 1/u;
    tree = S*ones(nInterval+1);
    for i = 2:(nInterval+1)
        tree(1:(i-1),i) = tree(1:(i-1),i-1)*u;
        tree(i:nInterval+1,i) = tree(i-1,i-1)*d;
    end;
end;

if nargin == 4
    tree = S*ones(2^nInterval);
    for i = 2:(nInterval+1)
        tree(1:(i-1),i) = tree(1:(i-1),i-1)*u;
        tree(i:nInterval+1,i) = tree(i-1,i-1)*d;
    end;
end;
end

