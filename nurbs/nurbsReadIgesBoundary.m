function nurbs = nurbsReadIgesBoundary(fileNameIGES, nsd, inputCAD)

if nargin==2
    inputCAD = 2;
end

% Use iges2matlab library--------------------------------------------------
ParameterData = iges2matlab(fileNameIGES);

% NEFEM format translation-------------------------------------------------
nPos = length(ParameterData);
iNurbs = 0;

if nsd==2
    for iPos = 1:nPos
        if strcmp(ParameterData{iPos}.name,'B-NURBS CRV')
            nurbsAux.U = ParameterData{iPos}.t;
            w = ParameterData{iPos}.w';
            P = ParameterData{iPos}.p';
            nurbsAux.Pw = [P(:,1).*w P(:,2).*w P(:,3).*w w];
            nurbsAux.iniParam = nurbsAux.U(1);
            nurbsAux.endParam = nurbsAux.U(end);
            
            iNurbs = iNurbs + 1;
            nurbs(iNurbs) = nurbsAux;
        elseif strcmp(ParameterData{iPos}.name,'LINE')
            nurbsAux.U = [0 0 1 1];
            w = [1; 1];
            P = [ParameterData{iPos}.p1'; ParameterData{iPos}.p2'];
            nurbsAux.Pw = [P(:,1).*w P(:,2).*w P(:,3).*w w];
            nurbsAux.iniParam = nurbsAux.U(1);
            nurbsAux.endParam = nurbsAux.U(end);
            
            iNurbs = iNurbs + 1;
            nurbs(iNurbs) = nurbsAux;
        end
    end
elseif nsd==3
    nurbs = nurbsSurfaceReadIges2MatlabStruct(ParameterData, inputCAD);
end
