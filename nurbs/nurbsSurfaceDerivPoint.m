function [S, dSdu, dSdv] = nurbsSurfaceDerivPoint(nurbs, u, v)
%
% [Suv, dSdu, dSdv] = nurbsSurfaceDerivPoint(nurbs, u, v)
%
% Only first derivatives at this moment
% (for an implementation of higher derivatives see
% The NURBS Book - Page 136
%

[Au, Wu] = nurbsSurfacePointNoHom(nurbs.derU, u, v);
[Av, Wv] = nurbsSurfacePointNoHom(nurbs.derV, u, v);
[S, W]  = nurbsSurfacePoint(nurbs, u, v);
dSdu = (Au - Wu*S)/W;
dSdv = (Av - Wv*S)/W;