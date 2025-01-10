function [Cu, dCu, dCu2] = nurbsCurveSecondDerivPoint(nurbs,u)
%
% [Cu, dCu, dCu2] = nurbsCurveSecondDerivPoint(nurbs,u)
%
% Input:
% nurbs:  struct containing the nurbs curve information
% u:      parameter 
%
% Output:
% Cu:     point of the nurbs curve
% dCu:    derivative of the nurbs at point Cu
% dCu2:   second derivative of the nurbs at point Cu
%

[Cu,wu] = nurbsCurvePoint(nurbs,u);
[pDer,wDer] = nurbsCurvePointNoHom(nurbs.derU,u);

if nurbs.pU==1
    pDer2 = [0 0 0];
    wDer2 = 0;
else
    [pDer2, wDer2] = nurbsCurvePointNoHom(nurbs.derUU,u);
end

% [pDer2,wDer2] = nurbsCurvePointNoHom(nurbs.derUU,u);
dCu = (pDer - Cu*wDer)/wu;
dCu2 = (pDer2 - 2*wDer*dCu - wDer2*Cu)/wu;