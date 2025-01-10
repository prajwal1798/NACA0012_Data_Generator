function [Cu, dCu] = nurbsCurveDerivPoint(nurbs,u)
%
% [Cu, dCu] = nurbsCurveDerivPoint(nurbs,u)
%
% Input:
% nurbs:  struct containing the nurbs curve information
% u:      parameter 
%
% Output:
% Cu:     point of the nurbs curve
% dCu:    derivative of the nurbs at point Cu
%
[Cu,wu] = nurbsCurvePoint(nurbs,u);
[pDer,wDer] = nurbsCurvePointNoHom(nurbs.derU,u);
dCu = (pDer - Cu*wDer)/wu;
