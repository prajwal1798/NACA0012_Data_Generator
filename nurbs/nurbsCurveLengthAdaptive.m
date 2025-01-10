function lengthCurve = nurbsCurveLengthAdaptive(aNurbs, u1, u2, gaussRef, lengthTOL)

TOLzero = 1e-12;

kMax = length(gaussRef);
length1 = nurbsCurveLength(aNurbs, u1, u2, gaussRef(1).z01, gaussRef(1).w01);
for k=2:kMax
	length2 = nurbsCurveLength(aNurbs, u1 , u2, gaussRef(k).z01, gaussRef(k).w01);
    if abs(length1)<TOLzero && abs(length2)<TOLzero
        lengthCurve = 0;
        return;
    end
    
	errInt = abs((length2 - length1)/length2);
	if(errInt<lengthTOL) 
		lengthCurve = length2;
		break
	end 
	length1 = length2;
end 

if(k==kMax+1) 
	disp('WARNING->nurbsCurveLengthAdaptive: TOL has not been achieved')
	errInt
	lengthCurve = length2;
end