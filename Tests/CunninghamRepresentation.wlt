BeginTestSection["CunninghamRepresentation"]

(* ============================================ *)
(* ROUNDTRIP via fold reconstruction            *)
(* Sequence encodes rational exactly;           *)
(* reconstruct by folding (a+r)/(1+a+r)        *)
(* ============================================ *)

VerificationTest[
  Module[{seq = CunninghamSequence[7/19, 50]},
    Fold[(#2 + #1)/(1 + #2 + #1) &, 0, Reverse[seq]]
  ],
  7/19,
  TestID -> "Roundtrip-7-19"
]

VerificationTest[
  Module[{rep = CunninghamRepresentation[355/113, 50], seq, frac},
    seq = rep[[2]];
    frac = Fold[(#2 + #1)/(1 + #2 + #1) &, 0, Reverse[seq]];
    rep[[1]] + frac
  ],
  355/113,
  TestID -> "Roundtrip-355-113"
]

(* ============================================ *)
(* CONVERGENTS                                  *)
(* ============================================ *)

(* Last convergent of a rational equals the rational itself *)
VerificationTest[
  Last[CunninghamConvergents[7/19, 50]],
  7/19,
  TestID -> "Convergents-last-equals-input"
]

(* FromSequence also reconstructs correctly *)
VerificationTest[
  CunninghamFromSequence @@ CunninghamRepresentation[7/19, 50],
  7/19,
  TestID -> "FromSequence-roundtrip-7-19"
]

(* FromSequence roundtrip for number > 1 *)
VerificationTest[
  CunninghamFromSequence @@ CunninghamRepresentation[355/113, 50],
  355/113,
  TestID -> "FromSequence-roundtrip-355-113"
]

(* Every intermediate convergent equals backward-fold of truncated sequence *)
VerificationTest[
  Module[{seq = CunninghamSequence[7/19, 50],
          convs, expected},
    convs = CunninghamConvergents[seq];
    expected = Table[
      Fold[(#2 + #1)/(1 + #2 + #1) &, 0, Reverse[seq[[1 ;; k]]]],
      {k, 1, Length[seq]}
    ];
    convs === expected
  ],
  True,
  TestID -> "Convergents-intermediate-match-fold"
]

(* Odd-indexed convergents of Sqrt[2] approach from below *)
VerificationTest[
  Module[{convs = CunninghamConvergents[N[Sqrt[2], 100], 40],
          oddConvs},
    oddConvs = convs[[1 ;; ;; 2]];
    OrderedQ[oddConvs]
  ],
  True,
  TestID -> "Convergents-odd-monotone"
]

(* ============================================ *)
(* INTEGER PART                                 *)
(* ============================================ *)

VerificationTest[
  CunninghamRepresentation[3 + 1/7, 10][[1]],
  3,
  TestID -> "Integer-part"
]

(* ============================================ *)
(* KNOWN VALUES & EDGE CASES                    *)
(* ============================================ *)

VerificationTest[
  CunninghamSequence[1/2, 1],
  {1},
  TestID -> "Sequence-1-2"
]

VerificationTest[
  CunninghamSequence[0, 10],
  {},
  TestID -> "Sequence-zero"
]

(* ============================================ *)
(* IRRATIONAL APPROXIMATION                     *)
(* ============================================ *)

VerificationTest[
  Module[{convs = CunninghamConvergents[N[Sqrt[2], 100], 40],
          oddConvs},
    oddConvs = convs[[1 ;; ;; 2]];
    Abs[Last[oddConvs] - Sqrt[2]] < 10^-10
  ],
  True,
  TestID -> "Irrational-approx-sqrt2"
]

EndTestSection[]
