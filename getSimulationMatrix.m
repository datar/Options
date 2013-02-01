function [ SMatrix ] = getSimulationMatrix( nPath, nInterval, S, T, r, sigma )
%Generate Monte Carlo paths. Return paths in a matrix
%   nPath:  the number of paths those would be generate   
%   nInterval:  number of steps 
%   S:  stock price
%   T:  time from begin to end 
%   r:  risk-free interest rate
%   sigma: just the sigma
%   each row of the matrix is a path
%
%
%

    
    epsilons = normrnd(0, 1, nPath, nInterval);
    dT = T/nInterval;
    steps = repmat(1:nInterval, nPath, 1);
    
    %% there were many ways to generate the path, 1000 book/people 1000 ways
    %
    %dS = exp(steps.*((r-sigma*sigma/2)*dT*ones([nPath,nInterval]) + sigma*sqrt(dT)*epsilons));
    %
    %dS = exp(steps*(r-sigma*sigma/2)*dT + sigma*sqrt(dT*steps).*epsilons);
    
    dS = exp(steps*(r-sigma*sigma/2)*dT + sigma*sqrt(dT)*cumsum(epsilons,2));
    SMatrix = S*dS;
end

