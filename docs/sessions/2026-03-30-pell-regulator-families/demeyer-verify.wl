pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]
nOK = 0; nFail = 0;
avals = {3,4,5,6,7,8,9,10,11,12};
Do[s = Ceiling[(aa-3)/2]; jvals = {1,2,3,5,7,9};
  Do[k0 = 2^s*j0; n = 4*k0^2 + 2^aa;
    z = k0^2/2^(aa-3) + 1;
    If[IntegerQ[z] && n > 1 && !IntegerQ[Sqrt[n]],
      sol = pslv[n]; xa = sol[[1]]; ya = sol[[2]];
      mFound = 0;
      Do[xc = ChebyshevT[m, z];
        yc = k0*ChebyshevU[m - 1, z]/2^(aa - 2);
        If[xc == xa && IntegerQ[yc] && yc == ya, mFound = m; Break[]],
      {m, 1, 64}];
      If[mFound > 0, nOK++,
        nFail++; Print["FAIL a=", aa, " k=", k0, " n=", n]];
      If[j0 <= 2 && mFound > 0,
        Print["a=", aa, " j=", j0, " k=", k0, " z=", z, " m=", mFound, " OK"]];
    ],
  {j0, jvals}],
{aa, avals}];
Print["Total: ", nOK, " OK, ", nFail, " fail"]
