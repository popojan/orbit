(* ============================================================
   RUIN THEORY VERIFICATION FOR C(p/q)
   ============================================================

   Master equation: (2t-1)^q = t^{p+q}
   After removing t=1: polynomial of degree p+q-1

   For each rational slope p/q:
   1. Find roots t_i with |t_i| < 1
   2. Compute phase amplitudes A_j^(i)
   3. Solve q×q boundary system
   4. Compute C(p/q) = (1 - ruin probability) / 2
   5. Compare with BeattyBallotCount numerics

   ============================================================ *)

<< Orbit`

(* === HELPER: Rise sequence for slope p/q === *)
riseSequence[p_, q_] := Table[
  Floor[p (j + 1)/q] - Floor[p j/q],
  {j, 0, q - 1}
]

(* === HELPER: Estimate C from BeattyBallotCount === *)
estimateC[alpha_, nTerms_: 300] := Module[{seq, cn, nStart, basis, rhs, sol},
  seq = Table[BeattyBallotCount[1/alpha, {nn, nn}], {nn, 1, nTerms}];
  cn = Table[N[seq[[nn]] Sqrt[Pi nn]/4^nn, 50], {nn, 1, nTerms}];
  nStart = nTerms - 80;
  basis = Table[1/nn^k, {nn, nStart, nTerms}, {k, 0, 20}];
  rhs = cn[[nStart ;; nTerms]];
  sol = LeastSquares[basis, rhs];
  sol[[1]]
]

(* === MAIN: Compute C(p/q) from ruin theory === *)
ruinC[p_, q_] := Module[
  {rises, masterPoly, t, allRoots, goodRoots, nRoots,
   ampMatrix, boundaryMatrix, rhs, coeffs, s0, j0, ruin, cVal,
   phaseAmps},

  (* Step 0: Rise sequence *)
  rises = riseSequence[p, q];
  Print["  Rise sequence: ", rises, "  (sum = ", Total[rises], " = p)"];

  (* Step 1: Master polynomial *)
  masterPoly = (2 t - 1)^q - t^(p + q);
  (* Remove factor (t-1) *)
  masterPoly = Cancel[masterPoly / (t - 1)];
  Print["  Master polynomial (after /t-1): ", Collect[masterPoly, t]];
  Print["  Degree: ", Exponent[masterPoly, t]];

  (* Step 2: Find all roots *)
  allRoots = t /. Solve[masterPoly == 0, t];
  Print["  All roots: ", N[allRoots, 8]];

  (* Step 3: Select roots with |t| < 1 *)
  goodRoots = Select[allRoots, Abs[N[#, 20]] < 1 &];
  nRoots = Length[goodRoots];
  Print["  Roots with |t|<1: ", nRoots, " (expected q = ", q, ")"];
  Print["  Good roots: ", N[goodRoots, 10]];

  If[nRoots != q,
    Print["  WARNING: number of good roots != q!"];
  ];

  (* Step 4: Phase amplitudes A_j^(i) *)
  (* A_0^(i) = 1, A_{j+1}^(i) = A_j^(i) * (2t_i - 1) / t_i^{r_j + 1} *)
  phaseAmps = Table[
    Module[{amp = 1, amps = {1}},
      Do[
        amp = amp * (2 goodRoots[[i]] - 1) / goodRoots[[i]]^(rises[[j]] + 1);
        AppendTo[amps, amp];,
        {j, 1, q - 1}
      ];
      amps (* length q: A_0, A_1, ..., A_{q-1} *)
    ],
    {i, nRoots}
  ];

  (* Step 5: Boundary system: sum_i c_i * A_j^(i) / t_i = 1 for all j *)
  boundaryMatrix = Table[
    phaseAmps[[i, j + 1]] / goodRoots[[i]],
    {j, 0, q - 1}, {i, nRoots}
  ];
  rhs = ConstantArray[1, q];
  coeffs = LinearSolve[boundaryMatrix, rhs];
  Print["  Coefficients c_i: ", N[coeffs, 10]];

  (* Step 6: Compute ruin probability at starting position *)
  s0 = Floor[p/q]; (* starting height = Floor[(p/q)*1] *)
  j0 = Mod[1, q];  (* starting phase = x mod q at x=1 *)
  ruin = Sum[
    coeffs[[i]] * phaseAmps[[i, j0 + 1]] * goodRoots[[i]]^s0,
    {i, nRoots}
  ];
  cVal = (1 - ruin) / 2;

  Print["  Starting position: s0 = ", s0, ", j0 = ", j0];
  Print["  Ruin probability: ", N[ruin, 15]];
  Print["  C(", p, "/", q, ") from ruin theory: ", N[cVal, 15]];

  (* Return exact symbolic value *)
  cVal
]

(* ============================================================
   TEST 1: INTEGER SLOPES (should recover known C(k))
   ============================================================ *)

Print["============================================================"];
Print["TEST 1: INTEGER SLOPES (q=1)"];
Print["============================================================\n"];

Do[
  Print["--- Slope k = ", kk, " ---"];
  cRuin = ruinC[kk, 1];
  cKnown = 1 - 1/RootReduce[Max[v /. Solve[v^kk == Sum[v^j, {j, 0, kk - 1}], v, Reals]]];
  Print["  C(", kk, ") known (1-1/tau_k): ", N[cKnown, 15]];
  Print["  Match: ", N[Abs[cRuin - cKnown], 5] < 10^-10];
  Print[];,
  {kk, 2, 5}
];

(* ============================================================
   TEST 2: COLLAPSE TEST - integer slope via higher q
   ============================================================ *)

Print["============================================================"];
Print["TEST 2: COLLAPSE (integer slope 2 written as 4/2 and 6/3)"];
Print["============================================================\n"];

Print["--- Slope 4/2 = 2 (q=2 framework) ---"];
cRuin42 = ruinC[4, 2];
Print["  Should equal C(2) = 1/phi^2 = ", N[(3 - Sqrt[5])/2, 15]];
Print["  Match: ", N[Abs[cRuin42 - (3 - Sqrt[5])/2], 5] < 10^-10];
Print[];

Print["--- Slope 6/3 = 2 (q=3 framework) ---"];
cRuin63 = ruinC[6, 3];
Print["  Should equal C(2) = 1/phi^2 = ", N[(3 - Sqrt[5])/2, 15]];
Print["  Match: ", N[Abs[cRuin63 - (3 - Sqrt[5])/2], 5] < 10^-10];
Print[];

Print["--- Slope 6/2 = 3 (q=2 framework) ---"];
cRuin62 = ruinC[6, 2];
cK3 = 1 - 1/RootReduce[Max[v /. Solve[v^3 == v^2 + v + 1, v, Reals]]];
Print["  Should equal C(3) = ", N[cK3, 15]];
Print["  Match: ", N[Abs[cRuin62 - cK3], 5] < 10^-10];
Print[];

(* ============================================================
   TEST 3: RATIONAL SLOPES - ruin theory vs numerics
   ============================================================ *)

Print["============================================================"];
Print["TEST 3: RATIONAL SLOPES (ruin theory vs BeattyBallotCount)"];
Print["============================================================\n"];

testSlopes = {{3, 2}, {5, 2}, {5, 3}, {7, 3}, {4, 3}, {7, 4}, {5, 4}};

Do[
  {p, q} = slope;
  If[GCD[p, q] != 1, Continue[]];
  Print["--- Slope ", p, "/", q, " = ", N[p/q, 5], " ---"];

  cRuin = ruinC[p, q];

  Print["  Computing BeattyBallotCount estimate (300 terms)..."];
  cNum = estimateC[p/q, 300];
  Print["  C from numerics: ", NumberForm[cNum, 12]];
  Print["  C from ruin:     ", NumberForm[N[cRuin, 15], 12]];
  Print["  Difference:      ", ScientificForm[N[Abs[cRuin - cNum], 5], 3]];
  Print[];,

  {slope, testSlopes}
];

(* ============================================================
   TEST 4: EXACT SYMBOLIC C(3/2)
   ============================================================ *)

Print["============================================================"];
Print["TEST 4: EXACT SYMBOLIC C(3/2)"];
Print["============================================================\n"];

(* Solve quartic exactly *)
quartic = t^4 + t^3 + t^2 - 3 t + 1;
Print["Quartic: ", quartic, " = 0"];
exactRoots = t /. Solve[quartic == 0, t];
Print["Roots: "];
Do[
  Print["  t", i, " = ", exactRoots[[i]]];
  Print["       = ", N[exactRoots[[i]], 15]];
  Print["       |t| = ", N[Abs[exactRoots[[i]]], 10]];,
  {i, Length[exactRoots]}
];

(* Select roots with |t| < 1 *)
goodExact = Select[exactRoots, Abs[N[#, 20]] < 1 &];
Print["\nGood roots (|t|<1): ", Length[goodExact]];

(* Rise sequence *)
rises32 = riseSequence[3, 2];
Print["Rise sequence: ", rises32];

(* Phase amplitudes *)
Print["\nPhase amplitudes A_1^(i) = (2t-1)/t^{r_0+1} = (2t-1)/t^3:"];
amps = Table[(2 goodExact[[i]] - 1)/goodExact[[i]]^(rises32[[1]] + 1), {i, 2}];
Do[Print["  A_1^(", i, ") = ", Simplify[amps[[i]]]];, {i, 2}];

(* Boundary system *)
bMat = {{1/goodExact[[1]], 1/goodExact[[2]]},
        {amps[[1]]/goodExact[[1]], amps[[2]]/goodExact[[2]]}};
Print["\nBoundary matrix:"];
Print["  ", MatrixForm[Simplify[bMat]]];

cVec = LinearSolve[bMat, {1, 1}];
Print["\nCoefficients:"];
Print["  c1 = ", Simplify[cVec[[1]]]];
Print["  c2 = ", Simplify[cVec[[2]]]];

(* Ruin probability — starting at s0=1, phase j0=1 (= x mod q = 1 mod 2) *)
(* rho(1, 1) = c1 * A_1^(1) * t1 + c2 * A_1^(2) * t2 *)
rho = cVec[[1]] amps[[1]] goodExact[[1]] + cVec[[2]] amps[[2]] goodExact[[2]];
cExact = (1 - rho)/2;
cExact = FullSimplify[cExact];

Print["\nStarting phase j0 = 1 (x mod q = 1 mod 2)"];
Print["rho(1, 1) = c1*A1^(1)*t1 + c2*A1^(2)*t2"];
Print["\nEXACT C(3/2) = ", cExact];
Print["Numerically  = ", N[cExact, 30]];

(* Minimal polynomial of C(3/2) *)
Print["\nMinimal polynomial of C(3/2):"];
mp = MinimalPolynomial[cExact, x];
Print["  ", mp, " = 0"];
Print["  Degree: ", Exponent[mp, x]];

Print["\n============================================================"];
Print["DONE"];
Print["============================================================"];
