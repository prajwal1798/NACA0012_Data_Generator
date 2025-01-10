%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automated BAC File Generation for Multiple GEO Files
% This script generates multiple .bac files corresponding to the .geo files
% and saves them in a specified directory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;

% Set the path
setpath;

% Parameters for BAC file generation
hInf = 5; % Maximum spacing

% Directory for saving .bac files
bacOutputDir = 'D:\FLITE2D_CNS\BAC Files\bac_testing';
if ~exist(bacOutputDir, 'dir')
    mkdir(bacOutputDir);
    disp(['BAC files output directory created at: ', bacOutputDir]);
else
    disp(['BAC files output directory already exists at: ', bacOutputDir]);
end

% Directory containing .geo files
geoInputDir = 'D:\FLITE2D_CNS\GEO Files\geo_testing';

% Number of variations (geo files)
nVariations = 20;

% Loop through each variation to generate BAC files
for iVar =1:nVariations
    % Load the corresponding GEO file name
    geoFileName = sprintf('geo%d.geo', iVar);
    fullGeoPath = fullfile(geoInputDir, geoFileName);
    
    % Define mesh parameters for BAC file generation
    meshParams.bacFile = fullfile(bacOutputDir, sprintf('geo%d', iVar)); % Name for BAC file
    meshParams.X = 100*[-1 -1; 1 -1; 1 1; -1 1];
    meshParams.T = [1 2 3; 1 3 4];
    meshParams.spacing = hInf*ones(4,1);
    
    % Sources (adjust as necessary)
meshParams.sourcesP  = [-0.5 0.0 0.004 0.0 0.25
                                            0.5 0.0 0.01  0.0 0.25];
meshParams.sourcesL  = [-0.5 0.0 0.004 0.0 0.25  0.5 0.0 0.01  0.0 0.25
                                            0.5 0.0 0.1 0 2  10.0 0.0 0.1 0 2];
    
    % Generate the BAC file
    generateBacFile(meshParams);
    disp(['Generated BAC file: ', fullfile(bacOutputDir, sprintf('geo%d.bac', iVar))]);
end

disp('All BAC files generated and saved successfully.');
