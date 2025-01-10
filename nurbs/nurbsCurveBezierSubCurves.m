function nurbsSub = nurbsCurveBezierSubCurves(nurbs, quadRef)

Uinterior = nurbs.Uunique(2:end-1);
for u=Uinterior
    multiplicity = sum(nurbs.U==u);
    for k = 1:nurbs.pU+1-multiplicity
        nurbs = nurbsCurveKnotInsertion(nurbs,u,quadRef);
    end
end

% Initialise
nSubCurves = length(nurbs.Uunique)-1;

nOfCPsSub = nurbs.pU+1;
index = 1:nOfCPsSub;
for iSub = 1:nSubCurves    
    nurbsSubTmp.U = [repmat(nurbs.Uunique(iSub), 1, nurbs.pU+1), ...
                        repmat(nurbs.Uunique(iSub+1), 1, nurbs.pU+1)];
    nurbsSubTmp.Pw = nurbs.Pw(index,:);
    index = index + nOfCPsSub;
    nurbsSubTmp.iniParam = nurbs.Uunique(iSub);
    nurbsSubTmp.endParam = nurbs.Uunique(iSub+1);
    
    nurbsSubTmp = nurbsCurveSetupStruct(nurbsSubTmp, quadRef);
    nurbsSub(iSub) = nurbsSubTmp;
end