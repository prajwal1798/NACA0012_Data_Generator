function [pt,w] = nurbsSurfacePoint(nurbs,u,v)
%

uspan = nurbsCurveFindSpan(u,nurbs);
nurbs = nurbsCurveBasisFuns(uspan,u,nurbs);

vspan = nurbsCurveFindSpanV(v,nurbs);
nurbs = nurbsCurveBasisFunsV(vspan,v,nurbs);

uind = uspan -  nurbs.pU;
pt = 0;
for j=1: nurbs.pV+1
    aux = 0;
    InP1 = (vspan -  nurbs.pV + j -2)*(nurbs.nU+1);
    for k=1: nurbs.pU+1
        J = uind+k-1;
        aux = aux + nurbs.Nu(k)*nurbs.Pw(J + InP1,:);
    end
    pt = pt + nurbs.Nv(j)*aux;
end

w = pt(4);
pt = pt(1:3)/w;
