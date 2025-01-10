function lengthNurbs = nurbsCurveLength(aNurbs, u1, u2, z01, w01)
%
%lengthNurbs = nurbsCurveLength(aNurbs, u1, u2, z01, w01)
%

% Compute quadrature in the parametric space with breakpoints
[gauss,weight] = nurbsCurveQuadrature(aNurbs, u1, u2, z01, w01);
nOfPoints = length(weight);
for iPoint=1:nOfPoints
	[Cu, dCu] = nurbsCurveDerivPoint(aNurbs, gauss(iPoint));
    jacobianNurbs = norm(dCu);
    weight(iPoint) = weight(iPoint)*jacobianNurbs;
end 
lengthNurbs = sum(weight);