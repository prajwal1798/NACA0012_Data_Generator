function nurbsCurveWriteNurbsFile(fileName, nurbs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Writing a NURBS file written with the NURBS fortran library 
%
% Ruben Sevilla
% 06-11-09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(fileName, 'w');
nOfNurbs = length(nurbs);
fprintf(fid, '%d\n', nOfNurbs);
for iNurbs = 1:nOfNurbs
    degree = length(find(nurbs(iNurbs).U==nurbs(iNurbs).U(1))) - 1;
    nOfKnots = length(nurbs(iNurbs).U);
    nOfCPs = size(nurbs(iNurbs).Pw,1);
    fprintf(fid, '%d\n', degree);
    fprintf(fid, '%d\n', nOfKnots);    
    fprintf(fid, '%d\n', nOfCPs);    
    for i=1:nOfKnots
        %fprintf(fid, '%14.4E\n', nurbs(iNurbs).U(i));
        fprintf(fid, '%20.14E\n', nurbs(iNurbs).U(i));
    end
    for i=1:nOfCPs
        % Spaces between numbers cause wrong reading in fortran...
        %fprintf(fid, '%14.4E%14.4E%14.4E%14.4E\n', nurbs(iNurbs).Pw(i,:));
        fprintf(fid, '%20.14E %20.14E %20.14E %20.14E\n', nurbs(iNurbs).Pw(i,:));
        %fprintf(fid, '%20.14E\n', nurbs(iNurbs).Pw(i,1));
        %fprintf(fid, '%20.14E\n', nurbs(iNurbs).Pw(i,2));
        %fprintf(fid, '%20.14E\n', nurbs(iNurbs).Pw(i,3));
        %fprintf(fid, '%20.14E\n', nurbs(iNurbs).Pw(i,4));
    end
end
fclose(fid);