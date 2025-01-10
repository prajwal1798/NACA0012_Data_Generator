function nurbsCurvePlot(nurbs, iniParam, endParam, col, nPoints, optPlot)
%
% nurbsCurvePlot(nurbs, iniParam, endParam, nPoints)
%
% Input:
% nurbs: struct containing the nurbs curve information
% iniParam, endParam:   trimmed NURBS  (complete NURBS by default)
% nPoints:              Number of points 
%

% By default options
if nargin < 2
    iniParam = nurbs.iniParam;
    endParam = nurbs.endParam;
end

if nargin < 4
    col = 'k-';
end

if nargin < 5
    nPoints = 1000;
end

if nargin < 6
    optPlot = 0;
end

% Curve points
fu = zeros(nPoints,3);
uVector = linspace(iniParam,endParam,nPoints);
for iPoint = 1:nPoints
    fu(iPoint,:) = nurbsCurvePoint(nurbs,uVector(iPoint));
end
hold on
plot3(fu(:,1), fu(:,2), fu(:,3), col, 'LineWidth', 2.5, 'DisplayName', 'Initial Profile')

% plot3(fu([1,end],1), fu([1,end],2), fu([1,end],3), 'rx', 'LineWidth', 2)

if optPlot
    hold on
    plot3(nurbs.Pw(:,1)./nurbs.Pw(:,4), nurbs.Pw(:,2)./nurbs.Pw(:,4), nurbs.Pw(:,3)./nurbs.Pw(:,4), 'b-s')
    UU = unique(nurbs.U);
    for u=UU
        pt = nurbsCurvePoint(nurbs, u);
        plot3(pt(1),pt(2),pt(3),'ko');
    end
end

