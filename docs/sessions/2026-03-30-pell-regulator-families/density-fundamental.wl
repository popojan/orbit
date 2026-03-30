Print["=== DENSITY of directly solvable n (c=1, delta<=2) ===\n"];

Do[
  Nmax = nn;
  solvable = 0;
  Do[
    If[!IntegerQ[Sqrt[n0]],
      a0 = Floor[Sqrt[n0]]; r = n0 - a0^2;
      If[r > 0 && Denominator[(2a0^2 + r)/r] <= 2,
        solvable++]],
  {n0, 2, Nmax}];
  total = Nmax - 1 - Floor[Sqrt[Nmax]];
  Print["  N=", StringPadRight[ToString[Nmax], 10],
    " solvable=", StringPadRight[ToString[solvable], 7],
    " total=", StringPadRight[ToString[total], 7],
    " fraction=", Round[100. solvable/total, 0.01], "%",
    " ratio=", Round[N[solvable/Sqrt[Nmax]], 0.01]],
{nn, {100, 1000, 10000, 100000, 1000000}}];

Print["\n=== ANALYSIS ===\n"];

(* The solvable n are those where delta <= 2.
   n = a0^2 + r with delta = denom((2a0^2+r)/r) <= 2.
   This means r | 2a0^2 or r | a0^2 (up to factor 2).
   
   For each a0, the values of r giving delta <= 2 are
   the divisors of 2a0^2 (and also those where denom = 2).
   
   Number of such r for a given a0: roughly tau(2a0^2) ~ (log a0)^c
   
   And n ranges from a0^2+1 to (a0+1)^2-1 = a0^2+2a0,
   so there are 2a0 possible n near a0^2.
   
   Fraction near a0: tau(2a0^2) / (2a0) ~ (log a0)^c / a0 -> 0 *)

Print["Divisor count analysis:"];
Print["  For each a0, solvable r are divisors of 2a0^2 (with delta=1)"];
Print["  plus r with delta=2.\n"];

Do[
  a0 = aa;
  count = 0;
  Do[
    n0 = a0^2 + r;
    If[!IntegerQ[Sqrt[n0]] && Denominator[(2a0^2+r)/r] <= 2,
      count++],
  {r, 1, 2*a0}];
  nDiv = DivisorSigma[0, 2a0^2];
  Print["  a0=", StringPadRight[ToString[a0], 6],
    " solvable r: ", StringPadRight[ToString[count], 5],
    " out of ", 2a0,
    "  tau(2a0^2)=", nDiv,
    "  fraction=", Round[100. count/(2a0), 0.1], "%"],
{aa, {10, 100, 1000, 10000}}];

Print["\n=== SCALING: what does c>1 add? ===\n"];

Print["For each c, the density contribution is:"];
Print["  c=1: n near integer squares a0^2 (density ~ 1/sqrt(N))"];
Print["  c=2: n near rational squares (a0/2)^2 (additional density ~ 1/sqrt(N))"];
Print["  c=k: n near (a0/k)^2 (each adds ~ 1/sqrt(N))\n"];

Print["Combined with c <= C: sum_{c=1}^{C} ~ C/sqrt(N) ... still -> 0!\n"];

Print["UNLESS C grows with N. If C ~ N^alpha:\n"];
Do[
  Nmax = nn;
  Do[
    cmax = Round[Nmax^alpha];
    (* Estimate: each c contributes ~ sqrt(N)/c solvable n *)
    (* Total ~ sqrt(N) * sum_{c=1}^{C} 1/c ~ sqrt(N) * log(C) *)
    est = N[Sqrt[Nmax] * Log[cmax]];
    total = Nmax - Floor[Sqrt[Nmax]];
    frac = est/total;
    Print["  N=", Nmax, " alpha=", alpha,
      " C=", cmax,
      " est_count~", Round[est],
      " fraction~", Round[100 frac, 0.1], "%"],
  {alpha, {0, 0.1, 0.25, 0.5}}],
{nn, {10000, 1000000}}];
