function nurbsDer2 = nurbsCurveSecondDerivControlPoints(nurbs) 
%
% nurbsDer = nurbsCurveDerivControlPoints(nurbs) 
%

U = nurbs.U;
Pw = nurbs.Pw;

nurbsDer2.U = U(3:end-2);
nurbsDer2.Pw = zeros(nurbs.nU-1,4);

for i = 1:nurbs.nU-1
    PwI = nurbs.pU*(Pw(i+1,:)-Pw(i,:))/(U(i+nurbs.pU+1)-U(i+1));
    PwIPlus1 = nurbs.pU*(Pw(i+2,:)-Pw(i+1,:))/(U(i+nurbs.pU+2)-U(i+2));
    if(U(i+nurbs.pU+1)-U(i+2)<1e-5)
        nurbsDer2.Pw(i,:) = 0;
    else
        nurbsDer2.Pw(i,:) = (nurbs.pU-1)*(PwIPlus1-PwI)/(U(i+nurbs.pU+1)-U(i+2));    
    end
end
nurbsDer2.pU = nurbs.pU-2;
nurbsDer2.mU = nurbs.mU-4;
nurbsDer2.nU = nurbs.nU-2;