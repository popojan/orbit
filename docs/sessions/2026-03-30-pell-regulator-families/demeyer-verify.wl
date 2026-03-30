pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

nOK = 0; nFail = 0;
Do[
  a = aa; s = Ceiling[(a-3)/2];
  Do[{
    k0 = 2^s * j0, n = 4*k0^2 + 2^a,
    If[!IntegerQ[Sqrt[n]],
      Module[{z, xa, ya, xc, yc, matched = False},
        z = k0^2/2^(a-3) + 1;
        If[IntegerQ[z],
          {xa, ya} = pslv[n];
          Do[
            xc = ChebyshevT[m, z];
            yc = k0 * ChebyshevU[m-1, z] / 2^(a-2);
            If[xc == xa && IntegerQ[yc] && yc == ya,
              If[j0 <= 2,
                Print["  a=",aa," j=",j0," k=",k0," z=",z," m=",m,
                  ": T/U match ✓"]];
              nOK++; matched = True; Break[]];
          , {m, 1, 64}];
          If[!matched, nFail++; Print["  FAIL a=",aa," k=",k0]];
        ];
      ];
    ];
  }, {j0, {1,2,3,5,7,9,11}};
, {aa, 3, 12}];

Print["\nResults: ", nOK, " verified, ", nFail, " failures\n"];

Print["THEOREM: For n = 4k^2 + 2^a, k divisible by 2^ceil((a-3)/2):"];
Print["  z = k^2/2^(a-3) + 1"];
Print["  x = T_m(z),  y = k*U_{m-1}(z)/2^(a-2)"];
Print["  where m is smallest making y integer."];
Print["  PROOF: Chebyshev identity T_m^2-(z^2-1)*U_{m-1}^2=1"];
Print["         + factorization z^2-1 = n*k^2/2^(2a-4).  QED"];
