(* Prime Interference — Algebraic Analysis *)
(* Li_s(z) = PolyLog[s, z] (polylogarithm, NOT LogIntegral!) *)
(* LogIntegral[x] = li(x) = integral form, single parameter *)

(* === Core functions from shader geometry === *)

(* Closed-form shader intensity *)
S[x_, y_] := (Cos[Pi y] - Cos[Pi Sqrt[y^2 + 4 x]])/2;

(* Continuous factorization indices *)
iStar[x_, y_] := (y + Sqrt[y^2 + 4 x])/2;
jStar[x_, y_] := (-y + Sqrt[y^2 + 4 x])/2;

Print["============================================="];
Print[" Prime Interference: Algebraic Analysis"];
Print["============================================="];

(* --- 1. Verify S = Sin[Pi i*] Sin[Pi j*] symbolically --- *)
Print["\n=== Identity: S = Sin[Pi i*] Sin[Pi j*] ==="];
diff = S[x, y] - Sin[Pi iStar[x, y]] Sin[Pi jStar[x, y]] //
  FullSimplify[#, y^2 + 4 x > 0] &;
Print["S - Sin*Sin = ", diff];

(* --- 2. Verify S = 0 at factorization heights --- *)
Print["\n=== S at factorization heights (n=30) ==="];
n0 = 30;
Do[
  h = d - n0/d;
  val = S[n0, h] // FullSimplify;
  Print["  d=", StringPadRight[ToString[d], 3],
    " n/d=", StringPadRight[ToString[n0/d], 3],
    " y=", StringPadRight[ToString[h], 4], " S=", val],
  {d, Divisors[n0]}
];

Print["\n--- S at interior of p=11 (prime) ---"];
Do[
  val = N[S[11, y], 8];
  Print["  y=", y, "  S=", val, If[Abs[val] < 10^-10, " *** ZERO", ""]],
  {y, 0, 9}
];

(* --- 3. Double-zero detection in f_n(t) --- *)
Print["\n=== f_n(t) = Sin[Pi t] Sin[Pi n/t]: zero orders ==="];
fn[nn_, t_] := Sin[Pi t] Sin[Pi nn/t];

Print["Residue after removing Sin[Pi t]: lim_{t->d} f_n(t)/Sin[Pi t] = (-1)^d Sin[Pi n/d]"];
Print["This is 0 iff d|n (double zero), nonzero iff d∤n (simple zero)\n"];

Print["n=30:"];
Do[
  res = (-1)^d Sin[Pi 30/d] // FullSimplify;
  Print["  d=", StringPadRight[ToString[d], 3],
    " d|30=", StringPadRight[ToString[Divisible[30, d]], 6],
    " residue=", res],
  {d, 2, 29}
];

(* --- 4. Dirichlet series via PolyLog --- *)
Print["\n=== Intersection Dirichlet series ==="];
Print["I(s, xi) = (PolyLog[s, e^{2 Pi I xi}] - 1)(PolyLog[s, e^{-2 Pi I xi}] - 1)"];
Print["Encodes height distribution of ALL interior intersections"];
Print["Primes contribute NOTHING (h-hat(p,xi) = 0)\n"];

iDS[s_, xi_] :=
  (PolyLog[s, Exp[2 Pi I xi]] - 1) *
  (PolyLog[s, Exp[-2 Pi I xi]] - 1);

(* xi=0: should give (Zeta[s]-1)^2 *)
Print["--- I(s, 0) vs (Zeta[s]-1)^2 ---"];
Do[
  val = N[iDS[s, 0], 15];
  ref = N[(Zeta[s] - 1)^2, 15];
  Print["  s=", s, ": I=", val, "  (z-1)^2=", ref,
    "  err=", ScientificForm[Abs[val - ref], 2]],
  {s, 2, 5}
];

(* xi=1/2: should give (1 + eta(s))^2 *)
Print["\n--- I(s, 1/2) vs (1 + eta(s))^2 ---"];
dirichletEta[s_] := (1 - 2^(1 - s)) Zeta[s];
Do[
  val = N[iDS[s, 1/2], 15];
  ref = N[(1 + dirichletEta[s])^2, 15];
  Print["  s=", s, ": I=", val, "  (1+eta)^2=", ref,
    "  err=", ScientificForm[Abs[val - ref], 2]],
  {s, 2, 5}
];

(* Direct coefficient verification *)
Print["\n--- Direct coefficient check (genuine numerical test) ---"];
hHat[nn_, xi_] := Total[
  If[1 < # < nn, Exp[2 Pi I xi (# - nn/#)], 0] & /@ Divisors[nn]
];

Print["s=3, xi=1/4:"];
direct = N[Sum[hHat[nn, 1/4]/nn^3, {nn, 2, 500}], 10];
formula = N[iDS[3, 1/4], 10];
Print["  Partial sum (N=500): ", direct];
Print["  PolyLog formula:     ", formula];
Print["  Difference (tail):   ", ScientificForm[Abs[direct - formula], 3]];

Print["\ns=2, xi=1/3:"];
direct2 = N[Sum[hHat[nn, 1/3]/nn^2, {nn, 2, 500}], 10];
formula2 = N[iDS[2, 1/3], 10];
Print["  Partial sum (N=500): ", direct2];
Print["  PolyLog formula:     ", formula2];
Print["  Difference (tail):   ", ScientificForm[Abs[direct2 - formula2], 3]];

(* --- 5. THE MAIN EVENT: log|Phi(p)| --- *)
Print["\n============================================="];
Print[" MAIN: Interference product Phi(p)"];
Print["============================================="];
Print["Phi(n) = Prod_{y=1}^{n-2} S(n, y)"];
Print["  Composites: Phi = 0 (interior intersection exists)"];
Print["  Primes:     Phi != 0 (empty interior)"];
Print["Baseline per term: E[log|sin(pi alpha)|] = -log 2 ≈ -0.693\n"];

logPhi[p_] := Sum[Log[Abs[N[S[p, y], 25]]], {y, 1, p - 2}];

(* Verify composites *)
Print["--- Composites: min|S(n,y)| over interior ---"];
Do[
  minVal = Min @ Table[Abs[N[S[nn, y], 20]], {y, 1, nn - 2}];
  Print["  n=", StringPadRight[ToString[nn], 4],
    " min|S|=", ScientificForm[minVal, 3],
    If[minVal < 10^-15, "  (= 0 at factorization)", ""]],
  {nn, {4, 6, 9, 10, 12, 15, 24, 35}}
];

(* Distance of i* to nearest integer *)
minFracPart[p_] := Min @ Table[
  With[{f = FractionalPart[N[iStar[p, y], 20]]},
    Min[f, 1 - f]],
  {y, 0, p - 2}
];

(* CF period of sqrt(p) *)
cfPeriod[nn_] := Length[ContinuedFraction[Sqrt[nn]][[2]]];

baseline[p_] := -2.0 (p - 2) Log[2.0];

(* Compute for all primes up to 100 *)
Print["\n--- Primes: logPhi, deviation, minFrac, CF period ---"];
header = StringJoin[{
  StringPadRight["p", 5],
  StringPadRight["logPhi", 12],
  StringPadRight["baseline", 12],
  StringPadRight["dev/term", 10],
  StringPadRight["minFrac", 10],
  "cfPer"
}];
Print[header];
Print[StringJoin @ Table["-", StringLength[header] + 2]];

results = {};
Do[
  lp = logPhi[p];
  bl = baseline[p];
  dev = (lp - bl)/(p - 2);
  mf = minFracPart[p];
  cf = cfPeriod[p];
  AppendTo[results, {p, lp, dev, mf, cf}];
  Print[
    StringPadRight[ToString[p], 5],
    StringPadRight[ToString @ NumberForm[lp, {8, 2}], 12],
    StringPadRight[ToString @ NumberForm[bl, {8, 2}], 12],
    StringPadRight[ToString @ NumberForm[dev, {6, 4}], 10],
    StringPadRight[ToString @ NumberForm[mf, {5, 4}], 10],
    cf
  ],
  {p, Select[Range[3, 100], PrimeQ]}
];

(* --- 6. Analysis --- *)
Print["\n============================================="];
Print[" Analysis"];
Print["============================================="];

big = Select[results, #[[1]] > 10 &];
devs = big[[All, 3]];
logMFs = Log /@ big[[All, 4]];
cfs = N /@ big[[All, 5]];

Print["Statistics (p > 10):"];
Print["  Mean dev/term:  ", NumberForm[Mean[devs], {6, 4}]];
Print["  StdDev:         ", NumberForm[StandardDeviation[devs], {6, 4}]];

Print["\nScaling: dev * p"];
Do[
  Print["  p=", StringPadRight[ToString[r[[1]]], 4],
    " dev*p=", NumberForm[r[[3]] * r[[1]], {7, 3}]],
  {r, big}
];

Print["\nCorrelations:"];
Print["  corr(dev/term, log minFrac) = ",
  NumberForm[Correlation[devs, logMFs], {4, 3}]];
Print["  corr(log minFrac, cfPeriod)  = ",
  NumberForm[Correlation[logMFs, cfs], {4, 3}]];
Print["  corr(dev/term, cfPeriod)     = ",
  NumberForm[Correlation[devs, cfs], {4, 3}]];

(* --- 7. Extremal terms: which y gives smallest |S(p,y)|? --- *)
Print["\n--- Extremal terms: y giving min|S(p,y)| ---"];
Do[
  p = r[[1]];
  {minVal, minY} = {Infinity, 0};
  Do[
    v = Abs[N[S[p, y], 20]];
    If[v < minVal, minVal = v; minY = y],
    {y, 1, p - 2}
  ];
  nearestI = N[iStar[p, minY], 10];
  nearestInt = Round[nearestI];
  Print["  p=", StringPadRight[ToString[p], 4],
    " worst y=", StringPadRight[ToString[minY], 4],
    " |S|=", ScientificForm[minVal, 3],
    " i*=", NumberForm[nearestI, {8, 4}],
    " nearest=", nearestInt],
  {r, Select[results, #[[1]] > 10 &]}
];
