<< Orbit`

(* Compute more terms and use Richardson extrapolation *)
(* Also try to find recurrences *)

Print["=== k=3: more terms ==="];
vals3 = Table[
  BeattyBallotCount[1/3, {n, n}],
  {n, 1, 50}
];
Print["Computed 50 terms."];
Print[""];

(* a(n) ~ C * 4^n / sqrt(pi*n) means *)
(* C = lim a(n) * sqrt(pi*n) / 4^n *)
(* Richardson: estimate C(n) and extrapolate *)

cn3 = Table[{n, N[vals3[[n]] Sqrt[Pi n] / 4^n, 30]}, {n, 30, 50}];
Print["k=3 estimates C(n):"];
Do[Print["  n=", c[[1]], ": ", c[[2]]], {c, cn3}];

Print[""];
(* Richardson extrapolation: C(n) ~ C + a/n + b/n^2 + ... *)
(* Use last 3 points for 2-term Richardson *)
{n1, c1} = cn3[[-3]];
{n2, c2} = cn3[[-2]];
{n3, c3} = cn3[[-1]];

rich1 = (n2 c2 - n1 c1)/(n2 - n1);
rich2 = (n3 c3 - n2 c2)/(n3 - n2);
rich3 = (n3 rich2 - n2 rich1)/(n3 - n2);
Print["Richardson extrapolation k=3: ", rich3];
Print[""];

Print["=== Same for k=2 (should give 1/phi^2) ==="];
vals2 = Table[BeattyBallotCount[1/2, {n, n}], {n, 1, 50}];
cn2 = Table[{n, N[vals2[[n]] Sqrt[Pi n] / 4^n, 30]}, {n, 45, 50}];
Do[Print["  n=", c[[1]], ": ", c[[2]]], {c, cn2}];

{n1, c1} = cn2[[-3]];
{n2, c2} = cn2[[-2]];
{n3, c3} = cn2[[-1]];
rich1 = (n2 c2 - n1 c1)/(n2 - n1);
rich2 = (n3 c3 - n2 c2)/(n3 - n2);
rich3 = (n3 rich2 - n2 rich1)/(n3 - n2);
Print["Richardson k=2: ", rich3];
Print["1/phi^2 = ", N[1/GoldenRatio^2, 30]];

Print[""];
Print["=== Try RootApproximant on Richardson values ==="];

Do[
  vals = Table[BeattyBallotCount[1/k, {n, n}], {n, 1, 50}];
  cn = Table[N[vals[[n]] Sqrt[Pi n] / 4^n, 30], {n, 40, 50}];
  (* simple Richardson *)
  cEst = (50 cn[[-1]] - 49 cn[[-2]]);
  approx = RootApproximant[cEst, 6];
  minPoly = MinimalPolynomial[approx, x];
  Print["k=", k, ": C_Richardson ~ ", cEst,
    "  RootApprox: ", approx,
    "  MinPoly: ", minPoly,
    "  degree: ", Exponent[minPoly, x]];,
  {k, 2, 5}
];

Print[""];
Print["=== Recurrence search for k=3 ==="];
Print["FindLinearRecurrence:"];
rec3 = FindLinearRecurrence[vals3];
If[ListQ[rec3],
  Print["  Found! Order: ", Length[rec3]];
  Print["  Coefficients: ", rec3];,
  Print["  No linear recurrence found (expected: polynomial coefficients)"];
];

(* Try holonomic recurrence via GuessRE if available, *)
(* or check if ratios stabilize *)
Print[""];
Print["Successive ratios a(n)/a(n-1):"];
ratios3 = Table[N[vals3[[n]]/vals3[[n - 1]], 15], {n, 2, 50}];
Print[Take[ratios3, -10]];
Print["Should converge to 4 (dominant singularity at 1/4)"];
