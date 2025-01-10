function [nurbsNew, t] = nurbsCurveKnotRemoval(nurbs, u, num)

TOL = 1e-3;

% NURBS info
U = nurbs.U;
Pw = nurbs.Pw;
p = length(find(U==U(1))) - 1;
m = length(U) - 1;
n = m - p - 1;

% Multiplicity of the knot to be removed
pos = find( abs(U-u)<1e-5 );
r = pos(1);
s = length(pos);

ord = p + 1;
fout = (2*r-s-p)/2;
last = r-s;
first = r-p;

temp = zeros(2*p+1,4);

for t=0:num
    off = first;
    temp(1,:) = Pw(off,:);
    temp(last+1-off,:) = Pw(last+1,:);
    i = first;
    j = last;
    ii = 1;
    jj = last - off;
    remflag = 0;
    while(j-i>t)
        alfi = (u-U(i))/(U(i+ord+t)-U(i));
        alfj = (u-U(j-t))/(U(j+ord)-U(j-t));
        temp(ii,:) = (Pw(i,:)-(1.0-alfi)*temp(ii,:))/alfi;
        temp(jj,:) = (Pw(j,:)-alfj*temp(jj+1,:))/(1.0-alfj);
        i = i + 1;
        ii = ii + 1;
        j = j - 1;
        jj = jj - 1;
    end
    if(j-i<t)
        dist4D = norm(temp(ii,:)-temp(jj+1,:));
        if(dist4D<=TOL)
            remflag = 1;
        end
        
    else
        alfi = (u-U(i))/(U(i+ord+t)-U(i));
        dist4D = norm(Pw(i,:)-(alfi*temp(ii+t+1,:)+(1.0-alfi)*temp(ii,:)));
        if(dist4D<=TOL)
            remflag = 1;
        end
    end
    if(remflag==0)
        break
    else
        i = first;
        j = last;
        while(j-i>t)
            Pw(i,:) = temp(i-off,:);
            Pw(j,:) = temp(j-off,:);
            i = i + 1;
            j = j - 1;
        end
    end
    first = first - 1;
    last = last + 1;
end

if(t~=0) 
    for k=r+1:m
        U(k-t) = U(k);
    end
    j = fout;
    i = j;
    for k=1:t-1
        if(mod(k,2)==1) 
            i = i + 1;
        else
            j = j - 1;
        end
    end
    for k=i+1:n
        Pw(j,:) = Pw(k,:);
        j = j + 1;
    end
end
    
    
nurbsNew.U = U;
nurbsNew.Pw = Pw;
nurbsNew.iniParam = nurbs.iniParam;
nurbsNew.endParam = nurbs.endParam;
    
