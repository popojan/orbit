<< Orbit`

(* High-precision C(phi) via rational convergent 233/144
   This gives IDENTICAL counts to phi for n <= ~24000.
   Use aggressive Richardson extrapolation. *)

nTerms = 1500;

(* Use 233/144 = F_13/F_12, very close to phi *)
alphaNum = 233;
alphaDen = 144;
Print["Using slope ", alphaNum, "/", alphaDen, " = ", N[alphaNum/alphaDen, 15]];
Print["phi = ", N[GoldenRatio, 15]];
Print["|difference| = ", N[Abs[alphaNum/alphaDen - GoldenRatio], 5]];
Print["Counts identical for n <= ", Floor[1/Abs[N[alphaNum/alphaDen - GoldenRatio, 20]]]];

Print["\nComputing a(n) for n = 1..", nTerms, " ..."];
tStart = AbsoluteTime[];

(* Compute in batches, print progress *)
seq = {};
Do[
  batch = Table[
    BeattyBallotCount[alphaDen/alphaNum, {nn, nn}],
    {nn, bStart, Min[bStart + 99, nTerms]}
  ];
  seq = Join[seq, batch];
  If[Mod[bStart, 300] == 1,
    Print["  n = ", bStart, "..", Min[bStart + 99, nTerms],
      " (", Round[AbsoluteTime[] - tStart, 1], "s)"];
  ];,
  {bStart, 1, nTerms, 100}
];
Print["  Done: ", Length[seq], " terms in ", Round[AbsoluteTime[] - tStart, 1], "s"];

(* Raw asymptotic estimates *)
cn = Table[
  N[seq[[nn]] * Sqrt[Pi * nn] / 4^nn, 80],
  {nn, 1, Length[seq]}
];

(* Richardson extrapolation: fit C_n = C + Σ c_k/n^k for k=1..M
   using last P points *)
richardsonFit[cnList_, nCorr_, nPoints_] := Module[
  {len = Length[cnList], nStart, pts, basis, rhs, sol},
  nStart = len - nPoints + 1;
  pts = Range[nStart, len];
  basis = Table[1/nn^k, {nn, pts}, {k, 0, nCorr}];
  rhs = cnList[[nStart ;; len]];
  sol = LeastSquares[basis, rhs];
  sol[[1]]  (* c0 = extrapolated C *)
]

(* === STABILITY CHECK === *)
Print["\n=== STABILITY (varying nCorr, last 200 points) ==="];
Print["nCorr\tC estimate"];
Do[
  cEst = richardsonFit[cn, m, 200];
  Print[m, "\t", NumberForm[cEst, 30]];,
  {m, {10, 15, 20, 25, 30, 35, 40}}
];

(* === ALSO TRY: half-integer powers (1/n^{1/2}, 1/n^{3/2}, ...) === *)
Print["\n=== STABILITY (half-integer powers) ==="];
Do[
  len = Length[cn]; nStart = len - 200 + 1;
  pts = Range[nStart, len];
  (* Basis: 1, 1/sqrt(n), 1/n, 1/n^{3/2}, 1/n^2, ... up to 1/n^{m/2} *)
  basis = Table[1/nn^(k/2), {nn, pts}, {k, 0, m}];
  rhs = cn[[nStart ;; len]];
  sol = LeastSquares[basis, rhs];
  Print[m, "\t", NumberForm[sol[[1]], 30]];,
  {m, {20, 30, 40, 50, 60}}
];

(* Best estimate: use the most stable value *)
cBest = richardsonFit[cn, 30, 200];
Print["\n=== BEST ESTIMATE ==="];
Print["C(phi) = ", NumberForm[cBest, 30]];

(* === CF OF C(phi) === *)
Print["\n=== CF OF C(phi) ==="];
cfPhi = ContinuedFraction[cBest, 50];
Print["CF = ", cfPhi[[1 ;; Min[40, Length[cfPhi]]]]];

(* Show convergents with precision check *)
Print["\nConvergent\tValue\t\t\tDigits matching C"];
Do[
  conv = FromContinuedFraction[cfPhi[[1 ;; k]]];
  convN = N[conv, 30];
  (* Count matching digits *)
  diff = Abs[convN - cBest];
  digits = If[diff == 0, 30, Max[0, Floor[-Log10[Abs[diff]]]]];
  Print["  [", k, "] ", conv, "\t", NumberForm[convN, 15], "\t", digits, " digits"];,
  {k, 1, Min[25, Length[cfPhi]]}
];

Print["\n=== DONE ==="];
