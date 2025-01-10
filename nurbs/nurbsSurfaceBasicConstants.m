function nurbs = nurbsSurfaceBasicConstants(nurbs)

if isempty(nurbs.U)
    nurbs.pU = 0;
else
    nurbs.pU = length(find(nurbs.U==nurbs.U(1))) - 1;
end

if isempty(nurbs.V)
    nurbs.pV = 0;
else
    nurbs.pV = length(find(nurbs.V==nurbs.V(1))) - 1;
end

nurbs.mU = length(nurbs.U) - 1;
nurbs.nU = nurbs.mU - nurbs.pU - 1;
nurbs.mV = length(nurbs.V) - 1;
nurbs.nV = nurbs.mV - nurbs.pV - 1;