function [X,T] = nurbsSurfaceSubmeshTrimmedRegion(loops,N)

% For multiply-connected domains NaNs are neede to separate the different
% polygons (check help inpolygon)
nOfLoops = numel(loops);
nOfPointsLoops = zeros(nOfLoops,1);
for iLoop = 1:nOfLoops
    nOfPointsLoops(iLoop) = nOfPointsLoops(iLoop) + size(loops(iLoop).U,1);
    boxLoop.min(iLoop,:) = min(loops(iLoop).U);
    boxLoop.max(iLoop,:) = max(loops(iLoop).U);
end

% Identify the "bigger" loop ----------------------------------------------
if nOfLoops>1
    [notUsed, posMin] = min(boxLoop.min);
    [notUsed, posMax] = max(boxLoop.max);
    if unique(posMin)==unique(posMax)
        bigLoop = unique(posMin);
    end
else
    bigLoop = 1;
end

% Check and modify (if needed) the orientation ----------------------------
for iLoop = 1:nOfLoops
    orientation = 0;
    iPoint = 1;
    while orientation==0
        % Recursively compute cross product (to avoid zero due to lines
        % being sampled)
        v1 = loops(iLoop).U(iPoint+1,:)-loops(iLoop).U(iPoint,:);
        v2 = loops(iLoop).U(iPoint+2,:)-loops(iLoop).U(iPoint+1,:);
        orientation = sign( v1(1)*v2(2) - v1(2)*v2(1) );
        iPoint = iPoint + 1;
    end
    if iLoop==bigLoop
        % Counter-clockwise
        if orientation==-1
            loops(iLoop).U = flipud(loops(iLoop).U);
        end
    else
        % Clockwise
        if orientation==1
            loops(iLoop).U = flipud(loops(iLoop).U);
        end
    end
end

% Add the positions for the NaNs
nOfPointsTotal = sum(nOfPointsLoops) + nOfLoops - 1;
% Store all points as a single array with NaNs
loopParam = zeros(nOfPointsTotal,2);
loopParam(1:nOfPointsLoops(1),:) = loops(1).U;
indexIni = nOfPointsLoops(1) + 1;
for iLoop = 2:nOfLoops
    indexEnd = indexIni + nOfPointsLoops(iLoop);
    loopParam(indexIni:indexEnd,:) = [NaN NaN; loops(iLoop).U];
    indexIni = indexEnd + 1;
end

% Define a box on the parametric space
minBox = min(loopParam(:,1:2));
maxBox = max(loopParam(:,1:2));

% Define points within the box
xMin = minBox(1);
xMax = maxBox(1);
yMin = minBox(2);
yMax = maxBox(2);
hx = (xMax-xMin)/N;
hy = (yMax-yMin)/N;

% Create a structured mesh (only points)
X = zeros(N*N,2);
xs = linspace(xMin+hx,xMax-hx,N)';
ys = linspace(yMin+hy,yMax-hy,N);

auxOne = ones(N,1);
boundaryNodes = zeros(4*N-4,1);
boundaryNodes(1:N) = 1:N;
boundaryNodes(3*N-3:4*N-4) = N*N-N+1:N*N;
indexBoundary = N+1;
for i=1:N
    yi = ys(i)*auxOne;
    index = (i-1)*(N)+1:i*(N);
    X(index,:)=[xs, yi];
    if i~=1 && i~=N
        boundaryNodes(indexBoundary) = index(1);
        boundaryNodes(indexBoundary+1) = index(N);
        indexBoundary = indexBoundary + 2;
    end
end

% Select the points of the grid inside the trimmed region
isInside = inpolygon(X(:,1),X(:,2),loopParam(:,1),loopParam(:,2));
X = X(isInside==1,:);

% Define points to triangulate
posNotNaN = find(~isnan(loopParam(:,1)));
X = [loopParam(posNotNaN,1:2); X];
X = unique(X, 'rows') ;

% Scaling before delaunay - Otherwise bad shaped triangles when x and y
% dimensions are very different, resulting in bad rendering
X(:,1) = (X(:,1)-xMin)/(xMax - xMin);
X(:,2) = (X(:,2)-yMin)/(yMax - yMin);
T = delaunay(X(:,1),X(:,2));

% Scale back
X(:,1) = xMin + X(:,1)*(xMax - xMin);
X(:,2) = yMin + X(:,2)*(yMax - yMin);

% Constrain using the intersection curves
T = constrainTriangulation(X,T,loopParam);