function [jCurve, closedLoop, jOrientation] = nurbsSurfaceFindNextCurveInLoop(nurbs, usedCurves, ptEndPrevious, ptFirstLoop)
%
% [jCurve, closedLoop, jOrientation] = nurbsSurfaceFindNextCurveInLoop(nurbs, usedCurves, ptEnd, ptFirstLoop)
%

TOL = 1e-6;

for jCurve=1:nurbs.nOfCurves
    if ~usedCurves(jCurve)
        ptIni = nurbs.curvesParam(jCurve).sampleX(1,:);
        ptEnd = nurbs.curvesParam(jCurve).sampleX(nurbs.curvesParam(jCurve).sampleN,:);
        
        if norm(ptIni-ptEndPrevious)<TOL  
            jOrientation = 1;
            if norm(ptFirstLoop-ptEnd)<TOL
                closedLoop = 1;
                break;
            else
                closedLoop = 0;
                break;
            end
        elseif norm(ptEnd-ptEndPrevious)<TOL
            jOrientation = -1;
            if norm(ptFirstLoop-ptIni)<TOL
                closedLoop = 1;
                break;
            else
                closedLoop = 0;
                break;
            end
        end
    end
end