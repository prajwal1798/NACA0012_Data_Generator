function edgeOrNodePeriodic = nurbsSurfaceIdentifyParamsOnPeriodicityCurve(nurbs, uProj)
%
% edgeOrNodePeriodic = nurbsSurfaceFixPointInversionFacePeriodic(nurbs, uProj)
%

TOL = 1e-5;

posPeriodic = [];
if nurbs.isPeriodic(1)
    posPeriodic = find(uProj(:,1)>nurbs.U(end)-TOL);    
elseif nurbs.isPeriodic(2)
    posPeriodic = find(uProj(:,2)>nurbs.V(end)-TOL);
end

if isempty(posPeriodic)
    edgeOrNodePeriodic = 0;
else
    if all(posPeriodic==[1;2])
        edgeOrNodePeriodic = 1;
    elseif all(posPeriodic==[2;3])
        edgeOrNodePeriodic = 2;
    elseif all(posPeriodic==[1;3])
        edgeOrNodePeriodic = 3;
    else
        edgeOrNodePeriodic = -posPeriodic;
    end
end