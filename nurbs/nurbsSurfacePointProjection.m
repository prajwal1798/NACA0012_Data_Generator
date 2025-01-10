function [u, Su, iIter] = nurbsSurfacePointProjection(aNurbs, x, nOfMaxIterations)

if nargin==2
    nOfMaxIterations = 2000;
end
TOLdist = 1e-12;
TOLangle = TOLdist/10;


uIni = aNurbs.U(1);
uEnd = aNurbs.U(end);
vIni = aNurbs.V(1);
vEnd = aNurbs.V(end);

% Find minimum for initial guess ------------------------------------------
% dMin = 1e10;
% for iSample = 1:aNurbs.sampleN
%     diff = aNurbs.sampleX(iSample,:) - x;
%     d = norm(diff);
%     if(d<dMin)
%         dMin = d;
%         posMin = iSample;
%     end
% end

diffP = zeros(aNurbs.sampleN,3);
diffP(:,1) = aNurbs.sampleX(:,1) - x(1);
diffP(:,2) = aNurbs.sampleX(:,2) - x(2);
diffP(:,3) = aNurbs.sampleX(:,3) - x(3);
dist = diffP(:,1).^2 + diffP(:,2).^2 + diffP(:,3).^2;
[dMin, posMin] = min(dist);


% Parameters
j = mod(posMin, aNurbs.sampleNv);
if j==0
    j = aNurbs.sampleNv;
end
i = (posMin-j)/aNurbs.sampleNv + 1;
u = [aNurbs.sampleU(i)  aNurbs.sampleV(j)];


% Keep dMin to check if the minimum distance is achieved via iteration
% or a closer breakpoint exists (d can be reused)

% Newton iteration
[S, dSdu, dSdv, dSduu,dSduv,dSdvv] = nurbsSurfaceSecondDerivPoint(aNurbs, u(1), u(2));

if nOfMaxIterations==0
    Su = S;
    iIter = 0;
else
    
    for iIter = 1:nOfMaxIterations
        diff = S-x;
        d = norm(diff);
        if(d<TOLdist)
            % Point coincidence
            break
        end
        
        dCudCu = dSdu*dSdu';
        dCvdCv = dSdv*dSdv';
        dCuDiff = dSdu*diff';
        dCvDiff = dSdv*diff';
        zeroCosU = abs(dCuDiff)/(abs(dCudCu)*d);
        zeroCosV = abs(dCvDiff)/(abs(dCvdCv)*d);
        if(zeroCosU<TOLangle && zeroCosV<TOLangle)
            % Zero cosine
            break
        end
        
        % Iterate
        J(1,:) = [ dCudCu + dSduu*diff', dSdu*dSdv' + dSduv*diff' ];
        J(2,:) = [ J(1,2),  dCvdCv + dSdvv*diff' ];
        if abs(det(J))<1e-14
            break;
        end
        kappa(1) = dCuDiff;
        kappa(2) = dCvDiff;
        invJ = inv(J);
        deltaU = -invJ*kappa';
        
        uNew = u + deltaU';
        
        % Correct the parameter if it is outside the valid range
        if(aNurbs.isPeriodic(1))
            if(uNew(1)<uIni)
                uNew(1) = uEnd - uIni + uNew(1);
            elseif(uNew(1)>uEnd)
                uNew(1) = uIni - uEnd + uNew(1);
            end
        else
            if(uNew(1)<uIni)
                uNew(1) = uIni;
            elseif(uNew(1)>uEnd)
                uNew(1) = uEnd;
            end
        end
        if(aNurbs.isPeriodic(2))
            if(uNew(2)<vIni)
                uNew(2) = vEnd - vIni + uNew(2);
            elseif(uNew(2)>vEnd)
                uNew(2) = vIni - vEnd + uNew(2);
            end
        else
            if(uNew(2)<vIni)
                uNew(2) = vIni;
            elseif(uNew(2)>vEnd)
                uNew(2) = vEnd;
            end
        end
        
        diff = (uNew(1)-u(1))*dSdu + (uNew(2)-u(2))*dSdv;
        if(norm(diff)<TOLdist)
            % Two consecutive parameters are too close
            break
        end
        u = uNew;
        
        [S, dSdu, dSdv, dSduu,dSduv,dSdvv] = nurbsSurfaceSecondDerivPoint(aNurbs, u(1), u(2));
        
        % Update dMin
        if(d<dMin)
            dMin = d;
        end
    end
    
    % Check if the parameter is inside the valid range
    if(u(1)<aNurbs.U(1))
        u(1) = aNurbs.U(1);
    elseif(u(1)>aNurbs.U(end))
        u(1) = aNurbs.U(end);
    end
    if(u(2)<aNurbs.V(1))
        u(2) = aNurbs.V(1);
    elseif(u(2)>aNurbs.V(end))
        u(2) = aNurbs.V(end);
    end
    
    % Check if any breakpoint is a better approximation than achieved
    % with the iteration
    % This solves some problems when the initial point of a curve is
    % the projection as the iteration process may fail
    uUnique = aNurbs.Uunique;
    vUnique = aNurbs.Vunique;
    nOfKnotsU = length(uUnique);
    nOfKnotsV = length(vUnique);
    for iKnot=1:nOfKnotsU
        ui = uUnique(iKnot);
        for jKnot=1:nOfKnotsV
            vi = vUnique(jKnot);
            S = nurbsSurfacePoint(aNurbs, ui, vi);
            diff = S-x;
            d = norm(diff);
            if(d-dMin<TOLdist)
                u = [ ui, vi ];
                dMin = d;
            end
        end
    end
    
    Su = nurbsSurfacePoint(aNurbs, u(1), u(2));
end