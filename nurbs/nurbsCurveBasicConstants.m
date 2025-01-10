function nurbs = nurbsCurveBasicConstants(nurbs)

if isempty(nurbs.U)
    nurbs.pU = 0;
else
    nurbs.pU = length(find(nurbs.U==nurbs.U(1))) - 1;
end

nurbs.mU = length(nurbs.U) - 1;
nurbs.nU = nurbs.mU - nurbs.pU - 1;