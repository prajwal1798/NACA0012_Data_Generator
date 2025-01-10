function res = nurbsCurveFindSpan(u,nurbs)
%
% res = nurbsCurveFindSpan(u,nurbs)
%
% Find the knot span for the parameter u
%


tol = 1e-5;

% if abs(u-nurbs.U(1)) < tol
%     res = nurbs.pU+1;
% elseif abs(u-nurbs.U(end)) < tol
%     res = nurbs.nU+1;
if u < nurbs.U(1)+ tol
    res = nurbs.pU+1;
elseif u > nurbs.U(end) - tol
    res = nurbs.nU+1;
else    
    % Binary search
    low = nurbs.pU;
    high = nurbs.nU+1;
    mid = (low + high)/2;
    
    while (u<nurbs.U(round(mid)) || u>=nurbs.U(round(mid)+1))
        if u<nurbs.U(round(mid))
            high = mid;
        else
            low = mid;
        end
        mid = (low + high)/2;
    end
    
    res = round(mid);
end    