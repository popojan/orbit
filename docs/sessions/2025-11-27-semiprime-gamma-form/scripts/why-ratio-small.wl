(* Why is d00/d10 mod p small? *)

S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["WHY IS THE RATIO d00/d10 SMALL MOD p?"]
Print["======================================"]
Print[""]

Print["We know S00 = n^2 * S10"]
Print["And B = n (denominator of S10)"]
Print[""]

Print["Let S10 = A/n, then:"]
Print["  1 - S10 = (n - A)/n"]
Print["  f10 = -n/(n - A)"]
Print["  num10 = n, den10 = A - n"]
Print[""]

Print["  1 - n^2*S10 = 1 - n*A = (1 - n*A)"]
Print["  f00 = -1/(1 - n*A)"]
Print["  Since 1 - n*A is huge negative, f00 = 1/(n*A - 1)")
Print["  num00 = 1, den00 = n*A - 1"]
Print[""]

Print["Verification:"]
Do[
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  n00 = Numerator[f00[n]];
  n10 = Numerator[f10[n]];
  
  Print["n=", n, ":"];
  Print["  A=", A, ", B=", B];
  Print["  f00 = ", n00, "/", d00];
  Print["  f10 = ", n10, "/", d10];
  Print["  n*A - 1 = ", n*A - 1, ", d00 = ", d00, ", match: ", n*A - 1 == d00];
  Print["  A - n = ", A - n, ", d10 = ", d10, ", match: ", A - n == d10];
  Print[""],
  {n, {3, 5, 7}}
]

Print["THE RATIO d00/d10:"]
Print["=================="]
Print[""]

Print["d00 = n*A - 1"]
Print["d10 = A - n"]
Print[""]
Print["d00/d10 = (n*A - 1)/(A - n)"]
Print[""]

Print["Mod p (where p | n, so n = 0 mod p):"]
Print["  d00 mod p = (0*A - 1) mod p = -1 mod p = p - 1"]
Print["  d10 mod p = (A - 0) mod p = A mod p"]
Print[""]
Print["  d00/d10 mod p = (p-1)/A mod p = -1/A mod p = -A^(-1) mod p"]
Print[""]

Print["So b = d00 * d10^(-1) = (p-1) * A^(-1) = -A^(-1) mod p"]
Print[""]

Print["WHAT IS A MOD p?"]
Print["================"]
Print[""]

Print["A = numerator of S10 = Sum of products...")
Print[""]

semiprimes = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {77, 7, 11}, {143, 11, 13}};

Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  
  Print["n=", n, " = ", p, "*", q, ":"];
  Print["  A mod ", p, " = ", Mod[A, p]];
  Print["  A mod ", q, " = ", Mod[A, q]];
  Print["  -A^(-1) mod ", p, " = ", Mod[-PowerMod[Mod[A, p], -1, p], p]];
  Print["  -A^(-1) mod ", q, " = ", Mod[-PowerMod[Mod[A, q], -1, q], q]];
  
  (* Shift to range -(p-1)/2 to (p-1)/2 *)
  bP = Mod[-PowerMod[Mod[A, p], -1, p], p];
  If[bP > p/2, bP = bP - p];
  bQ = Mod[-PowerMod[Mod[A, q], -1, q], q];
  If[bQ > q/2, bQ = bQ - q];
  Print["  Optimal b for ", p, ": ", bP];
  Print["  Optimal b for ", q, ": ", bQ];
  Print[""],
  {tc, semiprimes}
]

Print["KEY: A mod p depends on the Wilson-type structure!"]
Print[""]

Print["Since A = sum of products involving n^2 - j^2,"]
Print["and n = 0 mod p, we have n^2 - j^2 = -j^2 mod p"]
Print[""]

Print["The product terms mod p follow a pattern related to factorials!"]
