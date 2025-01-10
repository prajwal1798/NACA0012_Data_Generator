function [trimmedInfoFace,trimmedInfoEdge] = ...
    nurbsSurfaceFixPeriodicU(nurbs, trimmedInfoFace, trimmedInfoEdge)


TOL = 1e-3;
for i=1:length(trimmedInfoFace)
    u = trimmedInfoFace(i).trim(:,1);
    p = find(u<nurbs.U(1)+TOL);
    q = setdiff(1:3,p);
    mean = 0.5*(nurbs.U(1)+nurbs.U(end));
    if all(u(q)>mean-TOL)
        u(p) = nurbs.U(end);
        trimmedInfoFace(i).trim(:,1)= u;
    end
end

for i=1:length(trimmedInfoEdge)
    u = trimmedInfoEdge(i).trim(:,1);
    p = find(u<nurbs.U(1)+TOL);
    q = setdiff(1:2,p);
    mean = 0.5*(nurbs.U(1)+nurbs.U(end));
    if all(u(q)>mean-TOL)
        u(p) = nurbs.U(end);
        trimmedInfoEdge(i).trim(:,1)= u;
    end    
end
