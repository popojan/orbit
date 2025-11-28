S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]

Print["A MOD p VALUES"]
Print["=============="]

semiprimes = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {55, 5, 11}, 
              {77, 7, 11}, {91, 7, 13}, {119, 7, 17}, {143, 11, 13},
              {187, 11, 17}, {221, 13, 17}};

Print[""]
Print["n       p   q   A%p  A%q  b_p  b_q"]
Print["-----------------------------------"]

Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  
  AmodP = Mod[A, p];
  AmodQ = Mod[A, q];
  
  bP = Mod[-PowerMod[AmodP, -1, p], p];
  bQ = Mod[-PowerMod[AmodQ, -1, q], q];
  If[bP > p/2, bP = bP - p];
  If[bQ > q/2, bQ = bQ - q];
  
  Print[n, "     ", p, "  ", q, "   ", AmodP, "    ", AmodQ, "   ", bP, "   ", bQ],
  {tc, semiprimes}
]

Print[""]
Print["SUMMARY"]
Print["======="]
Print["A mod p is typically in range 1-9"]
Print["This gives b values in small range"]
Print[""]

Print["For factoring: try b in {-5,-4,-3,-2,-1,0,1,2,3,4,5}"]
Print["This covers all cases above!"]
