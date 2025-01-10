%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate SOL files for Cluster data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
setpath

% Define parameters -------------------------------------------------------
numCases = 20;  % Total number of cases to process
baseFileName = 'geo';  % Base name for geo files (e.g., geo1, geo2, ..., geo2560)
outputDir = 'D:\FLITE2D_CNS\Pre_post\Test_Data'; % Output directory for all cases

% Create output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
    fprintf('Created directory: %s\n', outputDir);
end

% Loop through each case from 1 to 2560
for caseNum = 1:numCases
    fileName = sprintf('%s%d', baseFileName, caseNum);  % Construct the base file name without extension
    datFile = sprintf('%s.dat', fileName);  % Add the .dat extension

    caseDir = fullfile(outputDir, sprintf('Case%d', caseNum));  % Directory for the current case

    % Check if the case directory already exists
    if exist(caseDir, 'dir')
        fprintf('Skipping Case %d: Directory already exists.\n', caseNum);
        continue; % Skip this case if the directory already exists
    end

    % Check if the required .geo, .bac, and .dat files exist in the current directory
    geoFile = sprintf('%s.geo', fileName);
    bacFile = sprintf('%s.bac', fileName);

    if exist(geoFile, 'file') && exist(bacFile, 'file') && exist(datFile, 'file')
        fprintf('Processing Case %d\n', caseNum);

        % Read mesh data
        mesh = readMesh(fileName);
        solverParams.tripNodes = triggerNodes(mesh);

        % Define solver parameters for this case
        solverParams.mesh = fileName;
        solverParams.Re = 1000;
        solverParams.alpha = 0.0;
        solverParams.Mach = 0.72;
        solverParams.isTurbulent = 0;
        solverParams.isHybrid = 'T';
        solverParams.MGiterations = -5;
        solverParams.liftDragTolerance = 0.001;
        solverParams.maxIterations = 1e5;
        solverParams.MGgrids = 4;
        solverParams.CFL = 2.0;
        solverParams.CPUtime = 24; % Hours
        solverParams.CPUmem = 2; % GB

        % Generate preprocessor input file
        generateInputPreprocessor(solverParams, fileName);

        % Generate solver input file
        generateInputSolver(fileName);

        % Generate solver control file using the generateControlSolver function
        iSample = 1;
        solverParams.paramMatrix = [solverParams.Re, solverParams.Mach, solverParams.alpha];
        generateControlSolver(solverParams, iSample, fileName);

        % Generate solver cluster file
        generateClusterSolver(solverParams, fileName);

        % Create directory for the current case
        mkdir(caseDir);
        fprintf('Created directory for Case %d: %s\n', caseNum, caseDir);

        % Move generated files to the case directory
        movefile([fileName '.prepro'], caseDir);
        movefile([fileName '.inp'], caseDir);
        movefile([fileName '.cfd'], caseDir);
        movefile(fileName, caseDir);  % Moves the cluster submission file
        copyfile(geoFile, caseDir);
        copyfile(bacFile, caseDir);
        copyfile(datFile, caseDir);

        fprintf('Completed processing for Case %d\n', caseNum);
    else
        fprintf('One or more required files (.geo, .bac, .dat) are missing for Case %d.\n', caseNum);
    end
end

fprintf('All specified cases processed and files copied to the output directory.\n');


for i = 1:160
    fprintf('cd Case%d\n', i);
    fprintf('sbatch geo%d\n', i);
    fprintf('cd ..\n');
end