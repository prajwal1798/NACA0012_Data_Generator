function [u,Cu,iIter] = nurbsCurvePointProjection(nurbs, p)
nMaxIter = 50;
tol1 = 1e-15;
tol2 = 1e-15;
if(length(p)==2)
    p(3) = 0;
end
%% Initial guess
d = Inf;
for iPointSample = 1:nurbs.sampleN
    dNew = norm(p-nurbs.sampleX(iPointSample,:));
    if(dNew<d)
        u = nurbs.sampleU(iPointSample);
        d = dNew;
    end
end
%% Newton loop
dMin = d;
[Cu, dCu, d2Cu] = nurbsCurveSecondDerivPoint(nurbs,u);
for iIter = 1:nMaxIter
    cond1 = Cu-p;
    normCond1 = norm(cond1);
    if(normCond1<tol1)
        break
    end
    cond2 = norm(dCu*cond1'/(norm(dCu)*norm(cond1)));
    if(cond2<tol2)
        break
    end
    uNew = u - dCu*(Cu-p)'/(d2Cu*(Cu-p)' + sum(dCu.^2));
    if nurbs.isPeriodic==0
        uNew = max(uNew, nurbs.iniParam);
        uNew = min(uNew, nurbs.endParam);
    else
        if(uNew<nurbs.iniParam)
            uNew = nurbs.endParam  - (nurbs.iniParam - uNew);
        elseif(uNew>nurbs.endParam)
            uNew = nurbs.iniParam  + (uNew - nurbs.endParam);
        end
        if(uNew>nurbs.endParam || uNew<nurbs.iniParam )
            break;
        end
    end
    
    cond4 = norm((uNew-u)*dCu);
    if(cond4<tol1)
        u = uNew;
        Cu = nurbsCurvePoint(nurbs, u);
        cond1 = Cu-p;
        dMin = norm(cond1);
        break        
    end
    u = uNew;    
    [Cu, dCu, d2Cu] = nurbsCurveSecondDerivPoint(nurbs,u);    
    dMin = norm(Cu-p);
    if(normCond1<dMin)
        dMin = normCond1;
    end
end
%% Check if a knot is closer and we have not converge to it (end points
% or tolerance)
for uu=nurbs.Uunique
    Cu = nurbsCurvePoint(nurbs, uu);
    d = norm(Cu-p);
    if(dMin-d>-tol1)
        u = uu;
        dMin = d;
    end
end
Cu = nurbsCurvePoint(nurbs, u);