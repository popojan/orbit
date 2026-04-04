BeginTestSection["SuccessorOrbit"]

(* ============================================ *)
(* NATURALS: o = 1, λ = 2                      *)
(* ============================================ *)

VerificationTest[
  SuccessorOrbit[1, Range[0, 8]],
  {1, 2, 3, 4, 5, 6, 7, 8, 9},
  TestID -> "Naturals-o1-lambda2"
]

(* ============================================ *)
(* ODD NUMBERS: o = 1/4, λ = 3                 *)
(* ============================================ *)

VerificationTest[
  SuccessorOrbit[1/4, Range[0, 6], 3] * 4,
  {1, 3, 5, 7, 9, 11, 13},
  TestID -> "Odds-o1over4-lambda3"
]

(* ============================================ *)
(* PERIOD 6: o = 1/3                            *)
(* ============================================ *)

VerificationTest[
  SuccessorOrbit[1/3, Range[0, 7]],
  {1/3, 2/3, 1/3, -1/3, -2/3, -1/3, 1/3, 2/3},
  TestID -> "Period6-o1over3"
]

(* ============================================ *)
(* PERIOD 4: o = 1/5                            *)
(* ============================================ *)

VerificationTest[
  SuccessorOrbit[1/5, Range[0, 5]],
  {1/5, 2/5, -1/5, -2/5, 1/5, 2/5},
  TestID -> "Period4-o1over5"
]

(* ============================================ *)
(* SINGLE VALUE ACCESS                          *)
(* ============================================ *)

VerificationTest[
  SuccessorOrbit[1, 100],
  101,
  TestID -> "SingleAccess-k100"
]

VerificationTest[
  SuccessorOrbit[10/11, 0],
  10/11,
  TestID -> "SingleAccess-k0"
]

(* ============================================ *)
(* CASSINI INVARIANT = o (always)               *)
(* ============================================ *)

VerificationTest[
  Module[{seq = SuccessorOrbit[10/11, Range[0, 10]]},
    Union[Table[seq[[k]]^2 - seq[[k - 1]] seq[[k + 1]], {k, 2, Length[seq] - 1}]]
  ],
  {10/11},
  TestID -> "Cassini-invariant-10over11"
]

VerificationTest[
  Module[{seq = SuccessorOrbit[3/7, Range[0, 10]]},
    Union[Table[seq[[k]]^2 - seq[[k - 1]] seq[[k + 1]], {k, 2, Length[seq] - 1}]]
  ],
  {3/7},
  TestID -> "Cassini-invariant-3over7"
]

(* Cassini independent of λ *)
VerificationTest[
  Module[{seq = SuccessorOrbit[2/5, Range[0, 8], 3]},
    Union[Table[seq[[k]]^2 - seq[[k - 1]] seq[[k + 1]], {k, 2, Length[seq] - 1}]]
  ],
  {2/5},
  TestID -> "Cassini-invariant-lambda3"
]

(* ============================================ *)
(* MATRIX                                       *)
(* ============================================ *)

VerificationTest[
  SuccessorMatrix[10/11],
  {{39, -20}, {20, 0}},
  TestID -> "Matrix-10over11"
]

VerificationTest[
  Det[SuccessorMatrix[10/11]],
  400,
  TestID -> "Matrix-det-10over11"
]

VerificationTest[
  SuccessorMatrix[1],
  {{4, -2}, {2, 0}},
  TestID -> "Matrix-naturals"
]

(* General λ *)
VerificationTest[
  SuccessorMatrix[1/3, 3],
  {{7, -3}, {3, 0}},
  TestID -> "Matrix-lambda3"
]

(* ============================================ *)
(* CLOSED FORM MATCHES MATRIX                   *)
(* ============================================ *)

VerificationTest[
  Module[{o = 10/11, c},
    c = (5 o - 1)/(4 o);
    Table[
      o ChebyshevU[k, c] + (1 - o)/2 ChebyshevU[k - 1, c] // FullSimplify,
      {k, 0, 8}
    ] === SuccessorOrbit[o, Range[0, 8]]
  ],
  True,
  TestID -> "ClosedForm-matches-matrix"
]

(* ============================================ *)
(* INTEGER TRACE                                *)
(* ============================================ *)

VerificationTest[
  SuccessorTrace[10/11, Range[0, 5]],
  {2, 39, 721, 12519, 199841, 2786199},
  TestID -> "Trace-10over11"
]

(* Trace is always integer *)
VerificationTest[
  AllTrue[SuccessorTrace[10/11, Range[0, 20]], IntegerQ],
  True,
  TestID -> "Trace-always-integer"
]

(* ============================================ *)
(* MODULAR ORBIT                                *)
(* ============================================ *)

(* Single access *)
VerificationTest[
  SuccessorOrbitMod[10/11, 0, 41],
  Mod[{20, 10}, 41],
  TestID -> "OrbitMod-k0"
]

(* Period mod p *)
VerificationTest[
  IntegerQ[SuccessorPeriodMod[10/11, 41]],
  True,
  TestID -> "PeriodMod-41-exists"
]

(* Modular orbit is periodic *)
VerificationTest[
  Module[{per = SuccessorPeriodMod[10/11, 41]},
    SuccessorOrbitMod[10/11, 0, 41] === SuccessorOrbitMod[10/11, per, 41]
  ],
  True,
  TestID -> "ModularOrbit-periodic"
]

(* List access — contiguous range *)
VerificationTest[
  Length[SuccessorOrbitMod[10/11, Range[0, 27], 41]],
  28,
  TestID -> "OrbitMod-list-length"
]

(* ============================================ *)
(* DISCRIMINANT                                 *)
(* ============================================ *)

VerificationTest[
  SuccessorDiscriminant[10/11],
  79,
  TestID -> "Discriminant-10over11"
]

VerificationTest[
  SuccessorDiscriminant[2/3],
  15,
  TestID -> "Discriminant-2over3"
]

(* General λ *)
VerificationTest[
  SuccessorDiscriminant[2/3, 3],
  (3 - 4*2)(16*2 - 3),  (* = (-5)(29) = -145 *)
  TestID -> "Discriminant-lambda3"
]

(* ============================================ *)
(* CHEBYSHEV PARAMETER                          *)
(* ============================================ *)

VerificationTest[
  SuccessorChebyshev[1][[1]],
  1,
  TestID -> "Chebyshev-c-naturals"
]

VerificationTest[
  SuccessorChebyshev[1/3][[1]],
  1/2,
  TestID -> "Chebyshev-c-period6"
]

VerificationTest[
  SuccessorChebyshev[1/5][[1]],
  0,
  TestID -> "Chebyshev-c-period4"
]

(* ============================================ *)
(* PELL CONNECTION                              *)
(* ============================================ *)

VerificationTest[
  Table[ChebyshevU[k, 2], {k, 0, 5}],
  {1, 4, 15, 56, 209, 780},
  TestID -> "Pell-D3-qvalues-are-ChebyshevU"
]

EndTestSection[]
