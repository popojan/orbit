BeginTestSection["SquareRootRationalizations"]

(* ============================================ *)
(* PELL EQUATION                                *)
(* ============================================ *)

VerificationTest[
  Module[{sol = PellSolution[2], xv, yv},
    xv = x /. sol;
    yv = y /. sol;
    xv^2 - 2 yv^2
  ],
  1,
  TestID -> "Pell-d2-equation"
]

VerificationTest[
  Module[{sol = PellSolution[13], xv, yv},
    xv = x /. sol;
    yv = y /. sol;
    xv^2 - 13 yv^2
  ],
  1,
  TestID -> "Pell-d13-equation"
]

(* ============================================ *)
(* PELL KNOWN VALUES                            *)
(* ============================================ *)

VerificationTest[
  {x, y} /. PellSolution[2],
  {3, 2},
  TestID -> "Pell-d2-known"
]

VerificationTest[
  {x, y} /. PellSolution[5],
  {9, 4},
  TestID -> "Pell-d5-known"
]

(* ============================================ *)
(* SQRT RATIONALIZATION PRECISION               *)
(* ============================================ *)

(* Test approx² ≈ n using exact rational arithmetic — no precision issues *)
VerificationTest[
  Abs[SqrtRationalization[2, Method -> "Rational", Accuracy -> 30]^2 - 2] < 10^-20,
  True,
  TestID -> "SqrtRat-d2-precision"
]

VerificationTest[
  Abs[SqrtRationalization[13, Method -> "Rational", Accuracy -> 20]^2 - 13] < 10^-30,
  True,
  TestID -> "SqrtRat-d13-precision"
]

(* ============================================ *)
(* BRAHMAGUPTA-BHASKARA                         *)
(* ============================================ *)

VerificationTest[
  Module[{sol = BrahmaguptaBhaskaraSolve[7], xv, yv},
    xv = sol["x"];
    yv = sol["y"];
    xv^2 - 7 yv^2
  ],
  1,
  TestID -> "Brahmagupta-d7-equation"
]

(* ============================================ *)
(* CHEBYSHEV TERM RATIONALITY                   *)
(* ============================================ *)

VerificationTest[
  Module[{sol = PellSolution[2], xVal},
    xVal = x /. sol;
    Head[ChebyshevTerm[xVal - 1, 3]] === Rational || IntegerQ[ChebyshevTerm[xVal - 1, 3]]
  ],
  True,
  TestID -> "ChebyshevTerm-rational-at-Pell"
]

(* ============================================ *)
(* SQRT INTERVAL BOUNDS                         *)
(* ============================================ *)

VerificationTest[
  IntervalMemberQ[SqrtInterval[2, 3], Sqrt[2]],
  True,
  TestID -> "SqrtInterval-d2-brackets"
]

VerificationTest[
  IntervalMemberQ[SqrtInterval[13, 3], Sqrt[13]],
  True,
  TestID -> "SqrtInterval-d13-brackets"
]

(* Interval width decreases with higher accuracy *)
VerificationTest[
  Module[{w1, w5},
    w1 = Max[SqrtInterval[2, 1]] - Min[SqrtInterval[2, 1]];
    w5 = Max[SqrtInterval[2, 5]] - Min[SqrtInterval[2, 5]];
    w5 < w1
  ],
  True,
  TestID -> "SqrtInterval-width-decreases"
]

(* ============================================ *)
(* SEED FLOOR & WIDTH CONVERGENCE              *)
(* ============================================ *)

(* For integer d, SqrtConvergent finds Pell solution (N=1) with floor = 0 *)
VerificationTest[
  (floor /. SqrtConvergent[13, 10^-10]) < 10^-20,
  True,
  TestID -> "SqrtConvergent-Pell-floor-vanishes"
]

(* For irrational d, floor is positive *)
VerificationTest[
  (floor /. SqrtConvergent[Pi]) > 0,
  True,
  TestID -> "SqrtConvergent-irrational-positive-floor"
]

(* targetFloor controls precision: tighter target -> smaller floor *)
VerificationTest[
  Module[{f1, f2},
    f1 = floor /. SqrtConvergent[Pi, 10^-3];
    f2 = floor /. SqrtConvergent[Pi, 10^-10];
    f1 < 10^-3 && f2 < 10^-10
  ],
  True,
  TestID -> "SqrtConvergent-targetFloor-controls-precision"
]

(* EgyptSqrt width decreases monotonically with k for irrational seed *)
VerificationTest[
  Module[{sol = SqrtConvergent[Pi], pv, qv, widths},
    pv = p /. sol; qv = q /. sol;
    widths = Table[
      N[Max[EgyptSqrt[Pi, {pv, qv}, k]] - Min[EgyptSqrt[Pi, {pv, qv}, k]]],
      {k, 1, 8}];
    AllTrue[Differences[widths], Negative]
  ],
  True,
  TestID -> "EgyptSqrt-irrational-width-monotone"
]

(* Width converges to floor: at large k, relative error < 0.1% *)
VerificationTest[
  Module[{sol = SqrtConvergent[Pi], pv, qv, fl, widthLarge},
    pv = p /. sol; qv = q /. sol;
    fl = floor /. sol;
    widthLarge = N[Max[EgyptSqrt[Pi, {pv, qv}, 20]] - Min[EgyptSqrt[Pi, {pv, qv}, 20]]];
    Abs[widthLarge - fl] / fl < 10^-3
  ],
  True,
  TestID -> "EgyptSqrt-width-converges-to-floor"
]

(* For Pell seeds (N=1), each k step multiplies precision by ~x *)
(* Width: 2/y -> 1/(xy) -> ... so w(0)/w(1) ≈ 2x                *)
VerificationTest[
  Module[{sol = PellSolution[13], xv, yv, w0, w1},
    xv = x /. sol; yv = y /. sol;
    w0 = Max[EgyptSqrt[13, {xv, yv}, 0]] - Min[EgyptSqrt[13, {xv, yv}, 0]];
    w1 = Max[EgyptSqrt[13, {xv, yv}, 1]] - Min[EgyptSqrt[13, {xv, yv}, 1]];
    (* w0/w1 = 2x for Pell seeds *)
    w0 / w1 == 2 xv
  ],
  True,
  TestID -> "EgyptSqrt-Pell-iteration-gain-2x"
]

(* For integer d with Pell seed (N=1), width -> 0 without floor *)
VerificationTest[
  Module[{sol = PellSolution[13], xv, yv, w},
    xv = x /. sol; yv = y /. sol;
    w = Max[EgyptSqrt[13, {xv, yv}, 15]] - Min[EgyptSqrt[13, {xv, yv}, 15]];
    w < 10^-30
  ],
  True,
  TestID -> "EgyptSqrt-Pell-width-vanishes"
]

EndTestSection[]
