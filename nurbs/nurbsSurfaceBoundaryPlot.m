function nurbsSurfaceBoundaryPlot(nurbs, numbering)

if nargin==1
    numbering=0;
end

nOfNurbs = length(nurbs);

hold on
for iNurbs=1:nOfNurbs
    nurbsSurfacePlot(nurbs(iNurbs))
end

if numbering
    for iNurbs=1:nOfNurbs
        midParamU = 0.5*(nurbs(iNurbs).U(end) + nurbs(iNurbs).U(1));
        midParamV = 0.5*(nurbs(iNurbs).V(end) + nurbs(iNurbs).V(1));
        pt = nurbsSurfacePoint(nurbs(iNurbs), midParamU, midParamV);
        text(pt(1), pt(2), pt(3), num2str(iNurbs), 'Fontsize',15)
    end
end