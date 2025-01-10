function nurbs = nurbsSurfaceCreateCylinder(center, radius, h)

P  = [ 1, 0,-1
    1, 0, 0
    1, 0, 1
    1, 1, -1
    1, 1,  0
    1, 1,  1
    0, 1, -1
    0, 1,  0
    0, 1,  1
    -1, 1, -1
    -1, 1,  0
    -1, 1,  1
    -1, 0, -1
    -1, 0,  0
    -1, 0,  1
    -1,-1, -1
    -1,-1,  0
    -1,-1,  1
    0,-1, -1
    0,-1,  0
    0,-1,  1
    1,-1, -1
    1,-1,  0
    1,-1,  1
    1, 0, -1
    1, 0,  0
    1, 0,  1];


P(:,1:2) = P(:,1:2)*radius;
P(:,1) = P(:,1) + center(1);
P(:,2) = P(:,2) + center(2);
P(:,3) = 0.5*h*P(:,3) + center(3);


% pesos
a = sqrt(2)/2;
w1 = [a , 1, a]';
w2 = [0.5, a, 0.5]';

w = [w1;w2;w1;w2;w1;w2;w1;w2;w1];


N = size(P,1);
Pw = zeros(N,4);
Pw(:,1) = P(:,1).*w;
Pw(:,2) = P(:,2).*w;
Pw(:,3) = P(:,3).*w;
Pw(:,4) = w;


U = [-pi/2,-pi/2,-pi/2,pi/2,pi/2,pi/2];
V = [0,0,0,pi/2,pi/2,pi,pi,3*pi/2,3*pi/2,2*pi,2*pi,2*pi];


nurbs.U = U;
nurbs.V = V;
nurbs.Pw = Pw;
nurbs.trimmed = [nurbs.U(1) nurbs.V(1)
    nurbs.U(end) nurbs.V(1)
    nurbs.U(end) nurbs.V(end)
    nurbs.U(1) nurbs.V(end)];