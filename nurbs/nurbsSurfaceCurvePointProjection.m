function [u, Su, lambda] = nurbsSurfaceCurvePointProjection(nurbs, iCurve, x)

lambda = fminbnd(@(lambda) distanceSurfaceCurve(lambda, nurbs, iCurve, x), nurbs.curves(iCurve).U(1) ,nurbs.curves(iCurve).U(end) );

u = nurbsCurvePoint(nurbs.curvesParam(iCurve), lambda);

Su = nurbsSurfacePoint(nurbs, u(1), u(2));



function dCurve = distanceSurfaceCurve(lambda, nurbs, iCurve, x)

ptUV = nurbsCurvePoint(nurbs.curvesParam(iCurve), lambda);
ptXYZ = nurbsSurfacePoint(nurbs, ptUV(1), ptUV(2));

diffP = ptXYZ-x;
dCurve = diffP*diffP';