function isPeriodic = nurbsSurfaceIsPeriodic(aNurbs)

TOLdist = 1e-5;

% Ordering
% 4-------3
% |       |
% 1-------2
% 

isPeriodic = [0 0];

% Sampling ordering - Using intersection curves will be better!
index12 = 1:aNurbs.sampleNv:aNurbs.sampleNv*(aNurbs.sampleNu-1)+1;
index23 = aNurbs.sampleNv*(aNurbs.sampleNu-1)+1:aNurbs.sampleNv*aNurbs.sampleNu;
index43 = aNurbs.sampleNv:aNurbs.sampleNv:aNurbs.sampleNv*aNurbs.sampleNu;
index14 = 1:aNurbs.sampleNv;

% Sampling points
points12 = aNurbs.sampleX(index12,:);
points23 = aNurbs.sampleX(index23,:);
points43 = aNurbs.sampleX(index43,:);
points14 = aNurbs.sampleX(index14,:);

% Periodicity in U direction (edges 14 and 23 matching)
diffU = points23 - points14;
distU = sqrt( diffU(:,1).^2 + diffU(:,2).^2 + diffU(:,3).^2 );
if max(distU)<TOLdist
    isPeriodic(1) = 1;
end

% Periodicity in V direction (edges 12 and 43 matching)
diffV = points12 - points43;
distV = sqrt( diffV(:,1).^2 + diffV(:,2).^2 + diffV(:,3).^2 );
if max(distV)<TOLdist
    isPeriodic(2) = 1;
end