clear;
clc;

disp('Welcome to the CFD Post-Processing System');
disp('Initializing post-processing...');

% Set path and configurations
setpath;

% User input for selecting the post-processing type
disp('1: Train Post-Processing');
disp('2: Test Post-Processing');
disp('3: Validation Post-Processing');
choice = input('Please select the post-processing type you wish to run (1-3): ');

% Validate user choice
while ~ismember(choice, [1, 2, 3])
    disp('Invalid choice, please select a valid option (1, 2, or 3):');
    choice = input('Please select the post-processing type you wish to run (1-3): ');
end

% Configuration based on user choice
switch choice
    case 1
        disp('You have selected Train Post-Processing.');
        nOfPoints = 160;
        baseDir = 'E:\\Study\\EG-M325 (ERCS)\\FLITE2D_CNS\\Pre_post\\soln_train_data\\';
        outputFile = 'ML_train_data.xlsx';
        minVal = [0.3, 0];
        maxVal = [0.8, 5];
    case 2
        disp('You have selected Test Post-Processing.');
        nOfPoints = 20;
        baseDir = 'E:\\Study\\EG-M325 (ERCS)\\FLITE2D_CNS\\Pre_post\\soln_test_data\\';
        outputFile = 'ML_test_data.xlsx';
        minVal = [0.35, 0.5];
        maxVal = [0.75, 4.5];
    case 3
        disp('You have selected Validation Post-Processing.');
        nOfPoints = 20;
        baseDir = 'E:\\Study\\EG-M325 (ERCS)\\FLITE2D_CNS\\Pre_post\\soln_val_data\\';
        outputFile = 'ML_val_data.xlsx';
        minVal = [0.32, 0.2];
        maxVal = [0.78, 4.8];
end

% Halton Points Generation
disp('Generating Halton points for parameter space sampling...');
nOfParameters = 2;
X = haltonPoints(nOfParameters, nOfPoints, minVal, maxVal);
disp('Halton Points Generated Successfully:');
disp(X);

% Extract Mach numbers and AOA
M_inf = X(:,1)';
AOA = X(:,2)';

% Initialize matrix with a pre-estimated number of rows to accommodate the maximum expected rows
ML_data = zeros(1347, nOfPoints);
ML_data(1, :) = M_inf;
ML_data(2, :) = AOA;

% Post-processing each case
disp('Post-processing setup completed. Starting to process each case...');
plotOpts.savePlots = 0;
plotOpts.field = {};
plotOpts.surfField = [];
plotOpts.rsdPlot = [];

for iCase = 1:nOfPoints
    caseFolder = sprintf('Case_%d', iCase);
    caseDir = fullfile(baseDir, caseFolder);
    addpath(caseDir);

    fprintf('Processing Case %d of %d...\n', iCase, nOfPoints);

    % Define file path and name
    file_path = caseDir;
    file_name = 'Wall_Values.dat';

    % Read the data from the file
    fileID = fopen(fullfile(file_path, file_name), 'r');
    data = textscan(fileID, '%d %f %f %f %f %f %f %f', 'Delimiter', ' ', 'MultipleDelimsAsOne', true);
    fclose(fileID);

    % Extract columns
    iNode = data{1};
    X = data{2};
    Y = data{3};
    P = data{4};
    tau1 = data{5};
    tau2 = data{6};
    n1 = data{7};
    n2 = data{8};

    % Using num2cell func to extract exact float values
    data_matrix = [num2cell(iNode), num2cell(X), num2cell(Y), num2cell(P), num2cell(tau1), num2cell(tau2), num2cell(n1), num2cell(n2)];

    % Separate the data into upper and lower surfaces based on the sign of n2
    upper_surface_data = data_matrix([data_matrix{:, 8}] >= 0, :);
    lower_surface_data = data_matrix([data_matrix{:, 8}] < 0, :);

    % Sort the upper surface data by X coordinate in ascending order
    [~, idx_upper] = sort(cell2mat(upper_surface_data(:, 2)), 'ascend');
    upper_surface_sorted = upper_surface_data(idx_upper, :);

    % Sort the lower surface data by X coordinate in descending order
    [~, idx_lower] = sort(cell2mat(lower_surface_data(:, 2)), 'descend');
    lower_surface_sorted = lower_surface_data(idx_lower, :);

    % Concatenate upper and lower surface data to create the ordered wall values data
    ordered_wall_values = [upper_surface_sorted; lower_surface_sorted];

    % Define output file names
    ordered_wall_values_file = fullfile(file_path, sprintf('New_Wall_Values_%d.dat', iCase));

    % Write the ordered wall values data to file
    fileID_ordered = fopen(ordered_wall_values_file, 'w');
    for i = 1:size(ordered_wall_values, 1)
        fprintf(fileID_ordered, '%-8d %-16.8f %-16.8f %-16.8f %-16.8f %-16.8f %-16.8f %-16.8f\n', ordered_wall_values{i, :});
    end
    fclose(fileID_ordered);

    disp(['Case ', num2str(iCase), ' - Wall values updated. Moving to next file...']);

    % Extract and store the required data in ML_data matrix
    P_ordered = cell2mat(ordered_wall_values(:, 4));
    tau1_ordered = cell2mat(ordered_wall_values(:, 5));
    tau2_ordered = cell2mat(ordered_wall_values(:, 6));
    n1_ordered = cell2mat(ordered_wall_values(:, 7));
    n2_ordered = cell2mat(ordered_wall_values(:, 8));

 %  Check if lengths match the expected size and update ML_data
    if length(P_ordered) == 268 && length(tau1_ordered) == 268 && length(tau2_ordered) == 268 && length(n1_ordered) == 268 && length(n2_ordered) == 268
        ML_data(3:270, iCase) = P_ordered;
        ML_data(271:538, iCase) = tau1_ordered;
        ML_data(539:806, iCase) = tau2_ordered;
        ML_data(807:1074, iCase) = n1_ordered;
        ML_data(1075:1342, iCase) = n2_ordered;
    else
        error(['Data length mismatch for Case ', num2str(iCase), '. Check the Wall_Values.dat file.']);
    end

    rmpath(caseDir);
end

% Save the data matrix to an Excel file
filename = fullfile('E:\\Study\\EG-M325 (ERCS)\\FLITE2D_CNS\\Pre_post', outputFile);
writematrix(ML_data, filename);
disp(['Post-processing complete. ', outputFile, ' has been successfully saved.']);
fclose all;
