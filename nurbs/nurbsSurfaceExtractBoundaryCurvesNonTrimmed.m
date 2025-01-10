function nurbsCurves = nurbsSurfaceExtractBoundaryCurvesNonTrimmed(nurbs)

pU = length(find(nurbs.U==nurbs.U(1))) - 1;
pV = length(find(nurbs.V==nurbs.V(1))) - 1;
mU = length(nurbs.U) - 1;
nU = mU - pU - 1;
mV = length(nurbs.V) - 1;
nV = mV - pV - 1;

nCPu = nU+1;
nCPv = nV+1;
nTOT = nCPu*nCPv;
nAux = nCPu*(nCPv-1)+1;

% For computing length
quadRef = defineQuadratureAdaptive();

% v=0 right direction -----------------------------------------------------
pos = 1:nCPu;
% Physical curve
nurbsCurveAux.U = nurbs.U;
nurbsCurveAux.iniParam = nurbs.U(1);
nurbsCurveAux.endParam = nurbs.U(end);
nurbsCurveAux.Pw = nurbs.Pw(pos,:);
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curves(1) = nurbsCurveAux;
% Parametric curve
nurbsCurveAux.U = [0 0 1 1];
nurbsCurveAux.iniParam = 0;
nurbsCurveAux.endParam = 1;
nurbsCurveAux.Pw = [nurbs.U(1) nurbs.V(1) 0 1; nurbs.U(end) nurbs.V(1) 0 1];
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curvesParam(1) = nurbsCurveAux;

% u=end up direction ------------------------------------------------------
pos = nCPu:nCPu:nTOT;
% Physical curve
nurbsCurveAux.U = nurbs.V;
nurbsCurveAux.iniParam = nurbs.V(1);
nurbsCurveAux.endParam = nurbs.V(end);
nurbsCurveAux.Pw = nurbs.Pw(pos,:);
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curves(2) = nurbsCurveAux;
% Parametric curve
nurbsCurveAux.U = [0 0 1 1];
nurbsCurveAux.iniParam = 0;
nurbsCurveAux.endParam = 1;
nurbsCurveAux.Pw = [nurbs.U(end) nurbs.V(1) 0 1; nurbs.U(end) nurbs.V(end) 0 1];
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curvesParam(2) = nurbsCurveAux;

% v=end left direction ----------------------------------------------------
pos = nTOT:-1:nAux;
% Physical curve
nurbsCurveAux.U = nurbs.U(end) - fliplr(nurbs.U);
nurbsCurveAux.iniParam = 0;
nurbsCurveAux.endParam = nurbs.U(end) - nurbs.U(1);
nurbsCurveAux.Pw = nurbs.Pw(pos,:);
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curves(3) = nurbsCurveAux;
% Parametric curve
nurbsCurveAux.U = [0 0 1 1];
nurbsCurveAux.iniParam = 0;
nurbsCurveAux.endParam = 1;
nurbsCurveAux.Pw = [nurbs.U(end) nurbs.V(end) 0 1; nurbs.U(1) nurbs.V(end) 0 1];
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curvesParam(3) = nurbsCurveAux;

% u=0 down direction ------------------------------------------------------
pos = nAux:-nCPu:1;
% Physical curve
nurbsCurveAux.U = nurbs.V(end) - fliplr(nurbs.V);
nurbsCurveAux.iniParam = 0;
nurbsCurveAux.endParam = nurbs.V(end) - nurbs.V(1);
nurbsCurveAux.Pw = nurbs.Pw(pos,:);
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curves(4) = nurbsCurveAux;
% Parametric curve
nurbsCurveAux.U = [0 0 1 1];
nurbsCurveAux.iniParam = 0;
nurbsCurveAux.endParam = 1;
nurbsCurveAux.Pw = [nurbs.U(1) nurbs.V(end) 0 1; nurbs.U(1) nurbs.V(1) 0 1];
nurbsCurveAux = nurbsCurveSetupStruct(nurbsCurveAux, quadRef);
nurbsCurves.curvesParam(4) = nurbsCurveAux;


