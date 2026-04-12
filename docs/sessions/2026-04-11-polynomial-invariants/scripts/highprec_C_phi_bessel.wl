<< Orbit`

(* High-precision computation of C(phi) and C(Bessel)
   Goal: enough digits to compute meaningful CFs of C itself *)

nTerms = 500;

(* === COMPUTE SEQUENCES === *)

Print["Computing a(n) for phi, n = 1..", nTerms, " ..."];
tStart = AbsoluteTime[];
seqPhi = Table[BeattyBallotCount[1/GoldenRatio, {nn, nn}], {nn, 1, nTerms}];
Print["  Done in ", Round[AbsoluteTime[] - tStart, 0.1], "s"];

Print["Computing a(n) for Bessel ratio, n = 1..", nTerms, " ..."];
tStart = AbsoluteTime[];
(* Use 100-digit precision for the irrational *)
besselAlpha = N[BesselI[0, 2]/BesselI[1, 2], 100];
seqBessel = Table[BeattyBallotCount[1/besselAlpha, {nn, nn}], {nn, 1, nTerms}];
Print["  Done in ", Round[AbsoluteTime[] - tStart, 0.1], "s"];

(* === ASYMPTOTIC EXTRACTION === *)

(* C_n = a(n) * sqrt(pi*n) / 4^n has expansion C + c1/n + c2/n^2 + ...
   Fit last M points to polynomial in 1/n, extract constant term *)

extractC[seq_List, nCorrTerms_: 20] := Module[
  {len = Length[seq], cn, nStart, nEnd, pts, basis, mat, rhs, sol},

  (* Raw estimates *)
  cn = Table[
    N[seq[[nn]] * Sqrt[Pi * nn] / 4^nn, 50],
    {nn, 1, len}
  ];

  (* Use last 3*nCorrTerms points for fitting *)
  nEnd = len;
  nStart = Max[len - 3 nCorrTerms, len - 100];

  (* Fit: C_n = c0 + c1/n + c2/n^2 + ... + cM/n^M *)
  pts = Range[nStart, nEnd];
  basis = Table[1/nn^k, {nn, pts}, {k, 0, nCorrTerms}];
  rhs = cn[[nStart ;; nEnd]];

  sol = LeastSquares[basis, rhs];

  (* c0 is the extrapolated C *)
  {sol[[1]], cn}
]

Print["\n=== EXTRAPOLATION ===\n"];

{cPhi, cnPhi} = extractC[seqPhi, 25];
Print["C(phi) = ", NumberForm[cPhi, 30]];

{cBessel, cnBessel} = extractC[seqBessel, 25];
Print["C(I0(2)/I1(2)) = ", NumberForm[cBessel, 30]];

(* === CONVERGENCE CHECK: how many digits are stable? === *)
(* Try different numbers of correction terms *)
Print["\n=== STABILITY CHECK (C vs nCorrTerms) ===\n"];

Print["  nCorr\tC(phi)\t\t\t\tC(Bessel)"];
Do[
  {cp, _} = extractC[seqPhi, m];
  {cb, _} = extractC[seqBessel, m];
  Print["  ", m, "\t", NumberForm[cp, 25], "\t", NumberForm[cb, 25]];,
  {m, {10, 15, 20, 25, 30}}
];

(* === CONTINUED FRACTIONS OF C === *)
Print["\n=== CF OF C(phi) ===\n"];

(* Use the best estimate *)
cfPhi = ContinuedFraction[cPhi, 30];
Print["C(phi) = ", NumberForm[cPhi, 25]];
Print["CF = ", cfPhi];
Print["Convergents: "];
Do[
  conv = FromContinuedFraction[cfPhi[[1 ;; k]]];
  Print["  [", k, "] ", conv, " = ", N[conv, 15]];,
  {k, 1, Min[15, Length[cfPhi]]}
];

Print["\n=== CF OF C(I0(2)/I1(2)) ===\n"];

cfBessel = ContinuedFraction[cBessel, 30];
Print["C(Bessel) = ", NumberForm[cBessel, 25]];
Print["CF = ", cfBessel];
Print["Convergents: "];
Do[
  conv = FromContinuedFraction[cfBessel[[1 ;; k]]];
  Print["  [", k, "] ", conv, " = ", N[conv, 15]];,
  {k, 1, Min[15, Length[cfBessel]]}
];

(* === PSLQ-STYLE IDENTIFICATION === *)
Print["\n=== IDENTIFICATION ATTEMPTS ===\n"];

(* Test if C(phi) is related to phi *)
Print["C(phi) vs phi-related constants:"];
Print["  C(phi) = ", NumberForm[cPhi, 20]];
Print["  1/phi^3 = ", NumberForm[N[1/GoldenRatio^3, 20], 20]];
Print["  (phi-1)/2 = ", NumberForm[N[(GoldenRatio - 1)/2, 20], 20]];
Print["  1/(2*phi) = ", NumberForm[N[1/(2 GoldenRatio), 20], 20]];
Print["  2 - phi = ", NumberForm[N[2 - GoldenRatio, 20], 20]];
Print["  phi/2 - 1/2 = ", NumberForm[N[GoldenRatio/2 - 1/2, 20], 20]];
Print["  (3-phi)/4 = ", NumberForm[N[(3 - GoldenRatio)/4, 20], 20]];
Print["  1/(phi^2+1) = ", NumberForm[N[1/(GoldenRatio^2 + 1), 20], 20]];
Print["  sqrt(5)-2 = ", NumberForm[N[Sqrt[5] - 2, 20], 20]];

(* Test C(Bessel) against Bessel values *)
Print["\nC(Bessel) vs Bessel-related constants:"];
Print["  C(Bessel) = ", NumberForm[cBessel, 20]];
i0 = N[BesselI[0, 2], 30];
i1 = N[BesselI[1, 2], 30];
Print["  I1(2)/I0(2) - 1/2 = ", NumberForm[i1/i0 - 1/2, 20]];
Print["  1 - I0(2)/e = ", NumberForm[1 - i0/E, 20]];
Print["  I1(2)^2/I0(2)^2/2 = ", NumberForm[i1^2/(i0^2*2), 20]];
Print["  1/(2*I0(2)) = ", NumberForm[1/(2 i0), 20]];
Print["  I1(2)/(I0(2)*pi) = ", NumberForm[i1/(i0 Pi), 20]];
Print["  2/I0(2)^2 - 1/2 = ", NumberForm[2/i0^2 - 1/2, 20]];

(* === CHECK: is C(phi) algebraic? === *)
Print["\n=== ALGEBRAIC TEST FOR C(phi) ==="];
Print["Testing minimal polynomial up to degree 8...\n"];

Do[
  (* Try to find integer relation: c0 + c1*C + c2*C^2 + ... + cd*C^d = 0 *)
  powers = Table[cPhi^k, {k, 0, deg}];
  (* Simple lattice reduction approach *)
  result = FindIntegerNullVector[powers];
  If[result =!= $Failed && result =!= {},
    poly = Sum[result[[k + 1]] x^k, {k, 0, deg}];
    residual = Abs[poly /. x -> cPhi];
    Print["  deg ", deg, ": ", result, " -> poly = ", poly, ", residual = ", ScientificForm[residual, 3]];
    ,
    Print["  deg ", deg, ": no relation found"];
  ];,
  {deg, 2, 8}
];

Print["\n=== DONE ==="];
