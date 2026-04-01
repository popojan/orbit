(* Prime Interference — Algebraic Analysis v2 *)
(* CORRECTED: G(s,xi) = Li_s(w) - w, NOT Li_s(w) - 1 *)
(* Li_s(z) = PolyLog[s, z] (polylogarithm, NOT LogIntegral) *)

S[x_, y_] := (Cos[Pi y] - Cos[Pi Sqrt[y^2 + 4 x]])/2;
iStar[x_, y_] := (y + Sqrt[y^2 + 4 x])/2;

Print["============================================="];
Print[" Prime Interference v2 — Corrected Formula"];
Print["============================================="];

(* === 1. Verify S = Sin[Pi i*] Sin[Pi j*] === *)
Print["\n=== S = Sin[Pi i*] Sin[Pi j*]: ",
  S[x, y] - Sin[Pi iStar[x, y]] Sin[Pi (-y + Sqrt[y^2 + 4 x])/2] //
    FullSimplify[#, y^2 + 4 x > 0] &, " ==="];

(* === 2. S zeros for composite, nonzero for prime === *)
Print["\n=== S at divisor heights of n=30 ==="];
Do[Print["  d=", d, " y=", d - 30/d, " S=", S[30, d - 30/d] // FullSimplify],
  {d, Divisors[30]}];

Print["\n=== S interior for p=11 (all nonzero) ==="];
Do[Print["  y=", y, " S=", N[S[11, y], 6]], {y, 0, 9}];

(* === 3. f_n(t) double-zero detection === *)
Print["\n=== f_n(t) = Sin[Pi t] Sin[Pi n/t] ==="];
Print["Residue lim_{t->d} f_n(t)/Sin[Pi t] = (-1)^d Sin[Pi n/d]"];
Print["  = 0 iff d|n (2nd order zero)"];
Print["  != 0 iff d!|n (1st order zero)\n"];

Print["n=30, sample points:"];
Do[
  res = (-1)^d Sin[Pi 30/d] // FullSimplify;
  Print["  d=", StringPadRight[ToString[d], 3],
    If[Divisible[30, d], " d|30  res=0", " d!|30 res=" <> ToString[res]]],
  {d, {2, 3, 4, 5, 7, 10, 11, 15}}
];

(* === 4. CORRECTED Dirichlet series === *)
Print["\n============================================="];
Print[" Intersection Dirichlet Series (CORRECTED)"];
Print["============================================="];
Print[""];
Print["Key: G(s,xi) = Li_s(w) - w  where w = e^{2 Pi I xi}"];
Print["     = Sum_{n>=2} w^n / n^s  (first term REMOVED)"];
Print[""];
Print["I(s,xi) = G(s,xi) * conj(G(s,xi)) = |G|^2"];
Print["        = |PolyLog[s, w] - w|^2"];
Print[""];
Print["NOT (PolyLog-1)*(conj-1) -- that was the v1 bug!"];

w[xi_] := Exp[2 Pi I xi];

(* Corrected formula *)
gDS[s_, xi_] := PolyLog[s, w[xi]] - w[xi];
iDScorrected[s_, xi_] := gDS[s, xi] * gDS[s, -xi];

(* Old (wrong) formula for comparison *)
iDSwrong[s_, xi_] := (PolyLog[s, w[xi]] - 1)(PolyLog[s, w[-xi]] - 1);

(* Direct sum *)
hHat[nn_, xi_] := Total[
  If[1 < # < nn, Exp[2 Pi I xi (# - nn/#)], 0] & /@ Divisors[nn]
];

Print["\n--- Verification at xi=0 (both formulas agree here) ---"];
Do[
  corr = N[iDScorrected[s, 0], 12];
  ref = N[(Zeta[s] - 1)^2, 12];
  Print["  s=", s, ": |G|^2=", corr, "  (z-1)^2=", ref,
    "  err=", ScientificForm[Abs[corr - ref], 2]],
  {s, 2, 4}
];

Print["\n--- Verification at xi=1/4 (v1 was wrong here!) ---"];
Do[
  corrVal = N[iDScorrected[s, 1/4], 12];
  wrongVal = N[iDSwrong[s, 1/4], 12];
  direct = N[Sum[hHat[nn, 1/4]/nn^s, {nn, 2, 1000}], 12];
  Print["  s=", s, ":"];
  Print["    CORRECT |G|^2   = ", corrVal];
  Print["    Direct (N=1000) = ", direct];
  Print["    Diff (tail)     = ", ScientificForm[Abs[corrVal - direct], 3]];
  Print["    WRONG (v1)      = ", wrongVal, "  <-- off by factor ",
    NumberForm[Re[wrongVal/corrVal], {4, 1}]],
  {s, {2, 3}}
];

Print["\n--- Verification at xi=1/3 ---"];
Do[
  corrVal = N[iDScorrected[s, 1/3], 12];
  direct = N[Sum[hHat[nn, 1/3]/nn^s, {nn, 2, 1000}], 12];
  Print["  s=", s, ": |G|^2=", corrVal,
    "  direct=", direct,
    "  diff=", ScientificForm[Abs[corrVal - direct], 3]],
  {s, {2, 3}}
];

Print["\n--- Verification at xi=1/2 ---"];
dirichletEta[s_] := (1 - 2^(1 - s)) Zeta[s];
Print["G(s,1/2) = Li_s(-1) - (-1) = 1 - eta(s)"];
Print["I(s,1/2) = (1 - eta(s))^2  [NOT (1+eta)^2 as v1 claimed!]"];
Do[
  corrVal = N[iDScorrected[s, 1/2], 12];
  ref = N[(1 - dirichletEta[s])^2, 12];
  direct = N[Sum[hHat[nn, 1/2]/nn^s, {nn, 2, 1000}], 12];
  Print["  s=", s, ": |G|^2=", corrVal,
    "  (1-eta)^2=", ref,
    "  direct=", direct],
  {s, 2, 4}
];

(* === 5. Special values summary === *)
Print["\n--- Special values ---"];
Print["xi=0:   I = (zeta(s) - 1)^2"];
Print["xi=1/2: I = (1 - eta(s))^2 = (2^{1-s} zeta(s))^2"];
Print["          Wait... 1-eta(s) = 1-(1-2^{1-s})zeta = 1-zeta+2^{1-s}*zeta"];
Print["          For s=2: ", N[1 - dirichletEta[2], 8]];
Print["          2^{-1}*zeta(2) = ", N[Zeta[2]/2, 8]];
Print["          1-eta != 2^{1-s}*zeta in general"];

(* === 6. MAIN: Phi(p) table (unchanged from v1) === *)
Print["\n============================================="];
Print[" Interference Product Phi(p) for Primes"];
Print["============================================="];

logPhi[p_] := Sum[Log[Abs[N[S[p, y], 25]]], {y, 1, p - 2}];

minFracPart[p_] := Min @ Table[
  With[{f = FractionalPart[N[iStar[p, y], 20]]},
    Min[f, 1 - f]],
  {y, 0, p - 2}
];

cfPeriod[nn_] := Length[ContinuedFraction[Sqrt[nn]][[2]]];
baseline[p_] := -2.0 (p - 2) Log[2.0];

Print[StringJoin[{StringPadRight["p", 5], StringPadRight["logPhi", 12],
  StringPadRight["baseline", 12], StringPadRight["dev/term", 10],
  StringPadRight["minFrac", 10], "cfPer"}]];
Print[StringJoin @ Table["-", 59]];

results = {};
Do[
  lp = logPhi[p]; bl = baseline[p]; dev = (lp - bl)/(p - 2);
  mf = minFracPart[p]; cf = cfPeriod[p];
  AppendTo[results, {p, lp, dev, mf, cf}];
  Print[StringPadRight[ToString[p], 5],
    StringPadRight[ToString @ NumberForm[lp, {8, 2}], 12],
    StringPadRight[ToString @ NumberForm[bl, {8, 2}], 12],
    StringPadRight[ToString @ NumberForm[dev, {6, 4}], 10],
    StringPadRight[ToString @ NumberForm[mf, {5, 4}], 10],
    cf],
  {p, Select[Range[3, 100], PrimeQ]}
];

(* === 7. Correlation analysis === *)
Print["\n=== Correlations (p > 10) ==="];
big = Select[results, #[[1]] > 10 &];
devs = big[[All, 3]];
logMFs = Log /@ big[[All, 4]];
cfs = N /@ big[[All, 5]];

Print["corr(dev/term, log minFrac) = ", NumberForm[Correlation[devs, logMFs], {4, 3}]];
Print["corr(log minFrac, cfPeriod) = ", NumberForm[Correlation[logMFs, cfs], {4, 3}]];
Print["corr(dev/term, cfPeriod)    = ", NumberForm[Correlation[devs, cfs], {4, 3}]];

(* === 8. Extremal terms === *)
Print["\n=== Worst (smallest) |S(p,y)| per prime ==="];
Print["Note: worst y is always p-2 (near boundary, i*~p-1+1/p)\n"];
Do[
  p = r[[1]]; best = {Infinity, 0, 0};
  Do[
    v = Abs[N[S[p, y], 20]];
    If[v < best[[1]], best = {v, y, N[iStar[p, y], 8]}],
    {y, 1, p - 2}
  ];
  (* Also find worst EXCLUDING boundary zone y > p-4 *)
  bestInner = {Infinity, 0, 0};
  Do[
    v = Abs[N[S[p, y], 20]];
    If[v < bestInner[[1]], bestInner = {v, y, N[iStar[p, y], 8]}],
    {y, 1, Max[1, p - 5]}
  ];
  Print["  p=", StringPadRight[ToString[p], 4],
    " boundary: y=", best[[2]], " |S|=", ScientificForm[best[[1]], 3],
    "   inner: y=", bestInner[[2]],
    " |S|=", ScientificForm[bestInner[[1]], 3],
    " i*=", NumberForm[bestInner[[3]], {8, 4}]],
  {r, Select[results, #[[1]] > 20 &]}
];
