function nurbsCurveBoundaryPlot(nurbs, numbering, colors)

if nargin==1
    numbering=0;
end

if nargin<3
    colors = {'m','g','b','k','k'};
end

nOfNurbs = length(nurbs);

nOfRep = ceil(nOfNurbs/length(colors));
colors = repmat(colors,1,nOfRep);

hold on
for iNurbs=1:nOfNurbs
    nurbsCurvePlot(nurbs(iNurbs), nurbs(iNurbs).iniParam, nurbs(iNurbs).endParam, colors{iNurbs}, 1000);
end

if numbering
    for iNurbs=1:nOfNurbs
        midParam = 0.5*(nurbs(iNurbs).endParam + nurbs(iNurbs).iniParam);
        pt = nurbsCurvePoint(nurbs(iNurbs), midParam);
        text(pt(1), pt(2), pt(3), num2str(iNurbs), 'Fontsize',15)
    end
end