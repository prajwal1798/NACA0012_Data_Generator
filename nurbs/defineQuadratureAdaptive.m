function quadRef = defineQuadratureAdaptive()

kMax = 12;
quadRef(kMax).z01 = [];
quadRef(kMax).w01 = [];

for k=1:12
    [quadRef(k).z01,quadRef(k).w01]=gaussLegendre(2^k,0,1);
end
    
    