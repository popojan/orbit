BeginTestSection["CircFunctions"]

(* ============================================ *)
(* CONSTANTS                                    *)
(* ============================================ *)

VerificationTest[
  CircIdentity,
  -7/4,
  TestID -> "CircIdentity-value"
]

(* ============================================ *)
(* GROUP AXIOMS                                 *)
(* ============================================ *)

VerificationTest[
  CircTimes[1/3, CircIdentity],
  1/3,
  TestID -> "CircTimes-identity-law"
]

VerificationTest[
  CircTimes[1/3, CircInverse[1/3]],
  CircIdentity,
  TestID -> "CircTimes-inverse-law"
]

VerificationTest[
  CircPower[1/3, 1],
  1/3,
  TestID -> "CircPower-1"
]

VerificationTest[
  CircPower[1/3, 2],
  CircTimes[1/3, 1/3],
  TestID -> "CircPower-2-equals-CircTimes"
]

(* ============================================ *)
(* CONJUGATE INVOLUTION                         *)
(* ============================================ *)

VerificationTest[
  CircConjugate[CircConjugate[2/5]],
  2/5,
  TestID -> "Conjugate-involution"
]

(* ============================================ *)
(* ROOTS OF UNITY vs TRIG                       *)
(* ============================================ *)

(* n=4, k=1: angle = 2*1/4 * Pi = Pi/2 *)
VerificationTest[
  FullSimplify[\[Alpha][\[Kappa][\[Rho][4, 1]]] - {Cos[Pi/2], Sin[Pi/2]}],
  {0, 0},
  TestID -> "Root-n4-k1-vs-trig"
]

(* n=6, k=1: angle = 2*1/6 * Pi = Pi/3 *)
VerificationTest[
  FullSimplify[\[Alpha][\[Kappa][\[Rho][6, 1]]] - {Cos[Pi/3], Sin[Pi/3]}],
  {0, 0},
  TestID -> "Root-n6-k1-vs-trig"
]

(* n=3, k=1: angle = 2*1/3 * Pi = 2Pi/3 *)
VerificationTest[
  FullSimplify[\[Alpha][\[Kappa][\[Rho][3, 1]]] - {Cos[2 Pi/3], Sin[2 Pi/3]}],
  {0, 0},
  TestID -> "Root-n3-k1-vs-trig"
]

(* ============================================ *)
(* Pi_Lp KNOWN VALUES                           *)
(* ============================================ *)

VerificationTest[
  \[Pi]Lp[2],
  Pi,
  TestID -> "PiLp-Euclidean"
]

VerificationTest[
  \[Pi]Lp[1],
  4,
  TestID -> "PiLp-Taxicab"
]

VerificationTest[
  \[Pi]Lp[Infinity],
  4,
  TestID -> "PiLp-Chebyshev"
]

(* ============================================ *)
(* CircPolar: standard polar -> {r, rho} form  *)
(* ============================================ *)

(* CircPolar returns {{r, rho}} term list *)
VerificationTest[
  CircPolar[{3, Pi 2/7}],
  {{3, \[Rho][7, 8]}},
  TestID -> "CircPolar-pi-2-7"
]

VerificationTest[
  CircPolar[{1, Pi/3}],
  {{1, \[Rho][3, 7/2]}},
  TestID -> "CircPolar-pi-3"
]

VerificationTest[
  CircPolar[{5, 0}],
  {{5, CircIdentity}},
  TestID -> "CircPolar-zero-angle"
]

(* Roundtrip: CircPolar -> CircPolarToComplex *)
VerificationTest[
  Chop[N[CircPolarToComplex[CircPolar[{3, Pi 2/7}]] - 3 Exp[I Pi 2/7]]],
  0,
  TestID -> "CircPolar-roundtrip-complex"
]

VerificationTest[
  Chop[N[CircPolarToComplex[CircPolar[{2, Pi}]] - (-2)]],
  0,
  TestID -> "CircPolar-pi-gives-minus-one"
]

EndTestSection[]
