function [nurbsDerU,nurbsDerV] = nurbsSurfaceDerivControlPoints(nurbs)
%
% [nurbsDerU,nurbsDerV] = nurbsSurfaceDerivControlPoints(nurbs)
%

U = nurbs.U;
V = nurbs.V;
Pw = nurbs.Pw;
p = nurbs.pU;
q = nurbs.pV;
nU = nurbs.nU;
nV = nurbs.nV;

%% U direction
nurbsDerU.U = U(2:end-1);
nurbsDerU.V = V;
nurbsDerU.Pw = zeros(nU,4);

k = 1;
for j=1:nV+1
    for i = 1:nU
        if(U(i+p+1)-U(i+1)<1e-5)
            nurbsDerU.Pw(k,:) = 0;
        else
            ind = i + (j-1)*(nU+1);
            nurbsDerU.Pw(k,:) = p*(Pw(ind+1,:)-Pw(ind,:))/(U(i+p+1)-U(i+1));            
        end
        k = k + 1;
    end
end

%% V direction
nurbsDerV.U = U;
nurbsDerV.V = V(2:end-1);
nurbsDerV.Pw = zeros(nV,4);

k = 1;
for j= 1:nV
    L = (nU+1);
    for i=1:nU+1
        if(V(j+q+1)-V(j+1)<1e-5)
            nurbsDerV.Pw(k,:) = 0;
        else
            ind = i + (j-1)*(nU+1);
        nurbsDerV.Pw(k,:) = q*(Pw(ind+L,:)-Pw(ind,:))/(V(j+q+1)-V(j+1));         
        end
        k = k+1;
    end
end

