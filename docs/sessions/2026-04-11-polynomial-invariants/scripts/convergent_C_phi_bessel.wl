<< Orbit`

(* C(alpha) at convergents of phi and Bessel ratio I0(2)/I1(2)
   Goal: measure convergence rate to C(alpha), test self-similarity *)

nTerms = 200;

estimateC[seq_List] := Module[{len = Length[seq], estimates, idx},
  estimates = Table[
    idx = len - i;
    N[seq[[idx]] * Sqrt[Pi * idx] / 4^idx, 30],
    {i, 0, 9}
  ];
  {Mean[estimates], StandardDeviation[estimates]}
]

computeC[alpha_] := Module[{beta = 1/alpha, seq, est},
  seq = Table[BeattyBallotCount[beta, {nn, nn}], {nn, 1, nTerms}];
  est = estimateC[seq];
  est
]

(* === FIBONACCI CONVERGENTS of phi = [1; 1, 1, 1, ...] === *)
Print["=== FIBONACCI CONVERGENTS (approaching phi) ===\n"];

fibConvergents = Table[{Fibonacci[k + 1], Fibonacci[k]}, {k, 1, 12}];
(* k=1: 2/1, k=2: 3/2, ..., k=12: 233/144 *)

(* We already have data for small ones; compute from k=1 to k=10 *)
(* But skip k=1 (2/1 = integer, known) and add the limit phi *)

Print["Computing C for Fibonacci convergents F_{k+1}/F_k:"];
Print["  k\tp/q\talpha\t\tC\t\tstdev"];

fibResults = {};
Do[
  {p, q} = fibConvergents[[k]];
  alpha = p/q;
  Print["  ", k, "\t", p, "/", q, "\t", NumberForm[N[alpha], 8], "\t..."];

  {cEst, cStd} = computeC[alpha];

  AppendTo[fibResults, {k, p, q, N[alpha, 15], cEst, cStd}];
  Print["  \t\t\t\tC = ", NumberForm[cEst, 15], " +/- ", ScientificForm[cStd, 2]];,

  {k, 2, 10}  (* skip k=1 (integer slope 2), start from 3/2 *)
];

(* Add known endpoints *)
Print["\n  k=0: 1/1, C = 0 (Catalan)"];
Print["  k=1: 2/1, C = (3-sqrt(5))/2 = ", N[(3 - Sqrt[5])/2, 15]];

(* Compute C(phi) directly (irrational) *)
Print["\nComputing C(phi) directly..."];
{cPhi, cPhiStd} = computeC[GoldenRatio];
Print["  C(phi) = ", NumberForm[cPhi, 15], " +/- ", ScientificForm[cPhiStd, 2]];

(* === CONVERGENCE ANALYSIS === *)
Print["\n=== CONVERGENCE TO C(phi) ==="];
Print["  k\tp/q\tside\t|C(p/q)-C(phi)|\tratio"];

prevBelow = None; prevAbove = None;
Do[
  {k, p, q, alpha, cVal, cStd} = fibResults[[i]];
  diff = cVal - cPhi;
  side = If[diff < 0, "below", "above"];
  absDiff = Abs[diff];

  ratio = If[side == "below",
    If[prevBelow === None, "-", absDiff/prevBelow],
    If[prevAbove === None, "-", absDiff/prevAbove]
  ];

  Print["  ", k, "\t", p, "/", q, "\t", side, "\t",
    ScientificForm[absDiff, 6], "\t",
    If[ratio === "-", "-", NumberForm[ratio, 4]]
  ];

  If[side == "below", prevBelow = absDiff, prevAbove = absDiff];,

  {i, Length[fibResults]}
];

(* === BESSEL CONVERGENTS of [1; 2, 3, 4, 5, ...] = I0(2)/I1(2) === *)
Print["\n\n=== BESSEL CONVERGENTS (approaching I0(2)/I1(2)) ===\n"];

(* Compute convergents of [1; 2, 3, 4, 5, ...] *)
besselCF = Prepend[Range[2, 8], 1]; (* [1; 2, 3, 4, 5, 6, 7, 8] *)
besselAlpha = N[BesselI[0, 2]/BesselI[1, 2], 20];
Print["Target: I0(2)/I1(2) = ", besselAlpha];

besselConvNums = {};
besselConvDens = {};
pPrev2 = 1; pPrev1 = 1;  (* p_{-1}=1, p_0=1 *)
qPrev2 = 0; qPrev1 = 1;  (* q_{-1}=0, q_0=1 *)

Do[
  ak = besselCF[[k]];
  If[k == 1,
    (* a_0 = 1, this gives p_0/q_0 = 1/1 *)
    AppendTo[besselConvNums, 1];
    AppendTo[besselConvDens, 1];
    pPrev2 = 1; pPrev1 = 1; qPrev2 = 0; qPrev1 = 1;
    ,
    pNew = ak * pPrev1 + pPrev2;
    qNew = ak * qPrev1 + qPrev2;
    AppendTo[besselConvNums, pNew];
    AppendTo[besselConvDens, qNew];
    pPrev2 = pPrev1; pPrev1 = pNew;
    qPrev2 = qPrev1; qPrev1 = qNew;
  ];,
  {k, Length[besselCF]}
];

Print["Convergents:"];
Do[
  Print["  k=", k - 1, ": ", besselConvNums[[k]], "/", besselConvDens[[k]],
    " = ", N[besselConvNums[[k]]/besselConvDens[[k]], 10]];,
  {k, Length[besselConvNums]}
];

(* Compute C for Bessel convergents (skip k=0: 1/1 is Catalan, C=0) *)
Print["\nComputing C for Bessel convergents:"];
Print["  k\tp/q\talpha\t\tC\t\tstdev"];

besselResults = {};
Do[
  p = besselConvNums[[k]]; q = besselConvDens[[k]];
  alpha = p/q;

  (* Skip if p > 300 — too slow *)
  If[p > 300,
    Print["  k=", k - 1, "\t", p, "/", q, "\tSKIPPED (p too large)"];
    Continue[]
  ];

  Print["  k=", k - 1, "\t", p, "/", q, "\t", NumberForm[N[alpha], 8], "\t..."];

  {cEst, cStd} = computeC[alpha];

  AppendTo[besselResults, {k - 1, p, q, N[alpha, 15], cEst, cStd}];
  Print["  \t\t\t\tC = ", NumberForm[cEst, 15], " +/- ", ScientificForm[cStd, 2]];,

  {k, 2, Length[besselConvNums]}  (* skip k=0 *)
];

(* Compute C(Bessel) directly *)
Print["\nComputing C(I0(2)/I1(2)) directly..."];
{cBessel, cBesselStd} = computeC[BesselI[0, 2]/BesselI[1, 2]];
Print["  C(I0(2)/I1(2)) = ", NumberForm[cBessel, 15], " +/- ", ScientificForm[cBesselStd, 2]];

(* === BESSEL CONVERGENCE ANALYSIS === *)
Print["\n=== CONVERGENCE TO C(I0(2)/I1(2)) ==="];
Print["  k\tp/q\tside\t|C(p/q)-C(target)|\tratio"];

prevBelow = None; prevAbove = None;
Do[
  {k, p, q, alpha, cVal, cStd} = besselResults[[i]];
  diff = cVal - cBessel;
  side = If[diff < 0, "below", "above"];
  absDiff = Abs[diff];

  ratio = If[side == "below",
    If[prevBelow === None, "-", absDiff/prevBelow],
    If[prevAbove === None, "-", absDiff/prevAbove]
  ];

  Print["  ", k, "\t", p, "/", q, "\t", side, "\t",
    ScientificForm[absDiff, 6], "\t",
    If[ratio === "-", "-", NumberForm[ratio, 4]]
  ];

  If[side == "below", prevBelow = absDiff, prevAbove = absDiff];,

  {i, Length[besselResults]}
];

(* === COMPARISON SUMMARY === *)
Print["\n\n=== SUMMARY ==="];
Print["C(phi) = ", NumberForm[cPhi, 15]];
Print["C(I0(2)/I1(2)) = ", NumberForm[cBessel, 15]];
Print["\nphi = ", N[GoldenRatio, 15]];
Print["I0(2)/I1(2) = ", N[BesselI[0, 2]/BesselI[1, 2], 15]];

(* Save results *)
outFile = FileNameJoin[{DirectoryName[$InputFileName], "convergent_results.tsv"}];
allRows = Join[
  {{"target", "k", "p", "q", "alpha", "C", "stdev"}},
  ({"phi", #[[1]], #[[2]], #[[3]], ToString[NumberForm[#[[4]], 12]],
    ToString[NumberForm[#[[5]], 15]], ToString[ScientificForm[#[[6]], 3]]} &) /@ fibResults,
  {{"phi", "inf", "-", "-", ToString[NumberForm[N[GoldenRatio, 12], 12]],
    ToString[NumberForm[cPhi, 15]], ToString[ScientificForm[cPhiStd, 3]]}},
  ({"bessel", #[[1]], #[[2]], #[[3]], ToString[NumberForm[#[[4]], 12]],
    ToString[NumberForm[#[[5]], 15]], ToString[ScientificForm[#[[6]], 3]]} &) /@ besselResults,
  {{"bessel", "inf", "-", "-", ToString[NumberForm[besselAlpha, 12]],
    ToString[NumberForm[cBessel, 15]], ToString[ScientificForm[cBesselStd, 3]]}}
];
Export[outFile, allRows, "TSV"];
Print["\nSaved to ", outFile];
