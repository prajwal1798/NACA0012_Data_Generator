function  nurbs = nurbsCurveBasicBasisFunctions(nurbs)

nurbs.Nu = zeros(1,nurbs.pU+1);
nurbs.Nu(1) = 1;
nurbs.aux.leftU = zeros(1,nurbs.pU+1);
nurbs.aux.rightU = zeros(1,nurbs.pU+1);