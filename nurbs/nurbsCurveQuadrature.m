function [gauss,weight] = nurbsCurveQuadrature(aNurbs, u1, u2, z01, w01)
%
% [gauss,weight] = nurbsCurveQuadrature(aNurbs, u1, u2, z01, w01)
%

% As only the points are weight are of interest the orientation is ignored
% This is not true when the outward unit normal is of interest (NEFEM face)

uMin = min([u1,u2]);
uMax = max([u1,u2]);

% Define intervals with breakpoints between u1 and u2
Uunique = aNurbs.Uunique;
uInt = [uMin, Uunique(Uunique>uMin & Uunique<uMax), uMax];
    
% Number of subintervals
nOfIntervals = numel(uInt) - 1;

%  Quadrature definition 
nOfPointsSimple = numel(w01);
nOfPoints = nOfPointsSimple*nOfIntervals;
gauss = zeros(nOfPoints, 1);
weight = zeros(nOfPoints, 1);

% Loop over subintervals (changes of definition!)
index = 1:nOfPointsSimple;
for i = 1:nOfIntervals
    uIni = uInt(i);
    uEnd = uInt(i+1);
    Linterval = uEnd-uIni;

    % Map to the parametric space
    gauss(index) = z01*Linterval + uIni;
    weight(index) = w01*Linterval;
    
    % Index
    index = index + nOfPointsSimple;
end