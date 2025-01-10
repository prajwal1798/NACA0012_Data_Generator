function nurbsNew = nurbsCurveKnotInsertion(nurbs, u, quadRef)

k  = nurbsCurveFindSpan(u,nurbs);

Qw = zeros(nurbs.pU, 4);
j = 1;
for i=k-nurbs.pU+1:k
    ai = (u - nurbs.U(i))/(nurbs.U(i+nurbs.pU) - nurbs.U(i) );
    Qw(j,:) = (1-ai)*nurbs.Pw(i-1,:) + ai*nurbs.Pw(i,:);
    j = j+1;
end

nurbsNew.U = [nurbs.U(1:k), u, nurbs.U(k+1:end)];
nurbsNew.Pw = [nurbs.Pw(1:k-nurbs.pU,:); Qw; nurbs.Pw(k:end,:)];
nurbsNew.iniParam = nurbs.iniParam;
nurbsNew.endParam = nurbs.endParam;

nurbsNew = nurbsCurveSetupStruct(nurbsNew, quadRef);