function loops = nurbsSurfaceExtractBoundaryCurves(nurbs)

% Build closed loops from the sets of curves in the current surface
usedCurves = zeros(1,nurbs.nOfCurves);
nOfLoops = 1;
startLoop = 1;
while min(usedCurves)==0
    iCurve = find(usedCurves==0,1);
    if nurbs.curvesParam(iCurve).isPeriodic
        % Periodic NURBS in their own
        loops(nOfLoops).curves = iCurve;
        nOfLoops = nOfLoops + 1;
        usedCurves(iCurve) = 1;
    else
        % Check if we are starting a loop
        if startLoop==1 && ~usedCurves(iCurve)
            loops(nOfLoops).curves = iCurve;
            ptEnd = nurbs.curvesParam(iCurve).sampleX(nurbs.curvesParam(iCurve).sampleN,:);
            ptFirstLoop = nurbs.curvesParam(iCurve).sampleX(1,:);
            usedCurves(iCurve) = 1;
            startLoop = 0;
        end
        % Find the next curve
        [jCurve, closedLoop, jOrientation] = nurbsSurfaceFindNextCurveInLoop(nurbs, usedCurves, ptEnd, ptFirstLoop);
        if jOrientation==-1
            nurbs.curvesParam(jCurve) = nurbsCurveReverse(nurbs.curvesParam(jCurve));
            nurbs.curves(jCurve) = nurbsCurveReverse(nurbs.curves(jCurve));
        end
        ptEnd = nurbs.curvesParam(jCurve).sampleX(nurbs.curvesParam(jCurve).sampleN,:);
        % Add new curve
        loops(nOfLoops).curves = [loops(nOfLoops).curves, jCurve];
        usedCurves(jCurve) = 1;
        % Next loop if current is closed
        if closedLoop
            nOfLoops = nOfLoops + 1;
            startLoop = 1;
        end
    end
end
nOfLoops = nOfLoops - 1;

% Prepare arrays for points on each loop
% Start with ones because only points from 2 to N are stored to avoid
% repeating the ends
nOfPointsLoop = ones(nOfLoops,1);
for iLoop = 1:nOfLoops
    nOfCurves = numel(loops(iLoop).curves);
    for kCurve = 1:nOfCurves
        iCurve = loops(iLoop).curves(kCurve);
        nOfPointsLoop(iLoop) = nOfPointsLoop(iLoop) + nurbs.curves(iCurve).sampleN - 1;
    end
    loops(iLoop).X = zeros( nOfPointsLoop(iLoop), 3);
    loops(iLoop).U = zeros( nOfPointsLoop(iLoop), 2);
end

% Store information for both the physical and the parametric curve
for iLoop = 1:nOfLoops
    % Store first point
    iCurve = loops(iLoop).curves(1);
    loops(iLoop).X(1,:) = nurbs.curves(iCurve).sampleX(1,:);
    loops(iLoop).U(1,:) = nurbs.curvesParam(iCurve).sampleX(1,1:2);
    
    % Loop on curves
    indexIni = 2;
    nOfCurves = numel(loops(iLoop).curves);
    for kCurve = 1:nOfCurves
        iCurve = loops(iLoop).curves(kCurve);
        
        indexEnd = indexIni + nurbs.curves(iCurve).sampleN - 2;
        loops(iLoop).X(indexIni:indexEnd,:) = nurbs.curves(iCurve).sampleX(2:nurbs.curves(iCurve).sampleN,:);
        loops(iLoop).U(indexIni:indexEnd,:) = nurbs.curvesParam(iCurve).sampleX(2:nurbs.curves(iCurve).sampleN,1:2);
        indexIni = indexEnd + 1;
    end
end
