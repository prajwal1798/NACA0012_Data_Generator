clear all;
clc;
close all;

% Add necessary paths for NURBS and mesh generation
addpath ('meshGenerator2D')
addpath ('meshGenerator2DinOut')
addpath ('nurbs')
addpath ('nurbs/iges2matlab')
rehash;

% Load control point coordinates file (22 rows, 2560 columns)
controlPointFile = 'D:\\FLITE2D_CNS\\GEO Files\\geo_testing\\controlpoint_coordinates.dat';
controlPoints = load(controlPointFile);

% Number of cases to process
num_cases = 20;

% Loop through each case
for case_idx = 1:num_cases
    fprintf('Processing case %d of %d\n', case_idx, num_cases);

    % Load NURBS structure for this case
    igesFile = 'naca0012.igs';  
    nsd = 2;  
    nurbs = nurbsReadIgesBoundary(igesFile, nsd);  
    quadRef = defineQuadratureAdaptive();  
    nurbs = nurbsSetupStruct(nurbs, quadRef, nsd);  

    % Extract control points for upper (rows 1 to 12) and lower (rows 13 to 22) surfaces for this case
    up_cp = controlPoints(1:12, case_idx);
    low_cp = controlPoints(13:22, case_idx);

    % Assign control points for upper surface NURBS (nurbs(4))
    nurbs(4).Pw(1,1) = 0.5;  % Fixed first control point (X)
    nurbs(4).Pw(1,2) = 0.0;  % Fixed first control point (Y)
    for i = 2:7
        nurbs(4).Pw(i, 1) = up_cp(2*(i-1)-1);  % X-coordinates of upper surface
        nurbs(4).Pw(i, 2) = up_cp(2*(i-1));    % Y-coordinates of upper surface
    end
    nurbs(4).Pw(8,1) = -0.5;  % Fixed last control point (X)
    nurbs(4).Pw(8,2) = 0.0;   % Fixed last control point (Y)

    % Assign control points for lower surface NURBS (nurbs(5))
    nurbs(5).Pw(1,1) = 0.5;  % Fixed first control point (X)
    nurbs(5).Pw(1,2) = 0.0;  % Fixed first control point (Y)
    for i = 2:6
        nurbs(5).Pw(i, 1) = low_cp(2*(i-1)-1);  % X-coordinates of lower surface
        nurbs(5).Pw(i, 2) = low_cp(2*(i-1));    % Y-coordinates of lower surface
    end
    % Compute the 7th control point for the lower surface
    nurbs(5).Pw(7, 1) = nurbs(5).Pw(8, 1) + 0.5 * (nurbs(5).Pw(8, 1) - nurbs(4).Pw(7, 1));
    nurbs(5).Pw(7, 2) = nurbs(5).Pw(8, 2) + 0.5 * (nurbs(5).Pw(8, 2) - nurbs(4).Pw(7, 2));
    nurbs(5).Pw(8,1) = -0.5;  % Fixed last control point (X)
    nurbs(5).Pw(8,2) = 0.0;   % Fixed last control point (Y)

    % Process the surface data
    % Define the path for upper and lower surface files
    caseDir = sprintf('D:\\FLITE2D_CNS\\Pre_post\\Test_Data\\Case%d\\', case_idx);
    upperSurfaceFile = fullfile(caseDir, 'uwall_interp.dat');
    lowerSurfaceFile = fullfile(caseDir, 'lwall_interp.dat');

    % Process upper_surface.dat
    if exist(upperSurfaceFile, 'file')
        upperData = load(upperSurfaceFile);
        for row = 1:size(upperData, 1)
            x_coord = upperData(row, 2);  % X-coordinate
            y_coord = upperData(row, 3);  % Y-coordinate
            param_value = nurbsCurvePointProjection(nurbs(4), [x_coord, y_coord]);  % Project to parametric space
            upperData(row, 1) = param_value;  % Update first column with parametric coordinate
        end
        % Save the updated upper_surface.dat file
        fid = fopen(upperSurfaceFile, 'w');
        fprintf(fid, '%15.10f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f\n', upperData');
        fclose(fid);
    end

    % Process lower_surface.dat
    if exist(lowerSurfaceFile, 'file')
        lowerData = load(lowerSurfaceFile);
        for row = 1:size(lowerData, 1)
            x_coord = lowerData(row, 2);  % X-coordinate
            y_coord = lowerData(row, 3);  % Y-coordinate
            param_value = nurbsCurvePointProjection(nurbs(5), [x_coord, y_coord]);  % Project to parametric space
            lowerData(row, 1) = param_value;  % Update first column with parametric coordinate
        end
        % Save the updated lower_surface.dat file
        fid = fopen(lowerSurfaceFile, 'w');
        fprintf(fid, '%15.10f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f\n', lowerData');
        fclose(fid);
    end
end

fprintf('All cases processed successfully.\n');
