function u = nurbsSurfaceFixPointInversionHighOrderNode(nurbs, uFace, u)
%
% u = nurbsSurfaceFixPointInversionHighOrderNode(nurbs, uFace, u)
%

if nurbs.isPeriodic(1)
    u(1) = nurbsSurfaceFixPointInversionHighOrderNodeOneDirection(nurbs.U, uFace(:,1), u(1) );
end
if nurbs.isPeriodic(2)
    u(2) = nurbsSurfaceFixPointInversionHighOrderNodeOneDirection(nurbs.V, uFace(:,2), u(2) );
end

function u = nurbsSurfaceFixPointInversionHighOrderNodeOneDirection(U, uFace, u)

TOL = 1e-5;

posLeft = find(uFace<U(1)+TOL);
posRight = find(uFace>U(end)-TOL);

if( (u<U(1)+TOL) && numel(posRight)>1 )
    u = U(end);
elseif( (u>U(end)-TOL) && numel(posLeft)>1 )
    u = U(1);
end
