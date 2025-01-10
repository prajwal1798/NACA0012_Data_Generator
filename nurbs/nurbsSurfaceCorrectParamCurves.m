function nurbs = nurbsSurfaceCorrectParamCurves(nurbs, quadRef)

TOLdecimalPlaces = 5;

% Ordering
% 4-------3
% |       |
% 1-------2
%
% isSingular = [14 23 12 43]

if nurbs.isSingular(1)
    index14 = 1:nurbs.sampleNv;
    pointsSingular = unique(round( nurbs.sampleX(index14,:), TOLdecimalPlaces),'rows');
    coordFix = 2;
    nurbs = nurbsSurfaceCorrectParamCurvesCPs(nurbs, pointsSingular, coordFix, quadRef);
elseif nurbs.isSingular(2)
    index23 = nurbs.sampleNv*(nurbs.sampleNu-1)+1:nurbs.sampleNv*nurbs.sampleNu;
    pointsSingular = unique(round( nurbs.sampleX(index23,:), TOLdecimalPlaces),'rows');
    coordFix = 2;
    nurbs = nurbsSurfaceCorrectParamCurvesCPs(nurbs, pointsSingular, coordFix, quadRef);
elseif nurbs.isSingular(3)
    index12 = 1:nurbs.sampleNv:nurbs.sampleNv*(nurbs.sampleNu-1)+1;
    pointsSingular = unique(round( nurbs.sampleX(index12,:), TOLdecimalPlaces),'rows');
    coordFix = 1;
    nurbs = nurbsSurfaceCorrectParamCurvesCPs(nurbs, pointsSingular, coordFix, quadRef);
elseif nurbs.isSingular(4)
    index43 = nurbs.sampleNv:nurbs.sampleNv:nurbs.sampleNv*nurbs.sampleNu;
    pointsSingular = unique(round( nurbs.sampleX(index43,:), TOLdecimalPlaces),'rows');
    coordFix = 1;
    nurbs = nurbsSurfaceCorrectParamCurvesCPs(nurbs, pointsSingular, coordFix, quadRef);    
end


function nurbs = nurbsSurfaceCorrectParamCurvesCPs(nurbs, pointsSingular, coordFix, quadRef)

TOL = 1e-5;

for iCurve = 1:nurbs.nOfCurvesParam
    % Compute image of control points of parametric curve
    nurbsC = nurbs.curvesParam(iCurve);
    nOfCP = nurbsC.nU+1;
    imageCP = zeros(nOfCP,3);
    for iCP = 1:nOfCP
        imageCP(iCP,:) = nurbsSurfacePoint(nurbs, nurbsC.Pw(iCP,1), nurbsC.Pw(iCP,2));
    end
    % Identify CPs on singular face
    diffSingular = bsxfun(@minus, imageCP, pointsSingular);
    distSingular = sqrt(diffSingular(:,1).^2 + diffSingular(:,2).^2 + diffSingular(:,3).^2 );
    pos = sort(find(distSingular<TOL));
    nPos = numel(pos);
    if nPos>0
        if pos(1)<nOfCP/2
            % First points are singular
            nurbs.curvesParam(iCurve).Pw(pos(1:nPos), coordFix) = nurbsC.Pw(end, coordFix);
        else
            % Last points are singular
            nurbs.curvesParam(iCurve).Pw(pos(1:nPos), coordFix) = nurbsC.Pw(1, coordFix);
        end
        % Resample
        nurbs.curvesParam(iCurve) = nurbsCurveSetupStruct(nurbs.curvesParam(iCurve), quadRef);
    end
end