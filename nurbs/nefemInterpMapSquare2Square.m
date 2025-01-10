function Xu = nefemInterpMapSquare2Square(Xu, Xqua)


% From reference square to the target square
% (use the isoparametric transformation)
[N1, N2, N3, N4] = linearShapeFunctions2DQua(Xu(:,1),Xu(:,2));
Xu = [Xqua(1,1)*N1 +  Xqua(2,1)*N2 + Xqua(3,1)*N3 + Xqua(4,1)*N4,...
      Xqua(1,2)*N1 +  Xqua(2,2)*N2 + Xqua(3,2)*N3 + Xqua(4,2)*N4];