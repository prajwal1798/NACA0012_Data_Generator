function nurbs = nurbsCurveReadNurbsFile(fileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading a NURBS file written with the NURBS fortran library
%
% Ruben Sevilla
% 06-11-09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(fileName, 'r');
nOfNurbs = fscanf(fid, '%d', [1,1]);
if nOfNurbs>0
    for iNurbs = 1:nOfNurbs
        degree = fscanf(fid, '%d', [1,1]);
        nOfKnots = fscanf(fid, '%d', [1,1]);
        nOfCPs = fscanf(fid, '%d', [1,1]);

        nurbs(iNurbs).U = fscanf(fid, '%e', [1, nOfKnots]);
        nurbs(iNurbs).Pw = fscanf(fid, '%e', [4, nOfCPs]);
        nurbs(iNurbs).Pw = nurbs(iNurbs).Pw';

        nurbs(iNurbs).iniParam = nurbs(iNurbs).U(1);
        nurbs(iNurbs).endParam = nurbs(iNurbs).U(end);
    end
else
    nurbs = [];
end
fclose(fid);