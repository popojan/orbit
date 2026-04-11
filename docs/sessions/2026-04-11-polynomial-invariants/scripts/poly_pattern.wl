<< Orbit`

alpha = Sqrt[2]; w = 1;
convs = Convergents[alpha, 12];
pNums = Numerator /@ convs;
qDens = Denominator /@ convs;

(* Compute universal polynomial at height q_j *)
universalPoly[j_] := Module[{height, kUse, cv, a, b, maxPos, prevPos, row, pts},
  height = qDens[[j + 1]];
  kUse = j + 3;
  cv = Convergents[alpha, kUse];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  InterpolatingPolynomial[pts, n] // Expand
]

(* ============================================================ *)
(* PATTERN 1: Zero / Ballot alternation at convergent numerators *)
(* ============================================================ *)

Print["=== Zero/Ballot alternation ==="];
Print[""];
Print["Convergent p_j/q_j alternates above/below alpha=Sqrt[2]:"];
Do[
  Print["  p_", j, "/q_", j, " = ", pNums[[j+1]], "/", qDens[[j+1]],
    " = ", N[pNums[[j+1]]/qDens[[j+1]], 10],
    If[pNums[[j+1]]/qDens[[j+1]] > alpha, " > Sqrt[2]", " < Sqrt[2]"]];,
  {j, 0, 7}
];
Print[""];

Print["P_{q_j}(p_j):"];
Do[
  poly = universalPoly[j];
  height = qDens[[j + 1]];
  pj = pNums[[j + 1]];
  val = poly /. n -> pj;
  ballot = Binomial[pj + height - 1, height]/pj;
  above = pj/qDens[[j+1]] > alpha;
  Print["  j=", j, ": P_{", height, "}(", pj, ") = ", val,
    If[val === 0, "  [ZERO - p_j/q_j < alpha]", ""],
    If[val === ballot, "  [= B(" <> ToString[pj] <> "," <> ToString[height] <> ") - p_j/q_j > alpha]", ""]
  ];,
  {j, 1, 6}
];

(* ============================================================ *)
(* PATTERN 2: Express in binomial basis C(n+k, k+1)             *)
(* ============================================================ *)

Print[""];
Print["=== Binomial basis representation ==="];
Print["P_j(n) = sum_m c_m * Binomial[n+m, m+1]"];
Print[""];

Do[
  poly = universalPoly[j];
  height = qDens[[j + 1]];

  (* Express in binomial basis: find c_m such that *)
  (* P_j(n) = sum_{m=0}^{height-1} c_m * Binomial[n+m, m+1] *)
  (* Build the basis: b_m(n) = Binomial[n+m, m+1] *)
  (* Use system of equations at n = 1, 2, ..., height *)
  basisMatrix = Table[Binomial[nn + m, m + 1], {nn, 1, height}, {m, 0, height - 1}];
  polyVals = Table[poly /. n -> nn, {nn, 1, height}];
  coeffs = LinearSolve[basisMatrix, polyVals];

  Print["j=", j, " (q_j=", height, "):"];
  Print["  coeffs c_m: ", coeffs];
  Print[""];,
  {j, 1, 5}
];

(* ============================================================ *)
(* PATTERN 3: Try ballot basis B(n, m)                           *)
(* ============================================================ *)

Print["=== Ballot basis representation ==="];
Print["P_j(n) = sum_m c_m * B(n, m) where B(n,m) = Binomial[n+m-1,m]/n"];
Print[""];

Do[
  poly = universalPoly[j];
  height = qDens[[j + 1]];

  (* Ballot basis: B(n, m) = Binomial[n+m-1, m]/n *)
  (* This is degree m-1 in n (after cancellation), so use m=1..height *)
  (* B(n,0) = 1/n is NOT polynomial, skip. Use B(n,1)=1, B(n,2)=(n+1)/2, ... *)
  (* Actually (n-wm)/n * Binomial[n+m-1,m] = vLin is polynomial of degree m *)
  (* Use vLin basis instead *)
  vLinBasis = Table[(nn - w m)/nn Binomial[nn + m - 1, m], {m, 0, height - 1}];

  basisAtPts = Table[
    Table[(nn - w m)/nn Binomial[nn + m - 1, m] /. nn -> pt,
      {m, 0, height - 1}],
    {pt, height + 2, 2 height + 1}  (* avoid small n where 1/n issues *)
  ];
  polyAtPts = Table[poly /. n -> pt, {pt, height + 2, 2 height + 1}];
  coeffs = LinearSolve[basisAtPts, polyAtPts];

  Print["j=", j, " (q_j=", height, "):"];
  Print["  vLin basis coeffs: ", coeffs];
  Print[""];,
  {j, 1, 4}
];
