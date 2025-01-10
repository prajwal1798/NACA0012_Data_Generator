function uProj = nurbsSurfaceFixPointInversionFacePeriodic(nurbs, uProj)
%
% uProj = nurbsSurfaceFixPointInversionFacePeriodic(nurbs, uProj)
%

if nurbs.isPeriodic(1)
    uProj(:,1) = nurbsSurfaceFixPointInversionFacePeriodicOneDirection(nurbs.U, uProj(:,1));
end

if nurbs.isPeriodic(2)
    uProj(:,2) = nurbsSurfaceFixPointInversionFacePeriodicOneDirection(nurbs.V, uProj(:,2));
end

function u  = nurbsSurfaceFixPointInversionFacePeriodicOneDirection(U, u)

TOL = 1e-5;
nOfFacePoints = length(u);

% Mid point in the parametric space
meanU = 0.5*(U(1)+U(end));

% Check values of parameter equal to U(1) to be changed to U(end)
posLeft = find(u<U(1)+TOL);
posRest = setdiff(1:nOfFacePoints,posLeft);
if all(u(posRest)>meanU)
    u(posLeft) = U(end);
end

% Check values of parameter equal to U(end) to be changed to U(1)
posRight = find(u>U(end)-TOL);
posRest = setdiff(1:nOfFacePoints,posRight);
if all(u(posRest)<meanU)
    u(posRight) = U(1);
end