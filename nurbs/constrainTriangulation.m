function T = constrainTriangulation(X,T,polygon)

nOfElements = size(T,1);

Xmean = zeros(nOfElements,2);
for iElem = 1:nOfElements
    Te = T(iElem,:);
    Xe = X(Te,:);
    Xmean(iElem,:) = mean(Xe);
    
    % Check for zero area      
    J = det([Xe(2,:)-Xe(1,:) ; Xe(3,:)-Xe(1,:)]);
    if det(J)<1e-6
        Xmean(iElem,:) = 1e18;
    end
end

isInside = inpolygon(Xmean(:,1),Xmean(:,2),polygon(:,1),polygon(:,2));
T = T(isInside==1,:);

    
