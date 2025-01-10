function nurbsSurfacePlotPatches(nurbs, N)

lineSty = 'b--';

uPlot = linspace(nurbs.U(1),nurbs.U(end),N);
vPlot = linspace(nurbs.V(1),nurbs.V(end),N);
pth = zeros(N,3);


for u=nurbs.Uunique
    k = 1;
    for v=vPlot
        pth(k,:) = nurbsSurfacePoint(nurbs, u, v);
        k = k + 1;
    end
    plot3(pth(:,1),pth(:,2),pth(:,3),lineSty,'LineWidth',2)
end

for v=nurbs.Vunique
    k = 1;
    for u=uPlot
        pth(k,:) = nurbsSurfacePoint(nurbs, u, v);
        k = k + 1;
    end
    plot3(pth(:,1),pth(:,2),pth(:,3),lineSty,'LineWidth',2)
end
