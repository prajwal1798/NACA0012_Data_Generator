function [nodesSingular, uProj] = nurbsSurfaceFixPointInversionFaceSingular(nurbs, uProj)
%
% nodesSingular = nurbsSurfaceFixPointInversionFaceSingular(nurbs, uProj)
%
TOL = 1e-5;

% Ordering
% 4-------3
% |       |
% 1-------2

if nurbs.isSingular(1)
    nodesSingular1 = find(uProj(:,1)<nurbs.U(1)+TOL);
    uProj(nodesSingular1,2) = nurbs.V(1);
else
    nodesSingular1 = [];
end

if nurbs.isSingular(2)
    nodesSingular2 = find(uProj(:,1)>nurbs.U(end)-TOL);
    uProj(nodesSingular2,2) = nurbs.V(1);
else
    nodesSingular2 = [];
end

if nurbs.isSingular(3)
    nodesSingular3 = find(uProj(:,2)<nurbs.V(1)+TOL);
    uProj(nodesSingular3,1) = nurbs.U(1);
else
    nodesSingular3 = [];
end

if nurbs.isSingular(4)
    nodesSingular4 = find(uProj(:,2)>nurbs.V(end)-TOL);
    uProj(nodesSingular4,1) = nurbs.U(1);
else
    nodesSingular4 = [];
end

nodesSingular = [nodesSingular1, nodesSingular2, nodesSingular3, nodesSingular4];
