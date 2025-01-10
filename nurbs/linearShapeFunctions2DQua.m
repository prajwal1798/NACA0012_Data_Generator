function [N1, N2, N3, N4] = linearShapeFunctions2DQua(xi,eta) 
%
% [N1, N2, N3, N4] = linearShapeFunctions2DQua(xi,eta) 
% Bilinear shape functions in the reference square [-1,-1; 1,-1; 1,1; -1,1] 
% Input: xi,eta: point in local coordinates
%
% Output:
% N1,N2,N3,N4: shape functions in the point [xi,eta] 
%
% NUMBERING
% 4__3
% |  |
% |__|
% 1  2
%

N1 =  0.25*(xi-1).*(eta-1);
N2 = -0.25*(xi+1).*(eta-1);
N3 =  0.25*(xi+1).*(eta+1);
N4 = -0.25*(xi-1).*(eta+1);