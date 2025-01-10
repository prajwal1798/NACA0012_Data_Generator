function res = nurbsCurveFindSpanV(v,nurbs)
%
% res = nurbsCurveFindSpanV(v,nurbs)
%
% Find the knot span for the parameter u
%


tol = 1e-5;

% if abs(v-nurbs.V(1)) < tol
%     res = nurbs.pV+1;
% elseif abs(v-nurbs.V(end)) < tol
%     res = nurbs.nV+1;
if v < nurbs.V(1) + tol
    res = nurbs.pV+1;
elseif v > nurbs.V(end) - tol
    res = nurbs.nV+1;
else    
    % Binary search
    low = nurbs.pV;
    high = nurbs.nV+1;
    mid = (low + high)/2;
    
    while (v<nurbs.V(round(mid)) || v>=nurbs.V(round(mid)+1))
        if v<nurbs.V(round(mid))
            high = mid;
        else
            low = mid;
        end
        mid = (low + high)/2;
    end
    
    res = round(mid);
end    