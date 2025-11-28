(* Ratio analysis - ASCII clean *)

S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["VERIFICATION OF FORMULAS"]
Print["========================"]
Print[""]

Do[
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  
  (* Test: d00 = n*A - 1, d10 = A - n *)
  Print["n=", n, ": B=", B, "=n? ", B == n];
  Print["       d00=", d00, ", n*A-1=", n*A - 1, ", match=", d00 == n*A - 1];
  Print["       d10=", d10, ", A-n=", A - n, ", match=", d10 == A - n];
  Print[""],
  {n, {3, 5, 7}}
]

Print["FORMULA: b = -1/A (mod p)"]
Print["=========================="]
Print[""]

semiprimes = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {55, 5, 11}, {77, 7, 11}, {143, 11, 13}};

Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  
  (* b = -1/A mod p *)
  AmodP = Mod[A, p];
  AmodQ = Mod[A, q];
  
  bP = If[GCD[AmodP, p] == 1, Mod[-PowerMod[AmodP, -1, p], p], 0];
  bQ = If[GCD[AmodQ, q] == 1, Mod[-PowerMod[AmodQ, -1, q], q], 0];
  
  If[bP > p/2, bP = bP - p];
  If[bQ > q/2, bQ = bQ - q];
  
  Print["n=", n, " (", p, "*", q, "):"];
  Print["  A mod ", p, " = ", AmodP, " -> b = ", bP];
  Print["  A mod ", q, " = ", AmodQ, " -> b = ", bQ],
  {tc, semiprimes}
]
Print[""]

Print["WHAT IS A MOD p?"]
Print["================="]
Print[""]

Print["A = n * S10 = Sum[n * Product[n^2-j^2]/(2i+1)]"]
Print[""]
Print["Mod p (n = 0 mod p):"]
Print["  n^2 - j^2 = -j^2 (mod p)"]
Print["  Product = (-1)^i * (1*2*...*i)^2 = (-1)^i * (i!)^2 (mod p)"]
Print[""]

Print["So each term T[i] mod p = (-1)^i * (i!)^2 / (2i+1) (mod p)")
Print[""]

Print["Checking pattern for n=77 (p=7, q=11):"]
n = 77;
p = 7;
q = 11;

Print["Terms mod p=7:"]
Do[
  term = Product[n^2 - j^2, {j, 1, i}]/(2 i + 1);
  termNum = Numerator[term];
  termDen = Denominator[term];
  
  (* (-1)^i * (i!)^2 *)
  expected = (-1)^i * (i!)^2;
  
  Print["  i=", i, ": term*n = ", Mod[termNum * n / termDen, p], 
    ", (-1)^i*(i!)^2 = ", Mod[expected, p]],
  {i, 0, 5}
]
Print[""]

Print["ACCUMULATED SUM A mod p:"]
Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  
  Print["n=", n, ": A mod ", p, " = ", Mod[A, p],
    ", A mod ", q, " = ", Mod[A, q]],
  {tc, semiprimes}
]
