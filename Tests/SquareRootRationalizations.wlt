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

EndTestSection[]
