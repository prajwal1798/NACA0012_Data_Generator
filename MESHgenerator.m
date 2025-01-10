%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automated DAT File Generation for Multiple GEO and BAC Files
% This script generates multiple .dat files corresponding to .geo and .bac files
% and saves them in the same directory where the script is located.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;

% Set the path 
setpath;

% Prompt the user to choose between training or testing
disp('1: Generate DAT files for Training Dataset');
disp('2: Generate DAT files for Testing Dataset');
choice = input('Please select the dataset type (1-2): ');

% Validate user choice
while ~ismember(choice, [1, 2])
    disp('Invalid choice, please select a valid option (1 or 2):');
    choice = input('Please select the dataset type (1-2): ');
end

% Display the chosen option
switch choice
    case 1
        disp('Generating DAT files for Training Dataset...');
    case 2
        disp('Generating DAT files for Testing Dataset...');
end

% Number of variations (geo and bac files)
nVariations = 20;

% Loop through each variation to generate DAT files
for iVar = 1:nVariations
    % Set the file names for the current iteration (geo and bac files)
    geoFileName = sprintf('geo%d', iVar);
    bacFileName = sprintf('geo%d', iVar);
    datFileName = sprintf('geo%d', iVar);

    % Define mesh parameters for DAT file generation
    meshParams.geoFile = geoFileName; % Directly assign the .geo file name
    meshParams.bacFile = bacFileName; % Directly assign the .bac file name
    meshParams.meshFile = datFileName; % Save .dat files in the same directory as the script

    % Flags for loading or saving the mesh
    meshParams.isHybrid = 1;
    saveMesh = 1;  % Save the mesh
    loadMesh = 0;  % Generate a new mesh, not loading

    % Generate the .dat file if not loading an existing mesh
    if ~loadMesh
        % Generate mesh and save it
        generateDatFile(meshParams);

        % Read the generated .dat file if needed
        mesh = readMesh(meshParams.meshFile);

        % Save the mesh to .dat file
        if saveMesh
            save(meshParams.meshFile, 'mesh');
            disp(['DAT file saved as: ', meshParams.meshFile]);
        end
    end
end

disp('All DAT files generated and saved successfully.');