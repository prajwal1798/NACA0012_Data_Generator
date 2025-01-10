function [trimmedInfoFace,trimmedInfoEdge] = ...
    nurbsSurfaceFixPeriodicV(nurbs, trimmedInfoFace, trimmedInfoEdge)


TOL = 1e-3;
for i=1:length(trimmedInfoFace)
    v = trimmedInfoFace(i).trim(:,1);
    p = find(v<nurbs.V(1)+TOL);
    q = setdiff(1:3,p);
    mean = 0.5*(nurbs.V(1)+nurbs.V(end));
    if all(v(q)>mean-TOL)
        v(p) = nurbs.V(end);
        trimmedInfoFace(i).trim(:,1)= v;
    end
end

for i=1:length(trimmedInfoEdge)
    v = trimmedInfoEdge(i).trim(:,1);
    p = find(v<nurbs.V(1)+TOL);
    q = setdiff(1:2,p);
    mean = 0.5*(nurbs.V(1)+nurbs.V(end));
    if all(v(q)>mean-TOL)
        v(p) = nurbs.V(end);
        trimmedInfoEdge(i).trim(:,1)= v;
    end    
end
