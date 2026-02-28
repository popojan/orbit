BeginTestSection["EgyptianFractions"]

(* ============================================ *)
(* SUM IDENTITY                                 *)
(* ============================================ *)

VerificationTest[
  Total[EgyptianFractions[2/3]],
  2/3,
  TestID -> "SumCheck-2-3"
]

VerificationTest[
  Total[EgyptianFractions[7/19]],
  7/19,
  TestID -> "SumCheck-7-19"
]

VerificationTest[
  Total[EgyptianFractions[2023/2024]],
  2023/2024,
  TestID -> "SumCheck-large-denom"
]

(* ============================================ *)
(* UNIT FRACTION PROPERTY                       *)
(* ============================================ *)

VerificationTest[
  AllTrue[EgyptianFractions[5/8], Numerator[#] === 1 &],
  True,
  TestID -> "AllUnitFractions-5-8"
]

(* ============================================ *)
(* MONOTONE CONVERGENCE                         *)
(* ============================================ *)

VerificationTest[
  Module[{partials = EgyptianFractions[7/19, Method -> "Partials"]},
    OrderedQ[partials] && Last[partials] === 7/19
  ],
  True,
  TestID -> "Partials-monotone-7-19"
]

(* ============================================ *)
(* RAW CLOSED FORM                              *)
(* ============================================ *)

VerificationTest[
  Total[CalculateRawSum /@ RawFractionsSymbolic[7/19]],
  7/19,
  TestID -> "RawSum-roundtrip-7-19"
]

VerificationTest[
  Total[CalculateRawSum /@ RawFractionsSymbolic[3/7]],
  3/7,
  TestID -> "RawSum-roundtrip-3-7"
]

(* ============================================ *)
(* CF-EGYPT EQUIVALENCE (MAIN THEOREM)          *)
(* ============================================ *)

VerificationTest[
  RawFractionsSymbolic[7/19],
  RawFractionsFromCF[7/19],
  TestID -> "CF-Egypt-equiv-7-19"
]

VerificationTest[
  RawFractionsSymbolic[5/8],
  RawFractionsFromCF[5/8],
  TestID -> "CF-Egypt-equiv-5-8"
]

VerificationTest[
  RawFractionsSymbolic[3/7],
  RawFractionsFromCF[3/7],
  TestID -> "CF-Egypt-equiv-3-7"
]

(* ============================================ *)
(* EXPAND vs CALCULATE CONSISTENCY              *)
(* ============================================ *)

VerificationTest[
  Module[{raw = First[RawFractionsSymbolic[7/19]]},
    Total[ExpandRawFraction[raw]] === CalculateRawSum[raw]
  ],
  True,
  TestID -> "ExpandRaw-vs-CalculateRawSum"
]

(* ============================================ *)
(* EDGE CASES                                   *)
(* ============================================ *)

VerificationTest[
  EgyptianFractions[1/7],
  {1/7},
  TestID -> "UnitFraction-identity"
]

VerificationTest[
  Total[EgyptianFractions[6/7]],
  6/7,
  TestID -> "SumCheck-near-one"
]

(* ============================================ *)
(* INTERVAL CORRECTNESS                         *)
(* ============================================ *)

VerificationTest[
  IntervalMemberQ[EgyptianFractionsInterval[Pi], Pi],
  True,
  TestID -> "Interval-brackets-Pi"
]

VerificationTest[
  EgyptianFractionsInterval[3/7],
  Interval[{3/7, 3/7}],
  TestID -> "Interval-rational-degenerate"
]

EndTestSection[]
