BeginTestSection["FibonacciFractions"]

(* ============================================ *)
(* ENTRY POINT                                  *)
(* ============================================ *)

VerificationTest[
  FibonacciEntryPoint[5],
  5,
  TestID -> "EntryPoint-5"
]

VerificationTest[
  FibonacciEntryPoint[7],
  8,
  TestID -> "EntryPoint-7"
]

(* ============================================ *)
(* ENTRY POINT DIVISIBILITY                     *)
(* ============================================ *)

VerificationTest[
  Mod[Fibonacci[FibonacciEntryPoint[11]], 11],
  0,
  TestID -> "EntryPoint-divisibility-11"
]

VerificationTest[
  Mod[Fibonacci[FibonacciEntryPoint[113]], 113],
  0,
  TestID -> "EntryPoint-divisibility-113"
]

(* ============================================ *)
(* ZECKENDORF REPRESENTATION                    *)
(* ============================================ *)

(* Non-consecutive: all gaps >= 2 *)
VerificationTest[
  Module[{zeck = Zeckendorf[100]},
    AllTrue[Differences[Reverse[zeck]], # >= 2 &]
  ],
  True,
  TestID -> "Zeckendorf-non-consecutive-100"
]

VerificationTest[
  Total[Fibonacci /@ Zeckendorf[100]],
  100,
  TestID -> "Zeckendorf-sum-100"
]

VerificationTest[
  Total[Fibonacci /@ Zeckendorf[7]],
  7,
  TestID -> "Zeckendorf-sum-7"
]

(* ============================================ *)
(* FIBONACCI FRACTION ROUNDTRIP                 *)
(* ============================================ *)

VerificationTest[
  FibonacciFraction[7/11, Method -> "Sum"],
  7/11,
  TestID -> "FibFraction-roundtrip-7-11"
]

VerificationTest[
  FibonacciFraction[22/7, Method -> "Sum"],
  22/7,
  TestID -> "FibFraction-roundtrip-22-7"
]

(* ============================================ *)
(* EGYPTIAN SERIES                              *)
(* ============================================ *)

VerificationTest[
  Module[{series = FibonacciEgyptianSeries[5]},
    OrderedQ[series] && Last[series] < 1
  ],
  True,
  TestID -> "EgyptianSeries-monotone-bounded"
]

EndTestSection[]
