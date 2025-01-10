function nurbsSurfacePlot(nurbs, parametric, trimmedInfo, N, optPlot)
%
% nurbsSurfacePlot(nurbs, trimmedInfo, N, optPlot)
%
% nurbs:        struct containing NURBS information
% parametric:   plot parametric space or physical space
% trimmedInfo:  plot only a trimmed NURBS
% N:            number of points for the mesh plot (optional)
% optPlot:      if optPlot=1 plot control polygon, patches,...
%

% Optional inputs
if nargin == 1
    parametric=0;
    buildTrimmedMesh = nurbs.isTrimmed;
    trimmedInfo = nurbs.trimmed;
    N = 50;
    optPlot = 0;
else
    if nargin==2
        buildTrimmedMesh = nurbs.isTrimmed;
        trimmedInfo = nurbs.trimmed;
        N = 50;
        optPlot = 0;
    else
        if isempty(trimmedInfo)
            buildTrimmedMesh = nurbs.isTrimmed;
            trimmedInfo = nurbs.trimmed;
        else
            buildTrimmedMesh = 0;
        end
        if nargin == 3
            N = 50;
            optPlot = 0;
        elseif nargin == 4
            optPlot = 0;
        end
    end
end

% Plot options
plotControlPolygon = optPlot;
plotImageBreakpoints = optPlot;
plotPatches = optPlot;

%% Intersection curves
loops = nurbsSurfaceExtractBoundaryCurves(nurbs);

%% Surface mesh in the parametric space
if buildTrimmedMesh
    [Xu,Tu] = nurbsSurfaceSubmeshTrimmedRegion(loops,N);
else
    [Xu,Tu] = createMesh(0,4,-1,1,-1,1,N,N);
    Tu = [Tu(:,1:3); Tu(:,[3,4,1])];
    if length(trimmedInfo) == 4
        % Square in the parametric space
        Xu = nefemInterpMapSquare2Square(Xu, trimmedInfo);
    elseif length(trimmedInfo) == 3
        % Triangle in the parametric space
        Xu = nefemInterpMapSquare2Tri(Xu, trimmedInfo);
    end
end

% Surface points or parametric space
nPoints = size(Xu,1);
if parametric
    sPoints = [Xu, zeros(nPoints,1)];
else
    sPoints = zeros( nPoints, 3);
    for iPoint = 1:nPoints
        sPoints(iPoint,:) = nurbsSurfacePoint(nurbs, Xu(iPoint,1), Xu(iPoint,2));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Postprocess
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% colElem = [217 217 217]/256;
colElem = [197 241 197]/256;
faceAlpha = 1;
trisurf(Tu,sPoints(:,1),sPoints(:,2),sPoints(:,3),sPoints(:,1)*0,...
    'EdgeColor','none','FaceColor',colElem,'FaceAlpha',faceAlpha,'Facelighting','phong')
hold on
nOfLoops = numel(loops);
% for iLoop = 1:nOfLoops
%     plot3(loops(iLoop).X(:,1),loops(iLoop).X(:,2),loops(iLoop).X(:,3),'b','LineWidth',1)
% end

% Breakpoints
if plotImageBreakpoints
    nOfUniqueU = length(nurbs.Uunique);
    nOfUniqueV = length(nurbs.Vunique);
    nOfBreakPoints = nOfUniqueU*nOfUniqueV;
    breakPoints = zeros(nOfBreakPoints,3);
    k = 1;
    for u=nurbs.Uunique
        for v=nurbs.Vunique
            breakPoints(k,:) =  nurbsSurfacePoint(nurbs, u, v);
            k = k + 1;
        end
    end
    plot3(breakPoints(:,1),breakPoints(:,2),breakPoints(:,3),'bs')
end

if plotControlPolygon
    pos = 1:nurbs.nU+1;
    for iv = 1:nurbs.nV+1
        P = nurbs.Pw(pos,1:3)./[nurbs.Pw(pos,4),nurbs.Pw(pos,4),nurbs.Pw(pos,4)];
        plot3(P(:,1), P(:,2), P(:,3), 'r-o', 'Linewidth', 2)
        pos = pos + nurbs.nU+1;
    end
    pos = 1:nurbs.nU+1:(nurbs.nU+1)*nurbs.nV+1;
    for iu = 1:nurbs.nU+1
        P = nurbs.Pw(pos,1:3)./[nurbs.Pw(pos,4),nurbs.Pw(pos,4),nurbs.Pw(pos,4)];
        plot3(P(:,1), P(:,2), P(:,3), 'r-o', 'Linewidth', 2)
        pos = pos + 1;
    end
    hold on
end

if plotPatches
    nurbsSurfacePlotPatches(nurbs, N)
end

