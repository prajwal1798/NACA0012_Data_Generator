function collapsedFace = nurbSurfaceIdentifyCollapse(nurbs, trimmedInfo)
%
% collapsedFace = nurbSurfaceIdentifyCollapse(nurbs, trimmedInfo)
%
% For a given trimmed information verify if two points in the parametric
% space have the same image in cartesian coordinates (collapse)
%

TOL = 1e-5;

collapsedFace = [];
if size(trimmedInfo,1)==4
    trimmedInfoAux = [trimmedInfo; trimmedInfo(1,:)];
    for iEdge = 1:4
        u1 = trimmedInfoAux(iEdge, 1);
        v1 = trimmedInfoAux(iEdge, 2);
        u2 = trimmedInfoAux(iEdge+1, 1);
        v2 = trimmedInfoAux(iEdge+1, 2);
        
        pt1 = nurbsSurfacePoint(nurbs, u1, v1);
        pt2 = nurbsSurfacePoint(nurbs, u2, v2);
        
        if norm(pt1-pt2)<TOL
            collapsedFace = iEdge;
            break;
        end
    end
end
if collapsedFace==4
    collapsedFace=1;
end
