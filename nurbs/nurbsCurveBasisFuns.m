function nurbs = nurbsCurveBasisFuns(i,u,nurbs)
%
% nurbs = nurbsCurveBasisFuns(i,u,nurbs)
% 
% Non-zero basis functions for a NURBS curve
%

nurbs.Nu(1)=1;

for j=1:nurbs.pU
    nurbs.aux.leftU(j) = u - nurbs.U(i+1-j);
    nurbs.aux.rightU(j) = nurbs.U(i+j) - u;
    res = 0;
    
    for k=1:j
        aux = nurbs.Nu(k)/(nurbs.aux.rightU(k) + nurbs.aux.leftU(j-k+1));
        nurbs.Nu(k) = res + nurbs.aux.rightU(k)*aux;
        res = nurbs.aux.leftU(j-k+1)*aux;
    end
    
    nurbs.Nu(j+1) = res;
end
