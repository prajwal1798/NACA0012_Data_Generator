function nurbs = nurbsSurfaceCreatePlane(xV, yV)

[X,Y] = meshgrid(xV,yV);
X = X';
Y = Y';
P = [X(:), Y(:), 0*X(:)];

Nu = length(xV);
Nv = length(yV);

N = size(P,1);
Pw = zeros(N,4);
Pw(:,1) = P(:,1);
Pw(:,2) = P(:,2);
Pw(:,3) = P(:,3);
Pw(:,4) = 1;

% Assume quadratic
qU = 2;
qV = 2;
nOfInteriorKnotsU = Nu - (qU+1);
nOfInteriorKnotsV = Nv - (qV+1);

uLin = [zeros(1,qU+1), linspace(0,1,nOfInteriorKnotsU+2), ones(1,qU+1)];
vLin = [zeros(1,qV+1), linspace(0,1,nOfInteriorKnotsV+2), ones(1,qV+1)];

U = uLin(2:end-1);
V = vLin(2:end-1);


nurbs.U = U;
nurbs.V = V;
nurbs.Pw = Pw;
nurbs.trimmed = [nurbs.U(1) nurbs.V(1)
    nurbs.U(end) nurbs.V(1)
    nurbs.U(end) nurbs.V(end)
    nurbs.U(1) nurbs.V(end)];


nurbs.isTrimmed = 0;

% Intersection curves
nurbsCurvesAux = nurbsSurfaceExtractBoundaryCurvesNonTrimmed(nurbs);
nurbs.nOfCurves = 4;
nurbs.nOfCurvesParam = 4;
for j = 1:nurbs.nOfCurves
    nurbs.curves(j) = nurbsCurvesAux.curves(j);
    nurbs.curvesParam(j) = nurbsCurvesAux.curvesParam(j);
end