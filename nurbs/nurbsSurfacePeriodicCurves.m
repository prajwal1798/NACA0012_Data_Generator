function curvesPeriodic = nurbsSurfacePeriodicCurves(aNurbs)

TOL = 1e-4;

curvesPeriodic.LR = zeros(1, aNurbs.nOfCurvesParam);

% Classify curves on the boundary of the parametric space -----------------
leftCurves = zeros(1, aNurbs.nOfCurvesParam);
rightCurves = zeros(1, aNurbs.nOfCurvesParam);
bottomCurves = zeros(1, aNurbs.nOfCurvesParam);
topCurves = zeros(1, aNurbs.nOfCurvesParam);
for iCurve = 1:aNurbs.nOfCurvesParam
    pt = aNurbs.curvesParam(iCurve).sampleX;
    if aNurbs.isPeriodic(1)
        U1 = aNurbs.U(1);
        U2 = aNurbs.U(aNurbs.mU+1);
        if all( abs(pt(:,1)-U1)<TOL )
            leftCurves(iCurve) = 1;
        elseif all( abs(pt(:,1)-U2)<TOL )
            rightCurves(iCurve) = 1;
        end
    end
    if aNurbs.isPeriodic(2)
        V1 = aNurbs.V(1);
        V2 = aNurbs.V(aNurbs.mV+1);
        if all( abs(pt(:,2)-V1)<TOL )
            bottomCurves(iCurve) = 1;
        elseif all( abs(pt(:,2)-V2)<TOL )
            topCurves(iCurve) = 1;
        end
    end
end
leftCurves = find(leftCurves==1);
rightCurves = find(rightCurves==1);
bottomCurves = find(bottomCurves==1);
topCurves = find(topCurves==1);

% Find matching curves ----------------------------------------------------
nOfLeftcurves = numel(leftCurves);
nOfRightcurves = numel(rightCurves);
nOfBottomcurves = numel(bottomCurves);
nOfTopcurves= numel(topCurves);

% % Check
% if nOfLeftcurves~=nOfRightcurves
%     error('nurbsSurfacePeriodicCurves: Left and Right not matching!')
% end
% if nOfTopcurves~=nOfBottomcurves
%     error('nurbsSurfacePeriodicCurves: Top and bottom not matching!')
% end

curvesPeriodic.LR = zeros(nOfLeftcurves,2);
curvesPeriodic.TB = zeros(nOfTopcurves,2);

for iLR = 1:nOfLeftcurves
    iLeft = leftCurves(iLR);
    p = aNurbs.curvesParam(iLeft).sampleX([1,end],2);
    for jLR = 1:nOfRightcurves
        iRight = rightCurves(jLR);
        q = aNurbs.curvesParam(iRight).sampleX([1,end],2);
        if norm(p-q)<TOL || norm(p-q([2,1]))<TOL
            curvesPeriodic.LR(iLR,:) = [iLeft, iRight];
            break
        end
    end
end

for iTB = 1:nOfBottomcurves
    iBottom = bottomCurves(iTB);
    p = aNurbs.curvesParam(iBottom).sampleX([1,end],1);
    for jTB = 1:nOfTopcurves
        iTop = topCurves(jTB);
        q = aNurbs.curvesParam(iTop).sampleX([1,end],1);
        if norm(p-q)<TOL || norm(p-q([2,1]))<TOL
            curvesPeriodic.TB(iTB,:) = [iBottom, iTop];
            break
        end
    end
end
