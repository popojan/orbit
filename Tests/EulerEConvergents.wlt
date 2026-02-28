BeginTestSection["EulerEConvergents"]

(* ============================================ *)
(* BESSEL SEQUENCE                              *)
(* ============================================ *)

VerificationTest[
  {BesselESequence[0], BesselESequence[1]},
  {1, 7},
  TestID -> "BesselESeq-initial"
]

(* s[2] = (4*2+2)*s[1] + s[0] = 10*7 + 1 = 71 *)
VerificationTest[
  BesselESequence[2],
  71,
  TestID -> "BesselESeq-recurrence"
]

(* ============================================ *)
(* MONOTONE SEQUENCE                            *)
(* ============================================ *)

VerificationTest[
  Module[{terms = Table[EulerEMonotone[k], {k, 1, 5}]},
    OrderedQ[terms] && AllTrue[terms, # < E &]
  ],
  True,
  TestID -> "Monotone-increasing-below-e"
]

(* ============================================ *)
(* INTERVAL BOUNDS                              *)
(* ============================================ *)

VerificationTest[
  IntervalMemberQ[EulerEInterval[1], E],
  True,
  TestID -> "EulerEInterval-k1-brackets-e"
]

VerificationTest[
  IntervalMemberQ[EulerEInterval[3], E],
  True,
  TestID -> "EulerEInterval-k3-brackets-e"
]

VerificationTest[
  IntervalMemberQ[EInterval[1], E],
  True,
  TestID -> "EInterval-mediant-brackets-e"
]

(* ============================================ *)
(* BESSEL POLYNOMIAL                            *)
(* ============================================ *)

VerificationTest[
  {BesselPolynomial[0, x], BesselPolynomial[1, x]},
  {1, x + 1},
  TestID -> "BesselPolynomial-initial"
]

(* ============================================ *)
(* EULER E CONVERGENT                           *)
(* ============================================ *)

VerificationTest[
  EulerEConvergent[1],
  19/7,
  TestID -> "EulerEConvergent-T1"
]

(* ============================================ *)
(* MONOTONE TERMS CONSISTENCY                   *)
(* ============================================ *)

VerificationTest[
  Total[EulerEMonotone[3, Method -> "Terms"]],
  EulerEMonotone[3],
  TestID -> "Monotone-Terms-sum"
]

(* ============================================ *)
(* INTERVAL WIDTH CONVERGENCE                   *)
(* ============================================ *)

VerificationTest[
  Module[{w1, w3},
    w1 = Max[EulerEInterval[1]] - Min[EulerEInterval[1]];
    w3 = Max[EulerEInterval[3]] - Min[EulerEInterval[3]];
    w3 < w1
  ],
  True,
  TestID -> "Interval-width-decreases"
]

EndTestSection[]
