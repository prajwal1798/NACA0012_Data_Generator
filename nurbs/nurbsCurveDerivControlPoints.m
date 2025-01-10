function nurbsDer = nurbsCurveDerivControlPoints(nurbs) 
%
% nurbsDer = nurbsCurveDerivControlPoints(nurbs) 
%

U = nurbs.U;
Pw = nurbs.Pw;

nurbsDer.U = U(2:end-1);

nurbsDer.Pw = zeros(nurbs.nU,4);
for i = 1:nurbs.nU
    nurbsDer.Pw(i,:) = nurbs.pU*(Pw(i+1,:)-Pw(i,:))/(U(i+nurbs.pU+1)-U(i+1));    
end
nurbsDer.pU = nurbs.pU-1;
nurbsDer.mU = nurbs.mU-2;
nurbsDer.nU = nurbs.nU-1;