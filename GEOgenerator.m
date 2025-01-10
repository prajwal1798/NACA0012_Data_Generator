%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automated NURBS Airfoil Geometry Generator 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
close all;

% Add necessary paths
disp('Adding necessary paths for mesh generation and NURBS handling...');
addpath('meshGenerator2D');
addpath('meshGenerator2DinOut');
addpath('nurbs');
addpath('nurbs\\iges2matlab');
rehash;
disp('Paths added successfully.');
disp(' ');
% User input for selecting the pre-processing type
disp('1: Train Pre-Processing');
disp('2: Test Pre-Processing');
choice = input('Please select the pre-processing type you wish to run (1-2): ');
% Validate user choice
while ~ismember(choice, [1, 2])
    disp('Invalid choice, please select a valid option (1 or 2):');
    choice = input('Please select the pre-processing type you wish to run (1-2): ');
end
% Set parameters based on user choice
switch choice
    case 1
        disp('You have selected Train Pre-Processing.');
        nVariations = 2560;
        outputDir = 'D:\\FLITE2D_CNS\\GEO Files\\geo_training\\';
        % Upper Surface X and Y limits
        upperSurfaceXLimits = [5.3e-3, 1.5e-2, 2.5e-2, 3.1e-2, 4.3e-2, 0];
        upperSurfaceYLimits = [2.7e-3, 7.4e-3, 1.2e-2, 1.5e-2, 2.2e-2, 2.2e-2];
        % Lower Surface X and Y limits
        lowerSurfaceXLimits = [1.9e-2, 3.2e-2, 3.9e-5, 4.5e-2, 4.3e-2];
        lowerSurfaceYLimits = [9.6e-3, 1.6e-2, 1.9e-5, 2.3e-2, 2.2e-2];
    case 2
        disp('You have selected Test Pre-Processing.');
        nVariations = 20;
        outputDir = 'D:\\FLITE2D_CNS\\GEO Files\\geo_testing\\';
        % Scaling for test cases
        upperSurfaceXLimits = 2 * [5.3e-3, 1.5e-2, 2.5e-2, 3.1e-2, 4.3e-2, 2.2e-2];
        upperSurfaceYLimits = 2 * [2.7e-3, 7.4e-3, 1.2e-2, 1.5e-2, 2.2e-2, 2.2e-2];
        lowerSurfaceXLimits = 2 * [1.9e-2, 3.2e-2, 3.9e-5, 4.5e-2, 4.3e-2];
        lowerSurfaceYLimits = 2 * [9.6e-3, 1.6e-2, 1.9e-5, 2.3e-2, 2.2e-2];
end
% Directory for saving files
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
    disp(['Output directory created at: ', outputDir]);
else
    disp(['Output directory already exists at: ', outputDir]);
end
disp(' ');

% Add baseline mesh parameters
meshParams.BCs = [6 3]; % 6: far field, 3: wall (adjust as needed)
meshParams.viscousSegments = [4 5]; % Define viscous segments
meshParams.BLnLayers = 60; % Number of layers in the boundary layer
meshParams.BLfirstH = 1e-3; % Initial boundary layer height
meshParams.BLgrowth = 1.1; % Boundary layer growth ratio

% Load and setup initial NURBS structure for the NACA0012 profile
disp('Loading initial NURBS structure from IGES file...');
fileNameIGES = 'naca0012.igs';
nsd = 2;
nurbs = nurbsReadIgesBoundary(fileNameIGES, nsd);
quadRef = defineQuadratureAdaptive();
disp('NURBS structure loaded successfully.');
disp(' ');

% Store these control points for reference
originalUpperPw = nurbs(4).Pw;
originalLowerPw = nurbs(5).Pw;
    
% Set the fixed boundary points (leading and trailing edges) outside the loop
nurbs(4).Pw([1, 8], :) = originalUpperPw([1, 8], :); % Fix leading and trailing edges for upper surface
nurbs(5).Pw([1, 8], :) = originalLowerPw([1, 8], :); % Fix leading and trailing edges for lower surface

% Generate Halton points separately for X and Y coordinates of upper and lower surfaces
haltonSamplesUpperX = haltonPoints(6, nVariations, -1*upperSurfaceXLimits, upperSurfaceXLimits);
haltonSamplesUpperY = haltonPoints(6, nVariations, -1*upperSurfaceYLimits, upperSurfaceYLimits);
haltonSamplesLowerX = haltonPoints(5, nVariations, -1*lowerSurfaceXLimits, lowerSurfaceXLimits);
haltonSamplesLowerY = haltonPoints(5, nVariations, -1*lowerSurfaceYLimits, lowerSurfaceYLimits);

