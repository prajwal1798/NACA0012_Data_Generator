function X = haltonPoints(nOfParameters, nOfPoints, minVal, maxVal)
%
% X = haltonPoints(nOfParameters, nOfPoints, minVal, maxVal)
%
% Inputs:
% nOfParameters: Number of dimensions/parameters
% nOfPoints:     Number of points required
% minVal:        Minimum value (scalar or vector of dimension nOfParameters)
% maxVal:        Maximum value (scalar or vector of dimension nOfParameters)
%
% Output:
% X:             List of Halton points (nOfPoints x nOfParameters)
%


% Transform to vectors if scalars are provided
if numel(minVal)==1
    minVal = minVal*ones(1, nOfParameters);
end
if numel(maxVal)==1
    maxVal = maxVal*ones(1, nOfParameters);
end

% Halton points in [0,1]^nParam
P = haltonset(nOfParameters);
X = net(P,nOfPoints);

% Scale to the appropriate interval
for iParam = 1:nOfParameters
    X(:,iParam) = minVal(iParam) + X(:,iParam)*( maxVal(iParam) - minVal(iParam) );
end