function fu = nurbsCurveSample(nurbs, iniParam, endParam, nPoints)
%
% fu = nurbsCurveSample(nurbs, iniParam, endParam, nPoints)
%

% By default options
if nargin < 2
    iniParam = nurbs.iniParam;
    endParam = nurbs.endParam;
end

if nargin < 4
    nPoints = 1000;
end

% Curve points
fu = zeros(nPoints,3);
uVector = linspace(iniParam,endParam,nPoints);
for iPoint = 1:nPoints
    fu(iPoint,:) = nurbsCurvePoint(nurbs,uVector(iPoint));
end
