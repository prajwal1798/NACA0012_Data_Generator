function uProj = nurbsCurveFixPointInversionFacePeriodic(nurbs, uProj, quadRef)

TOL = 1e-4;

% Fix periodic NURBS (2D)
[uMin,posMin] = min(uProj);
[uMax,posMax] = max(uProj);

% It assumes that the length of an edge cannot be more than half of the
% length of the NURBS. Being the NURBS periodic this is reasonable

% Check if correction might be required
uMinIsInitial = abs(uMin-nurbs.U(1))<TOL;
uMaxIsFinal = abs(uMax-nurbs.U(end))<TOL;

% Identify if minimum parameter is matching an end of the curve
if uMinIsInitial
    Lmin = 0;
else
    Lmin = nurbsCurveLengthAdaptive(nurbs, nurbs.U(1), uMin, quadRef, TOL);
end

% Identify if maximum parameter is matching an end of the curve
if uMaxIsFinal
    Lmax = nurbs.length;
else
    Lmax = nurbsCurveLengthAdaptive(nurbs, nurbs.U(1), uMax, quadRef, TOL);
end

% Correction (if needed)
Ldiv2 = nurbs.length/2;
if Lmin==0 && Lmax>Ldiv2
    % Correct the uProj==uMin
    uProj(posMin) = nurbs.U(end);
elseif abs(Lmax-nurbs.length)<TOL && Lmin<Ldiv2
    % Correct the uProj==uMax
    uProj(posMax) = nurbs.U(1);
end

