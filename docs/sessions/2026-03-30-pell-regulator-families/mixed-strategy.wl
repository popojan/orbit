pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["=== THE MIXED STRATEGY: consume odd primes, then Chebyshev ===\n"];

Print["For n = a₀² + r with r = (odd part) * 2^b:"];
Print["  Step 1: require (odd part)^{ceil(...)} | a₀  (consumes odd primes)"];
Print["  Step 2: Chebyshev tower for the remaining 2-part\n"];

Print["=== TEST: r = 12 = 3 * 4.  a₀ = 3k ==="];
Print["  n = 9k² + 12.  z = (3k²+2)/2.  Denom = 2 for k odd.\n"];

Do[
  k0 = k; a0 = 3k0; n = a0^2 + 12; z = (3k0^2+2)/2;
  {xa, ya} = pslv[n];
  If[OddQ[k0],
    xc = ChebyshevT[3, z];
    yc = k0 * ChebyshevU[2, z] / 2;
    Print["  k=",k0," n=",n," z=",z," T₃(z)=",xc,
      " y=",yc," match: ",xa==xc && ya==yc],
    xc = z; yc = k0/2;
    Print["  k=",k0," n=",n," z=",z," T₁(z)=",xc,
      " y=",yc," match: ",xa==xc && ya==yc]],
{k, 1, 10}];

Print["\n=== TEST: r = 24 = 3 * 8.  a₀ = 3k ==="];
Print["  n = 9k² + 24.  z = (3k²+4)/4.\n"];
Do[
  k0 = k; a0 = 3k0; n = a0^2 + 24; z = (2*a0^2+24)/24;
  {xa, ya} = pslv[n];
  If[IntegerQ[z],
    Print["  k=",k0," n=",n," z=",z," (integer) → try Chebyshev"],
    If[Denominator[z]==2,
      xc = ChebyshevT[3, z]; yc = a0*ChebyshevU[2,z]/12;
      Print["  k=",k0," n=",n," z=",z," (half-int) T₃=",xc,
        " y=",yc," int_y:",IntegerQ[yc]," match:",xa==xc&&IntegerQ[yc]&&ya==yc],
      Print["  k=",k0," n=",n," z=",z," denom=",Denominator[z]," SKIP"]]],
{k, 1, 10}];

Print["\n=== GENERAL: r = p * 2^b, a₀ = p*k ===\n"];
Print["n = p²k² + p*2^b = p(pk² + 2^b)"];
Print["z = (2p²k² + p*2^b)/(p*2^b) = (2pk² + 2^b)/2^b = pk²/2^{b-1} + 1\n"];
Print["Denominator of z: 2^{max(0, b-1-2v₂(k))}\n"];

Do[
  p0 = pp; b0 = bb;
  r = p0 * 2^b0;
  Print["--- r = ",p0," * 2^",b0," = ",r," ---"];
  nOK = 0; nTest = 0;
  Do[
    a0 = p0*k0; n = a0^2 + r;
    If[!IntegerQ[Sqrt[n]],
      z = (2*a0^2+r)/r;
      denom = Denominator[z];
      If[denom <= 2,
        nTest++;
        {xa, ya} = pslv[n];
        found = False;
        Do[
          xc = ChebyshevT[m, z];
          yc = a0*ChebyshevU[m-1, z]/(r/2);
          If[IntegerQ[xc]&&IntegerQ[yc]&&xc==xa&&yc==ya,
            found=True; Break[]],
        {m, 1, 20}];
        If[found, nOK++];
      ]],
  {k0, 1, 20}];
  Print["  ",nOK,"/",nTest," matched (a₀=",p0,"k, k=1..20, denom(z)≤2)"];
, {pp, {3, 5, 7}}, {bb, {1, 2, 3}}];

Print["\n=== THE BIG PICTURE ===\n"];
Print["For ANY r, write r = 2^b * prod(p_i^{e_i})."];
Print["Set a₀ = prod(p_i^{ceil(e_i/2)}) * k."];
Print["Then z = (2a₀²+r)/r has denominator dividing 2^{b-1}/gcd(..)."];
Print["If this denominator is ≤ 2: Chebyshev tower works!\n"];

Print["Condition on k:  v₂(k) ≥ ceil((b-2)/2)  (same as before)\n"];

Print["COVERAGE: for r = p₁^{e₁}·...·pₘ^{eₘ}·2^b,"];
Print["  we need a₀ divisible by prod(p_i^{ceil(e_i/2)}) * 2^{ceil((b-2)/2)}"];
Print["  This covers fraction 1/(prod * 2^{...}) of all a₀ values."];