% Initialize matrices to store surface points and normals for all geometries
nPoints = 200; % Number of points to sample per curve
uSamples = linspace(0, 5, nPoints);
surfacePointsMatrix = zeros(400, 2 * nVariations); % 800 points (400 each for upper and lower) by 2n (x, y for each variation)
normalsUpperMatrix = zeros(nPoints, 2 * nVariations); % Normals for upper surface
normalsLowerMatrix = zeros(nPoints, 2 * nVariations); % Normals for lower surface

% Initialize matrix to store control point coordinates in the specified order
controlPointsMatrix = zeros(22, nVariations); % 22 rows (11 control points per geometry) by nVariations (columns for each geometry)
% Main loop to generate each variation
disp('Starting the geometry generation process...');
disp(' ');
for iVar = 1:nVariations
    
    disp(['Generating variation ', num2str(iVar), ' of ', num2str(nVariations), '...']);
    
    % Apply Halton points to control points for the upper surface (excluding boundaries)
    nurbs(4).Pw(2:7, 1) = originalUpperPw(2:7, 1) + haltonSamplesUpperX(iVar, :)'; % X-coordinates upper surface
    nurbs(4).Pw(2:7, 2) = originalUpperPw(2:7, 2) + haltonSamplesUpperY(iVar, :)'; % Y-coordinates upper surface
    % Calculate the 7th control point for the lower surface to maintain G1 continuity
    nu = 0.5; % Fixed value for nu for simplicity
    nurbs(5).Pw(7, 1) = nurbs(5).Pw(8, 1) + nu * (nurbs(5).Pw(8, 1) - nurbs(4).Pw(7, 1));
    nurbs(5).Pw(7, 2) = nurbs(5).Pw(8, 2) + nu * (nurbs(5).Pw(8, 2) - nurbs(4).Pw(7, 2));
    % Apply Halton points to control points for the lower surface (excluding boundaries)
    nurbs(5).Pw(2:6, 1) = originalLowerPw(2:6, 1) + haltonSamplesLowerX(iVar, :)'; % X-coordinates lower surface
    nurbs(5).Pw(2:6, 2) = originalLowerPw(2:6, 2) + haltonSamplesLowerY(iVar, :)'; % Y-coordinates lower surface
    % Setup NURBS structure after modification
    nurbs = nurbsSetupStruct(nurbs, quadRef, nsd);
    disp('NURBS structure updated with new control points.');
    disp(' ');
    % Store control points in the specified order
    for k = 1:6
        controlPointsMatrix(2*k-1, iVar) = nurbs(4).Pw(k+1, 1); % Upper surface x-coordinates
        controlPointsMatrix(2*k, iVar) = nurbs(4).Pw(k+1, 2);   % Upper surface y-coordinates
    end
    
    for k = 1:5
        controlPointsMatrix(12 + 2*k-1, iVar) = nurbs(5).Pw(k+1, 1); % Lower surface x-coordinates
        controlPointsMatrix(12 + 2*k, iVar) = nurbs(5).Pw(k+1, 2);   % Lower surface y-coordinates
    end
    % Generate boundary loops for upper and lower surfaces.
    % Generate boundary loops
    disp('Generating boundary loops...');
    nOfPoints = [11 11 11 200 200 51];
    nurbsLoops(1).curves = [4 5]; % Upper and lower surface curves
    nurbsLoops(2).curves = [1 6 2 3]; % Farfield curves
    orientation = [-1 -1 -1 -1 1 1];
    boundaryToCurve = [0 0 0 0 0 0];
    nOfLoops = numel(nurbsLoops);
    loops = struct();
    
    for iLoop = 1:nOfLoops
        nOfCurves = numel(nurbsLoops(iLoop).curves);
        for kCurve = 1:nOfCurves
            iCurve = nurbsLoops(iLoop).curves(kCurve);
            nodes1D = gaussLegendre(nOfPoints(iCurve), -1, 1);
            uNodes = nurbsCurveNodalDistribution(nurbs(iCurve), nurbs(iCurve).iniParam, nurbs(iCurve).endParam, nodes1D, quadRef, 1e-6);
            if orientation(iCurve) == -1
                uNodes = flipud(uNodes);
            end
            loops(iLoop).segment(kCurve).x = zeros(nOfPoints(iCurve), 2);
            for i = 1:nOfPoints(iCurve)
                pt = nurbsCurvePoint(nurbs(iCurve), uNodes(i));
                loops(iLoop).segment(kCurve).x(i, :) = pt(1:2);
            end
        end
    end
    disp('Boundary loops generated successfully.');
    disp(' ');
    % Generate the GEO file
    meshParams.geoFile = sprintf('%sgeo%d', outputDir, iVar); % Set the name for each .geo file   
    generateGeoFile(meshParams, loops); % Generate the .geo file
    
    geoFileName = sprintf('%sgeo%d.geo', outputDir, iVar); % Save the .geo file with unique name
    disp(['GEO file saved as: ', geoFileName]);
    disp(' ');
    % Extract surface points and normals
    for j = 1:nPoints
        % Upper surface (NURBS 4)
        [pt, dpt] = nurbsCurveDerivPoint(nurbs(4), uSamples(j)); % Get point and tangent
        normal = [-dpt(2), dpt(1)]; % Rotate tangent by +90 degrees
        normal = normal / norm(normal); % Normalize 
        
        % Store surface points and normals for upper surface
        surfacePointsMatrix(j, (iVar - 1) * 2 + 1) = pt(1);
        surfacePointsMatrix(j, (iVar - 1) * 2 + 2) = pt(2);
        normalsUpperMatrix(j, (iVar - 1) * 2 + 1) = normal(1); % X-component
        normalsUpperMatrix(j, (iVar - 1) * 2 + 2) = normal(2); % Y-component
        
        % Lower surface (NURBS 5)
        [pt, dpt] = nurbsCurveDerivPoint(nurbs(5), uSamples(j)); % Get point and tangent
        normal = [dpt(2), -dpt(1)]; % Rotate tangent by +90 degrees
        normal = normal / norm(normal); % Normalize the normal vector
        
        % Store surface points and normals for lower surface
        surfacePointsMatrix(j + nPoints, (iVar - 1) * 2 + 1) = pt(1);
        surfacePointsMatrix(j + nPoints, (iVar - 1) * 2 + 2) = pt(2);
        normalsLowerMatrix(j, (iVar - 1) * 2 + 1) = normal(1); % X-component
        normalsLowerMatrix(j, (iVar - 1) * 2 + 2) = normal(2); % Y-component
    end
