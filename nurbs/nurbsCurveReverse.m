function nurbs = nurbsCurveReverse(nurbs)

nurbs.U = [nurbs.U(1), nurbs.U(1)+cumsum(fliplr(diff(nurbs.U)))];
nurbs.Pw = flipud(nurbs.Pw);

quadRef = defineQuadratureAdaptive();
nurbs = nurbsCurveSetupStruct(nurbs, quadRef);