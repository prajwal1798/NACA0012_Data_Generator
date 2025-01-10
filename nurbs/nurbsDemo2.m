%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NURBS Demo 2 - CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;
close all; 
clc; setpath;

% Demo 2: Reading from an IGS file ----------------------------------------
% 2D
nsd = 2;

% Define .igs file
fileNameIGES = 'plateHoleSym.igs';

% Read igs file using an external library (iges2matlab)
nurbs = nurbsReadIgesBoundary(fileNameIGES, nsd);

% Create integration structure (length computation)
quadRef = defineQuadratureAdaptive();

% Compute extra fields in the NURBS structure (to accelerate operations)
nurbs = nurbsSetupStruct(nurbs, quadRef, nsd);

% How to plot several NURBS
nurbsCurveBoundaryPlot(nurbs, 1)

% TASK: Check how several NURBS are stored