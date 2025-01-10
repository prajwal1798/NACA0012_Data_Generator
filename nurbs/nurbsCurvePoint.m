function [pt,w] = nurbsCurvePoint(nurbs,u)
%
% [pt,w] = nurbsCurvePoint(nurbs,u,strHom)
% 
% Input:
% nurbs:  struct containing the nurbs curve information
% u:      parameter 
%
% Output:
% pt:     point of the nurbs curve
% w:      weight (non-homogeneous coordinates)

span = nurbsCurveFindSpan(u,nurbs);
nurbs = nurbsCurveBasisFuns(span,u,nurbs);

pt = zeros(1,4);
auxPos = span - nurbs.pU - 1;
for i=1:nurbs.pU+1
    pt = pt + nurbs.Nu(i)*nurbs.Pw(auxPos+i,:);
end

w = pt(4);
pt = pt(1:3)/w;