end
% Save surface points to a single .dat file
surfacePointsFileName = sprintf('%ssurface_points.dat', outputDir);
fileID = fopen(surfacePointsFileName, 'w');
for i = 1:size(surfacePointsMatrix, 1)
    fprintf(fileID, '%12.6f\t', surfacePointsMatrix(i, :));
    fprintf(fileID, '\n');
end
fclose(fileID);
disp(['Surface point data saved in: ', surfacePointsFileName]);
% Save upper surface normals to a .dat file
normalsUpperFileName = sprintf('%snormals_upper_surface.dat', outputDir);
fileID = fopen(normalsUpperFileName, 'w');
for i = 1:size(normalsUpperMatrix, 1)
    fprintf(fileID, '%12.6f\t', normalsUpperMatrix(i, :));
    fprintf(fileID, '\n');
end
fclose(fileID);
disp(['Upper surface normals saved in: ', normalsUpperFileName]);
% Save lower surface normals to a .dat file
normalsLowerFileName = sprintf('%snormals_lower_surface.dat', outputDir);
fileID = fopen(normalsLowerFileName, 'w');
for i = 1:size(normalsLowerMatrix, 1)
    fprintf(fileID, '%12.6f\t', normalsLowerMatrix(i, :));
    fprintf(fileID, '\n');
end
fclose(fileID);
disp(['Lower surface normals saved in: ', normalsLowerFileName]);
% Save control points to a single .dat file
controlPointsFileName = sprintf('%scontrolpoint_coordinates.dat', outputDir);
fileID = fopen(controlPointsFileName, 'w');
for i = 1:size(controlPointsMatrix, 1)
    fprintf(fileID, '%12.6f\t', controlPointsMatrix(i, :));
    fprintf(fileID, '\n');
end
fclose(fileID);
disp(['Control point data saved in: ', controlPointsFileName]);
disp('All geometry variations generated, saved, and surface point/normals/control point data stored successfully.');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Halton Points generator function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = haltonPoints(nOfParameters, nOfPoints, minVal, maxVal)
    % X = haltonPoints(nOfParameters, nOfPoints, minVal, maxVal)
    % Inputs:
    % nOfParameters: Number of dimensions/parameters
    % nOfPoints:     Number of points required
    % minVal:        Minimum value (scalar or vector of dimension nOfParameters)
    % maxVal:        Maximum value (scalar or vector of dimension nOfParameters)
    % Output:
    % X:             List of Halton points (nOfPoints x nOfParameters)
    % Transform to vectors if scalars are provided
    if isscalar(minVal)
        minVal = minVal * ones(1, nOfParameters);
    end
    if isscalar(maxVal)
        maxVal = maxVal * ones(1, nOfParameters);
    end
    % Halton points in [0, 1]^nParam
    P = haltonset(nOfParameters);
    X = net(P, nOfPoints);
    % Scale to the appropriate interval
    for iParam = 1:nOfParameters
        X(:, iParam) = minVal(iParam) + X(:, iParam) * (maxVal(iParam) - minVal(iParam));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NURBS Curve Derivative Point Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Cu, dCu] = nurbsCurveDerivPoint(nurbs, u)
    [Cu, wu] = nurbsCurvePoint(nurbs, u);
    [pDer, wDer] = nurbsCurvePointNoHom(nurbs.derU, u);
    dCu = (pDer - Cu * wDer) / wu;
end