function [ path ] = initBinomialPath( nInterval )
%INITBINOMIALPATH Summary of this function goes here
%   Detailed explanation goes here
%   
%   generate a matrix contain 0/1 like this
%   0     0     0     0
%   0     0     0     1
%   0     0     1     0
%   0     0     1     1
%   0     1     0     0
%   0     1     0     1
%   0     1     1     0
%   0     1     1     1
%   1     0     0     0
%   1     0     0     1
%   1     0     1     0
%   1     0     1     1
%   1     1     0     0
%   1     1     0     1
%   1     1     1     0
%   1     1     1     1
    narginchk(1,1);
    lineNum = 2^nInterval;
    path = ones(lineNum, nInterval);
    for i = 1:nInterval
        step = lineNum/2^i;
        path(1:step,i) = 0;
        path(step+1:2*step,i) = 1;
        path(:,i) = repmat(path(1:2*step,i),2^(i-1),1);
    end;
end

