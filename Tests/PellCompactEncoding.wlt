BeginTestSection["PellCompactEncoding"]

(* ============================================ *)
(* PellReconstruct: known Pell solutions         *)
(* ============================================ *)

VerificationTest[
  PellReconstruct[2, 1],
  {3, 2},
  TestID -> "PellReconstruct-d2"
]

VerificationTest[
  PellReconstruct[3, 1],
  {2, 1},
  TestID -> "PellReconstruct-d3"
]

VerificationTest[
  PellReconstruct[5, 1],
  {9, 4},
  TestID -> "PellReconstruct-d5"
]

VerificationTest[
  PellReconstruct[61, 11],
  {1766319049, 226153980},
  TestID -> "PellReconstruct-d61"
]

VerificationTest[
  PellReconstruct[109, 17],
  {158070671986249, 15140424455100},
  TestID -> "PellReconstruct-d109"
]

VerificationTest[
  Module[{xy = PellReconstruct[193, 15]},
    xy[[1]]^2 - 193 xy[[2]]^2],
  1,
  TestID -> "PellReconstruct-d193-identity"
]

(* ============================================ *)
(* PellReconstruct: identity check               *)
(* ============================================ *)

VerificationTest[
  Module[{xy = PellReconstruct[151, 22]},
    xy[[1]]^2 - 151 xy[[2]]^2],
  1,
  TestID -> "PellReconstruct-d151-identity"
]

(* ============================================ *)
(* PellCompactEncode: uses PellRegulatorInteger  *)
(* ============================================ *)

VerificationTest[
  PellCompactEncode[61],
  11,
  TestID -> "PellCompactEncode-d61"
]

VerificationTest[
  PellCompactEncode[2],
  1,
  TestID -> "PellCompactEncode-d2"
]

(* ============================================ *)
(* Roundtrip: encode then reconstruct            *)
(* ============================================ *)

VerificationTest[
  PellReconstruct[61, PellCompactEncode[61]],
  PellSolve[61],
  TestID -> "Roundtrip-d61"
]

VerificationTest[
  PellReconstruct[109, PellCompactEncode[109]],
  PellSolve[109],
  TestID -> "Roundtrip-d109"
]

EndTestSection[]
