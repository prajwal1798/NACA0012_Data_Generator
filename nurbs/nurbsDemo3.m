%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NURBS Demo 3 - SURFACES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;
close all; 
clc; setpath;

% Demo 3: Reading from an IGS file ----------------------------------------
% 3D
nsd = 3;

% Define .igs file
fileNameIGES = 'cylinder.igs';

% Read igs file using an external library (iges2matlab)
nurbs = nurbsReadIgesBoundary(fileNameIGES, nsd, 1);

% Create integration structure (length computation)
quadRef = defineQuadratureAdaptive();

% Compute extra fields in the NURBS structure (to accelerate operations)
nurbs = nurbsSetupStruct(nurbs, quadRef, nsd);

% Plot the different NURBS in different figures
for iNurbs = 1:numel(nurbs)
    figure(iNurbs)
    nurbsSurfacePlot(nurbs(iNurbs),[],50,1)
end

% Plot all the NURBS without the control net
figure, hold on
for iNurbs = 1:numel(nurbs)    
    nurbsSurfacePlot(nurbs(iNurbs))
end

% Plot a parametric space
figure
nurbsSurfacePlotParametricSpace(nurbs(1))

% Plot intersection curves in the physical space
figure
nurbsCurveBoundaryPlot(nurbs(1).curves,1)

% Plot intersection curves in the parametric space
figure
nurbsCurveBoundaryPlot(nurbs(1).curvesParam,1)


% TASK 1: Repeat task 1 of demo 1
% TASK 2: Repeat task 2 of demo 1 (with surface functions)