%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NURBS Demo 1 - CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;
close all; 
clc; setpath;

% Demo 1: Creation and plotting of a simple NURBS curve -------------------
% 2D
nsd = 2;

% Create a simple NURBS
nurbs = nurbsCurveCreateCircle([0 0], 3);

% Create integration structure (length computation)
quadRef = defineQuadratureAdaptive();

% Compute extra fields in the NURBS structure (to accelerate operations)
nurbs = nurbsSetupStruct(nurbs, quadRef, nsd);

% How to plot the NURBS
nurbsCurvePlot(nurbs, 0, 1, 'k', 100, 1);


% TASK 1: Explore the field of the structure nurbs, try to understand what 
% is inside each field without going inside the code and produce a list
% explaining this for you

% TASK 2: Go inside the following routines and with the book to understand
% what they do
% nurbsCurveBasicConstants
% nurbsCurveBasisFuns
% nurbsCurveFindSpan
% nurbsCurvePoint
% nurbsCurveDerivPoint
% nurbsCurveDerivControlPoints
% nurbsCurvePointProjection