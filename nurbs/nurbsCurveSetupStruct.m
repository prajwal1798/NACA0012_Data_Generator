function nurbs = nurbsCurveSetupStruct(nurbs, quadRef)
%
% nurbs = nurbsCurveSetupStruct(nurbs, quadRef)
%
% Completes the NURBS struct with information that is computable but
% time consuming when repeating calls to library functions
%

lengthTOL = 1e-6;
nOfNurbs = length(nurbs);

for iNurbs = 1:nOfNurbs    
    % Degree, number of spans and knots
    nurbs(iNurbs).pU = length(find(nurbs(iNurbs).U==nurbs(iNurbs).U(1))) - 1;
    nurbs(iNurbs).mU = length(nurbs(iNurbs).U) - 1;
    nurbs(iNurbs).nU = nurbs(iNurbs).mU - nurbs(iNurbs).pU - 1;
    
    % Initial and final physical points and check periodicity
    nurbs(iNurbs).pIni = nurbsCurvePoint(nurbs(iNurbs), nurbs(iNurbs).iniParam);
    nurbs(iNurbs).pEnd = nurbsCurvePoint(nurbs(iNurbs), nurbs(iNurbs).endParam);
    if(norm(nurbs(iNurbs).pIni-nurbs(iNurbs).pEnd)<lengthTOL)
        nurbs(iNurbs).isPeriodic = 1;
    else
        nurbs(iNurbs).isPeriodic = 0;
    end
    
    % Knot vector without repetition of knots
    nurbs(iNurbs).Uunique = unique(nurbs(iNurbs).U);
    nurbs(iNurbs).Uunique = nurbs(iNurbs).Uunique(nurbs(iNurbs).Uunique>=nurbs(iNurbs).iniParam);
    nurbs(iNurbs).Uunique = nurbs(iNurbs).Uunique(nurbs(iNurbs).Uunique<=nurbs(iNurbs).endParam);
    nurbs(iNurbs).Uunique = unique([nurbs(iNurbs).iniParam, nurbs(iNurbs).Uunique, nurbs(iNurbs).endParam]);
        
    % Basis functions
    nurbs(iNurbs).Nu = zeros(1,nurbs(iNurbs).pU+1);
    nurbs(iNurbs).Nu(1) = 1;
    nurbs(iNurbs).aux.leftU = zeros(1,nurbs(iNurbs).pU+1);
    nurbs(iNurbs).aux.rightU = zeros(1,nurbs(iNurbs).pU+1);
    
    % For the computation of first and second order derivatives
    nurbs(iNurbs).derU = nurbsCurveDerivControlPoints(nurbs(iNurbs));
    nurbs(iNurbs).derUU = nurbsCurveSecondDerivControlPoints(nurbs(iNurbs));
    
    % Basis functions
    nurbs(iNurbs).derU = nurbsCurveBasicBasisFunctions(nurbs(iNurbs).derU);
    nurbs(iNurbs).derUU = nurbsCurveBasicBasisFunctions(nurbs(iNurbs).derUU);
    
    % Sample of curve points
    nurbs(iNurbs).sampleN = 400;
    nurbs(iNurbs).sampleU = linspace(nurbs(iNurbs).iniParam, nurbs(iNurbs).endParam, nurbs(iNurbs).sampleN);
    nurbs(iNurbs).sampleX = zeros(nurbs(iNurbs).sampleN,3);
    for iPoint=1:nurbs(iNurbs).sampleN
        nurbs(iNurbs).sampleX(iPoint,:) = nurbsCurvePoint(nurbs(iNurbs), nurbs(iNurbs).sampleU(iPoint));
    end
    
    % Length
    nurbs(iNurbs).length = nurbsCurveLengthAdaptive(nurbs(iNurbs), nurbs(iNurbs).U(1), nurbs(iNurbs).U(end), quadRef, lengthTOL);
end