function nurbs = nurbsSetupStruct(nurbs, quadRef, nsd)
%
% nurbs = nurbsSetupStruct(nurbs, quadRef, nsd)
%

if nsd==2
    nurbs = nurbsCurveSetupStruct(nurbs, quadRef);
elseif nsd==3
    nurbs = nurbsSurfaceSetupStruct(nurbs, quadRef);
end