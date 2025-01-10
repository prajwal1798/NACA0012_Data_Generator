function nurbs = nurbsSurfaceReadIges2MatlabStruct(ParameterData, inputCAD)
%
% nurbs = nurbsSurfaceReadIges2MatlabStruct(ParameterData, inputCAD)
%

% ParameterData contains nurbs from third position
nPos = length(ParameterData);
lastCurvePhysical=0;
iNurbs = 0;
for iPos = 1:nPos
    if strcmp(ParameterData{iPos}.name,'B-NURBS SRF')
        
        nurbsIges = ParameterData{iPos};
        nurbsAux.U = nurbsIges.s;
        nurbsAux.V = nurbsIges.t;
        P = [];
        w = [];
        Paux = permute(nurbsIges.p,[2 1 3]);
        wAux = nurbsIges.w;
        
        for i = 1:size(Paux, 3)
            P = [P; Paux(:,:,i)];
            w = [w; wAux(:,i)];
        end
        
        nurbsAux.Pw = [P(:,1).*w P(:,2).*w P(:,3).*w w];
        nurbsAux.trimmed =  [nurbsAux.U(1) nurbsAux.V(1)
            nurbsAux.U(end) nurbsAux.V(1)
            nurbsAux.U(end) nurbsAux.V(end)
            nurbsAux.U(1) nurbsAux.V(end)];
        nurbsAux.nOfCurves = 0;
        nurbsAux.nOfCurvesParam = 0;
        nurbsAux.isTrimmed = 0;
        
        iNurbs = iNurbs + 1;
        nurbs(iNurbs) = nurbsAux;
        iNurbsCurves = 0;
        iNurbsCurvesParam = 0;
        
    elseif strcmp(ParameterData{iPos}.name,'B-NURBS CRV')
        nurbsCurvesAux.U = ParameterData{iPos}.t;
        w = ParameterData{iPos}.w';
        P = ParameterData{iPos}.p';
        nurbsCurvesAux.Pw = [P(:,1).*w P(:,2).*w P(:,3).*w w];
        nurbsCurvesAux.iniParam = nurbsCurvesAux.U(1);
        nurbsCurvesAux.endParam = nurbsCurvesAux.U(end);
        
        if inputCAD==1
            % GID
            if ParameterData{iPos}.superior==0
                iNurbsCurves = iNurbsCurves + 1;
                nurbsCurves(iNurbs).curves(iNurbsCurves) = nurbsCurvesAux;
            else
                iNurbsCurvesParam = iNurbsCurvesParam + 1;
                nurbsCurves(iNurbs).curvesParam(iNurbsCurvesParam) = nurbsCurvesAux;
            end
        elseif inputCAD==2
            % RHINO
            if lastCurvePhysical==0
                iNurbsCurves = iNurbsCurves + 1;
                nurbsCurves(iNurbs).curves(iNurbsCurves) = nurbsCurvesAux;
                lastCurvePhysical = 1;
            else
                iNurbsCurvesParam = iNurbsCurvesParam + 1;
                nurbsCurves(iNurbs).curvesParam(iNurbsCurvesParam) = nurbsCurvesAux;
                lastCurvePhysical = 0;
            end
        end
        nurbs(iNurbs).nOfCurves = iNurbsCurves;
        nurbs(iNurbs).nOfCurvesParam = iNurbsCurvesParam;
    end
end

% For computing length
quadRef = defineQuadratureAdaptive();

for i = 1:iNurbs
    if nurbs(i).nOfCurves>0
        nurbs(i).isTrimmed = 1;
        
        nurbsCurves(i).curves = nurbsCurveSetupStruct(nurbsCurves(i).curves, quadRef);
        nurbsCurves(i).curvesParam = nurbsCurveSetupStruct(nurbsCurves(i).curvesParam, quadRef);
        for j = 1:nurbs(i).nOfCurves
            nurbs(i).curves(j) = nurbsCurves(i).curves(j);
            nurbs(i).curvesParam(j) = nurbsCurves(i).curvesParam(j);
        end
    else
        % Degenerate surfaces can have only two curves in the IGES file
        % Here the boundary are auto-generated
        nurbsCurvesAux = nurbsSurfaceExtractBoundaryCurvesNonTrimmed(nurbs(i));
        nurbs(i).nOfCurves = 4;
        nurbs(i).nOfCurvesParam = 4;
        for j = 1:nurbs(i).nOfCurves
            nurbs(i).curves(j) = nurbsCurvesAux.curves(j);
            nurbs(i).curvesParam(j) = nurbsCurvesAux.curvesParam(j);
        end
    end
end


% Remove singular curves if present ---------------------------------------
TOL = 1e-5;
for i = 1:iNurbs
    vSingularCurves = [];
    for j = 1:nurbs(i).nOfCurves        
        if nurbs(i).curves(j).length<TOL
            vSingularCurves = [vSingularCurves, j];
        end
    end
    vNonSingularCurves = setdiff(1:nurbs(i).nOfCurves,vSingularCurves);
    % Store non-singular curves
    nurbs(i).curvesParam = nurbs(i).curvesParam(vNonSingularCurves);
    nurbs(i).nOfCurvesParam = numel(nurbs(i).curvesParam);
    
    nurbs(i).curves = nurbs(i).curves(vNonSingularCurves);
    nurbs(i).nOfCurves = numel(nurbs(i).curves);    
end
