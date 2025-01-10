function isSingular = nurbsSurfaceIsSingular(aNurbs)
%
% isSingular = nurbsSurfaceIsSingular(aNurbs)
%

TOLdecimalPlaces = 3;

% Ordering
% 4-------3
% |       |
% 1-------2


isSingular = [0 0 0 0];  % Vector for degeneration of edges [p1-p4 p2-p3 p1-p2 p3-p4]

% Sampling ordering - Using intersection curves should be better!
index12 = 1:aNurbs.sampleNv:aNurbs.sampleNv*(aNurbs.sampleNu-1)+1;
index23 = aNurbs.sampleNv*(aNurbs.sampleNu-1)+1:aNurbs.sampleNv*aNurbs.sampleNu;
index43 = aNurbs.sampleNv:aNurbs.sampleNv:aNurbs.sampleNv*aNurbs.sampleNu;
index14 = 1:aNurbs.sampleNv;

% Sampling points - rounded to check if they coincide at a single point
points12 = unique(round( aNurbs.sampleX(index12,:), TOLdecimalPlaces),'rows');
points23 = unique(round( aNurbs.sampleX(index23,:), TOLdecimalPlaces),'rows');
points43 = unique(round( aNurbs.sampleX(index43,:), TOLdecimalPlaces),'rows');
points14 = unique(round( aNurbs.sampleX(index14,:), TOLdecimalPlaces),'rows');

% Establish singularities
if size(points14,1)==1, isSingular(1) = 1; end
if size(points23,1)==1, isSingular(2) = 1; end
if size(points12,1)==1, isSingular(3) = 1; end
if size(points43,1)==1, isSingular(4) = 1; end