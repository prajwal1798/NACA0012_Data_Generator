function nurbs = nurbsSurfaceSetupStruct(nurbs, quadRef)
%
% nurbs = nurbsSurfaceSetupStruct(nurbs, quadRef)
%
% Completes the NURBS struct with information that is computable but
% time consuming when repeating calls to library functions
%

nOfNurbs = length(nurbs);

fprintf('Setting up NURBS (%d) - ', nOfNurbs)

for iNurbs = 1:nOfNurbs
    nurbs(iNurbs).pU = length(find(nurbs(iNurbs).U==nurbs(iNurbs).U(1))) - 1;
    nurbs(iNurbs).pV = length(find(nurbs(iNurbs).V==nurbs(iNurbs).V(1))) - 1;
    nurbs(iNurbs).mU = length(nurbs(iNurbs).U) - 1;
    nurbs(iNurbs).nU = nurbs(iNurbs).mU - nurbs(iNurbs).pU - 1;
    nurbs(iNurbs).mV = length(nurbs(iNurbs).V) - 1;
    nurbs(iNurbs).nV = nurbs(iNurbs).mV - nurbs(iNurbs).pV - 1;
    
    % Knot vector without repetition of knots
    nurbs(iNurbs).Uunique = unique(nurbs(iNurbs).U);
    nurbs(iNurbs).Uunique = nurbs(iNurbs).Uunique(nurbs(iNurbs).Uunique>=nurbs(iNurbs).U(1));
    nurbs(iNurbs).Uunique = nurbs(iNurbs).Uunique(nurbs(iNurbs).Uunique<=nurbs(iNurbs).U(end));
    nurbs(iNurbs).Uunique = unique([nurbs(iNurbs).U(1), nurbs(iNurbs).Uunique, nurbs(iNurbs).U(end)]);
    
    nurbs(iNurbs).Vunique = unique(nurbs(iNurbs).V);
    nurbs(iNurbs).Vunique = nurbs(iNurbs).Vunique(nurbs(iNurbs).Vunique>=nurbs(iNurbs).V(1));
    nurbs(iNurbs).Vunique = nurbs(iNurbs).Vunique(nurbs(iNurbs).Vunique<=nurbs(iNurbs).V(end));
    nurbs(iNurbs).Vunique = unique([nurbs(iNurbs).V(1), nurbs(iNurbs).Vunique, nurbs(iNurbs).V(end)]);
    
    % Basis functions
    nurbs(iNurbs).Nu = zeros(1,nurbs(iNurbs).pU+1);
    nurbs(iNurbs).Nu(1) = 1;
    nurbs(iNurbs).aux.leftU = zeros(1,nurbs(iNurbs).pU+1);
    nurbs(iNurbs).aux.rightU = zeros(1,nurbs(iNurbs).pU+1);
    
    nurbs(iNurbs).Nv = zeros(1,nurbs(iNurbs).pV+1);
    nurbs(iNurbs).Nv(1) = 1;
    nurbs(iNurbs).aux.leftV = zeros(1,nurbs(iNurbs).pV+1);
    nurbs(iNurbs).aux.rightV = zeros(1,nurbs(iNurbs).pV+1);
    
    % For the computation of first and second order derivatives
    [nurbs(iNurbs).derU, nurbs(iNurbs).derV] = nurbsSurfaceDerivControlPoints(nurbs(iNurbs));
    
    nurbs(iNurbs).derU = nurbsSurfaceBasicConstants(nurbs(iNurbs).derU);
    nurbs(iNurbs).derV = nurbsSurfaceBasicConstants(nurbs(iNurbs).derV);
    
    [nurbs(iNurbs).derUU, nurbs(iNurbs).derUV] = nurbsSurfaceDerivControlPoints(nurbs(iNurbs).derU);
    [nurbs(iNurbs).derVU, nurbs(iNurbs).derVV] = nurbsSurfaceDerivControlPoints(nurbs(iNurbs).derV);
    
    nurbs(iNurbs).derUU = nurbsSurfaceBasicConstants(nurbs(iNurbs).derUU);
    nurbs(iNurbs).derUV = nurbsSurfaceBasicConstants(nurbs(iNurbs).derUV);
    nurbs(iNurbs).derVU = nurbsSurfaceBasicConstants(nurbs(iNurbs).derVU);
    nurbs(iNurbs).derVV = nurbsSurfaceBasicConstants(nurbs(iNurbs).derVV);
    
    % Basis functions
    nurbs(iNurbs).derU = nurbsSurfaceBasicBasisFunctions(nurbs(iNurbs).derU);
    nurbs(iNurbs).derV = nurbsSurfaceBasicBasisFunctions(nurbs(iNurbs).derV);
    
    % Basis functions
    nurbs(iNurbs).derUU = nurbsSurfaceBasicBasisFunctions(nurbs(iNurbs).derUU);
    nurbs(iNurbs).derUV = nurbsSurfaceBasicBasisFunctions(nurbs(iNurbs).derUV);
    nurbs(iNurbs).derVU = nurbsSurfaceBasicBasisFunctions(nurbs(iNurbs).derVU);
    nurbs(iNurbs).derVV = nurbsSurfaceBasicBasisFunctions(nurbs(iNurbs).derVV);
   
    % Sample of surface points
    nurbs(iNurbs).sampleNu = 100;
    nurbs(iNurbs).sampleNv = 100;
    nurbs(iNurbs).sampleN = nurbs(iNurbs).sampleNu*nurbs(iNurbs).sampleNv;
    nurbs(iNurbs).sampleU = linspace(nurbs(iNurbs).U(1), nurbs(iNurbs).U(end), nurbs(iNurbs).sampleNu);
    nurbs(iNurbs).sampleV = linspace(nurbs(iNurbs).V(1), nurbs(iNurbs).V(end), nurbs(iNurbs).sampleNv);
    nurbs(iNurbs).sampleX = zeros(nurbs(iNurbs).sampleN,3);
    kPoint = 1;
    for iPoint=1:nurbs(iNurbs).sampleNu
        for jPoint=1:nurbs(iNurbs).sampleNv
            nurbs(iNurbs).sampleX(kPoint,:) = ...
                nurbsSurfacePoint(nurbs(iNurbs), nurbs(iNurbs).sampleU(iPoint), nurbs(iNurbs).sampleV(jPoint));
            kPoint = kPoint + 1;
        end
    end  
    
    % Check periodicity
    nurbs(iNurbs).isPeriodic = nurbsSurfaceIsPeriodic(nurbs(iNurbs));
    nurbs(iNurbs).curvesPeriodic = nurbsSurfacePeriodicCurves(nurbs(iNurbs));
    
    % Check singularity/degeneracy
    nurbs(iNurbs).isSingular = nurbsSurfaceIsSingular(nurbs(iNurbs));
    
    fprintf('%d ',iNurbs)
    
    % Correction needed for degenerate surfaces
    if any(nurbs(iNurbs).isSingular)
        nurbs(iNurbs) = nurbsSurfaceCorrectParamCurves(nurbs(iNurbs), quadRef);
    end
end
fprintf('\n')