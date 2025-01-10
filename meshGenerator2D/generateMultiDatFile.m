function generateMultiDatFile(meshParams)

geoFile = sprintf('geoFiles/%s.geo',meshParams.geoFile);
bacFile = sprintf('%s/%s.bac', meshParams.samplePath,meshParams.sampleName);
datFile = sprintf('%s/%s.dat', meshParams.samplePath,meshParams.sampleName);

% Temp file to feed the executable ----------------------------------------
tmpFile = sprintf('%s/%s.tmp', meshParams.samplePath,meshParams.sampleName);

fid=fopen(tmpFile,'w');
fprintf(fid,'%s\n',geoFile);
fprintf(fid,'%s\n',bacFile);
fprintf(fid,'%s\n',datFile);

% Options
remeshing = 0;
trianglesBL = 2;
optionCosmetics = 1;
optionSave = 3;
optionQuit = 5;

fprintf(fid,'%d\n', remeshing);
fprintf(fid,'%d\n', trianglesBL);
if meshParams.meshCosmetics
    fprintf(fid,'%d\n', optionCosmetics);
    fprintf(fid,'%d\n', optionCosmetics);
    fprintf(fid,'%d\n', optionCosmetics);
end
fprintf(fid,'%d\n', optionSave);
fprintf(fid,'%d\n', optionQuit);

fclose(fid);

% Run mesh generator ------------------------------------------------------
if ispc
    % Shell file
    shFile = 'tmp.bat';
    fid=fopen(shFile,'w');
    bac = '\';
    fprintf(fid,'meshGenerator2D%sgentq.exe<%s',bac,tmpFile);
    fclose(fid);
    % Mesh generation
    system('cmd /C tmp.bat');
    %[~,~] = system('cmd /C tmp.bat');
else
    % Shell file
    shFile = 'tmp.sh';
    fid=fopen(shFile,'w');
    forw = '/';
    fprintf(fid,'meshGenerator2D%sgentq<%s',forw,tmpFile);
    fclose(fid);
    % Mesh generation
    [~,~] = system('sh tmp.sh');
end

% Remove temp and bat files -----------------------------------------------
delete(tmpFile)
delete('fort.196')
delete('fort.96')
delete(shFile)
Lfile = sprintf('%s/L_%s.dat', meshParams.samplePath,meshParams.sampleName);
pfile =  sprintf('%s/p_%s.dat', meshParams.samplePath,meshParams.sampleName);
% delete(Lfile)
delete(pfile)