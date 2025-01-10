function uNodes = nurbsCurveNodalDistribution(aNurbs, u1, u2, nodes1D, quadRef, lengthTOL)

if nargin<6
    lengthTOL = 1e-5;
end

swap = 0;
if u1>u2
    swap = 1;
    uTmp = u2;
    u2 = u1;
    u1 = uTmp;
end

nOfPoints = numel(nodes1D);
uNodes = zeros(nOfPoints,1);
uNodes(1) = u1;
uNodes(nOfPoints) = u2;

% Nodal distribution on the reference element used to define lengths
lengthU = abs(u2-u1);
lengthInterval = nurbsCurveLengthAdaptive(aNurbs, u1, u2, quadRef, lengthTOL);
factor = lengthInterval/lengthU;
uGuess = 0.5*lengthU*(nodes1D + 1) + u1;     % [u1,u2]

nOfIntPoints = nOfPoints-2;

nOfMaxIterations = 1000;
for iIntPoints=1:nOfIntPoints
    currentLength = abs(uGuess(iIntPoints+1)-u1)*factor;
    a = u1;
    b = u2;
    
    % Initial guess
    uOld = 0.5*(uGuess(iIntPoints) + uGuess(iIntPoints+2));
    length = nurbsCurveLengthAdaptive(aNurbs, u1 , uOld, quadRef, lengthTOL);
    
    % Bisection
    for iter = 1:nOfMaxIterations
        f = length - currentLength;
        if(abs(f)<lengthTOL) 
            uNodes(iIntPoints+1) = uOld;
            break
        elseif(f>0.0) 
            b = uOld;
        else
            a = uOld;
        end
        uNodes(iIntPoints+1) = 0.5*(a + b);
        
        % Check if the desired accuracy has been achieved
        length = nurbsCurveLengthAdaptive(aNurbs, u1 , uNodes(iIntPoints+1), quadRef, lengthTOL);
        errU = abs(uOld-uNodes(iIntPoints+1))/lengthU;
        errF = abs(currentLength - length)/currentLength;
        if(errU<lengthTOL && errF<lengthTOL)
            break
        end        
        uOld=uNodes(iIntPoints+1);
    end    
end


if swap
    uNodes = flipud(uNodes);
end
