BeginTestSection["PellChebyshevSolve"]

(* ============ BASIC R-D CASES (m=1) ============ *)

VerificationTest[
  res = PellChebyshevSolve[2];
  {res["x"], res["y"], res["m"]},
  {3, 2, 1},
  TestID -> "PellCheb-n2-RD"
]

VerificationTest[
  res = PellChebyshevSolve[3];
  {res["x"], res["y"], res["m"]},
  {2, 1, 1},
  TestID -> "PellCheb-n3-RD"
]

VerificationTest[
  res = PellChebyshevSolve[5];
  {res["x"], res["y"], res["m"]},
  {9, 4, 1},
  TestID -> "PellCheb-n5-RD"
]

VerificationTest[
  res = PellChebyshevSolve[8];
  {res["x"], res["y"], res["m"]},
  {3, 1, 1},
  TestID -> "PellCheb-n8-RD"
]

(* ============ PERFECT SQUARE => $Failed ============ *)

VerificationTest[
  PellChebyshevSolve[4],
  $Failed,
  TestID -> "PellCheb-square-4"
]

VerificationTest[
  PellChebyshevSolve[9],
  $Failed,
  TestID -> "PellCheb-square-9"
]

(* ============ SOLUTION IDENTITY x^2 - n y^2 = 1 ============ *)

VerificationTest[
  res = PellChebyshevSolve[7];
  res["x"]^2 - 7 res["y"]^2,
  1,
  TestID -> "PellCheb-n7-identity"
]

VerificationTest[
  res = PellChebyshevSolve[13];
  res["x"]^2 - 13 res["y"]^2,
  1,
  TestID -> "PellCheb-n13-identity"
]

(* ============ LARGE m CASES (rank-of-apparition) ============ *)

VerificationTest[
  res = PellChebyshevSolve[3125];
  {res["x"]^2 - 3125 res["y"]^2, res["m"]},
  {1, 15},
  TestID -> "PellCheb-n3125-m15"
]

VerificationTest[
  res = PellChebyshevSolve[2197];
  {res["x"]^2 - 2197 res["y"]^2, res["m"]},
  {1, 39},
  TestID -> "PellCheb-n2197-m39"
]

(* ============ USER'S COMPOSITE CASE ============ *)

VerificationTest[
  n = (2^2 * 3^2 * 7^2 * 11)^2 + 2^3 * 3^4 * 7^4;
  res = PellChebyshevSolve[n];
  res["x"]^2 - n * res["y"]^2,
  1,
  TestID -> "PellCheb-composite-378071064"
]

(* ============ ABOVE-SQRT SEED (n = a^2 - r) ============ *)

VerificationTest[
  res = PellChebyshevSolve[82^2 - 8];
  {res["x"]^2 - 6716 res["y"]^2, res["m"], res["r"]},
  {1, 2, -8},
  TestID -> "PellCheb-above-sqrt-6716"
]

VerificationTest[
  res = PellChebyshevSolve[100^2 - 4];
  res["x"]^2 - 9996 res["y"]^2,
  1,
  TestID -> "PellCheb-above-sqrt-9996"
]

(* ============ RATIONAL n ============ *)

VerificationTest[
  res = PellChebyshevSolve[3/2];
  {res["x"]^2 - 3/2 * res["y"]^2, res["m"]},
  {1, 1},
  TestID -> "PellCheb-rational-3over2"
]

VerificationTest[
  res = PellChebyshevSolve[11/7];
  res["x"]^2 - 11/7 * res["y"]^2,
  1,
  TestID -> "PellCheb-rational-11over7"
]

VerificationTest[
  res = PellChebyshevSolve[2/3];
  {res["x"]^2 - 2/3 * res["y"]^2, res["x"], res["y"]},
  {1, 5, 6},
  TestID -> "PellCheb-rational-2over3-subunit"
]

(* ============ BATCH: x^2 - n y^2 = 1 for all solvable n <= 100 ============ *)

VerificationTest[
  failures = {};
  Do[
    If[IntegerQ[Sqrt[nn]], Continue[]];
    res = PellChebyshevSolve[nn];
    If[res =!= $Failed && res["x"]^2 - nn res["y"]^2 =!= 1,
      AppendTo[failures, nn]
    ],
  {nn, 2, 100}];
  failures,
  {},
  TestID -> "PellCheb-batch-identity-100"
]

EndTestSection[]
