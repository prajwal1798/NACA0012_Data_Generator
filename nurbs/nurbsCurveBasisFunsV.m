function nurbs = nurbsCurveBasisFunsV(i,v,nurbs)
%
% nurbs = nurbsCurveBasisFuns(i,u,nurbs)
% 
% Non-zero basis functions for a NURBS curve
%

nurbs.Nv(1)=1;

for j=1:nurbs.pV
    nurbs.aux.leftV(j) = v - nurbs.V(i+1-j);
    nurbs.aux.rightV(j) = nurbs.V(i+j) - v;
    res = 0;
    
    for k=1:j
        aux = nurbs.Nv(k)/(nurbs.aux.rightV(k) + nurbs.aux.leftV(j-k+1));
        nurbs.Nv(k) = res + nurbs.aux.rightV(k)*aux;
        res = nurbs.aux.leftV(j-k+1)*aux;
    end
    
    nurbs.Nv(j+1) = res;
end
