function [S, dSdu, dSdv, dSduu,dSduv,dSdvv] = nurbsSurfaceSecondDerivPoint(nurbs, u, v)
%

[S, W]  = nurbsSurfacePoint(nurbs, u, v);

[Au, Wu] = nurbsSurfacePointNoHom(nurbs.derU, u, v);
[Av, Wv] = nurbsSurfacePointNoHom(nurbs.derV, u, v);

if nurbs.pU==1
    pointUU = [0 0 0];
    weightUU = 0;
else
    [pointUU, weightUU] = nurbsSurfacePointNoHom(nurbs.derUU, u, v);
end

if nurbs.pU==1 && nurbs.pV==1
    pointUV = [0 0 0];
    weightUV = 0;
else
    [pointUV, weightUV] = nurbsSurfacePointNoHom(nurbs.derUV, u, v);
end

if nurbs.pV==1
    pointVV = [0 0 0];
    weightVV = 0;
else
    [pointVV, weightVV] = nurbsSurfacePointNoHom(nurbs.derVV, u, v);
end

dSdu = (Au - Wu*S)/W;
dSdv = (Av - Wv*S)/W;

dSduu = (pointUU - 2.0D0*Wu*dSdu - weightUU*S)/W;
dSduv = (pointUV - weightUV*S - Wu*dSdv- Wv*dSdu)/W;
dSdvv = (pointVV - 2.0D0*Wv*dSdv - weightVV*S)/W;