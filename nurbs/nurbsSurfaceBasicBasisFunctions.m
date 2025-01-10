function  nurbs = nurbsSurfaceBasicBasisFunctions(nurbs)

nurbs.Nu = zeros(1,nurbs.pU+1);
nurbs.Nu(1) = 1;
nurbs.aux.leftU = zeros(1,nurbs.pU+1);
nurbs.aux.rightU = zeros(1,nurbs.pU+1);

nurbs.Nv = zeros(1,nurbs.pV+1);
nurbs.Nv(1) = 1;
nurbs.aux.leftV = zeros(1,nurbs.pV+1);
nurbs.aux.rightV = zeros(1,nurbs.pV+1);