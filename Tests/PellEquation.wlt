BeginTestSection["PellEquation"]

(* ============================================ *)
(* PellSolve: known values                      *)
(* ============================================ *)

VerificationTest[
  PellSolve[2],
  {3, 2},
  TestID -> "PellSolve-d2"
]

VerificationTest[
  PellSolve[3],
  {2, 1},
  TestID -> "PellSolve-d3"
]

VerificationTest[
  PellSolve[5],
  {9, 4},
  TestID -> "PellSolve-d5"
]

VerificationTest[
  PellSolve[7],
  {8, 3},
  TestID -> "PellSolve-d7"
]

VerificationTest[
  PellSolve[13],
  {649, 180},
  TestID -> "PellSolve-d13"
]

VerificationTest[
  PellSolve[61],
  {1766319049, 226153980},
  TestID -> "PellSolve-d61"
]

(* ============================================ *)
(* PellSolve: batch identity x^2 - d y^2 = 1   *)
(* ============================================ *)

VerificationTest[
  AllTrue[
    Select[Range[2, 100], !IntegerQ[Sqrt[#]] &],
    Function[d, Module[{xy = PellSolve[d]},
      xy[[1]]^2 - d xy[[2]]^2 == 1]]],
  True,
  TestID -> "PellSolve-batch-identity-100"
]

(* ============================================ *)
(* PellSolution: backward compatibility          *)
(* ============================================ *)

VerificationTest[
  {x, y} /. PellSolution[2],
  {3, 2},
  TestID -> "PellSolution-compat-d2"
]

VerificationTest[
  {x, y} /. PellSolution[5],
  {9, 4},
  TestID -> "PellSolution-compat-d5"
]

(* ============================================ *)
(* PellRegulator: reference values from pellreg2 *)
(* ============================================ *)

VerificationTest[
  Abs[PellRegulator[2]["R"] - 0.88137358701954`14] < 10^-10,
  True,
  TestID -> "PellRegulator-d2"
]

VerificationTest[
  Abs[PellRegulator[61]["R"] - 10.99265538265931`14] < 10^-10,
  True,
  TestID -> "PellRegulator-d61"
]

VerificationTest[
  Abs[PellRegulator[199]["R"] - 24.20550213882065`14] < 10^-10,
  True,
  TestID -> "PellRegulator-d199"
]

(* PARI convention: norm -1 cases return R, not 2R *)
VerificationTest[
  Abs[PellRegulator[5]["R"] - 1.44363547517881`14] < 10^-10,
  True,
  TestID -> "PellRegulator-d5-norm-minus1"
]

(* ============================================ *)
(* PellRegulatorInteger: known Round[R]          *)
(* ============================================ *)

VerificationTest[
  PellRegulatorInteger[61]["R"],
  11,
  TestID -> "PellRegulatorInteger-d61"
]

VerificationTest[
  PellRegulatorInteger[2]["R"],
  1,
  TestID -> "PellRegulatorInteger-d2"
]

(* ============================================ *)
(* PellFundamentalExtract                        *)
(* ============================================ *)

(* (3,2) is already fundamental for d=2 *)
VerificationTest[
  PellFundamentalExtract[3, 2, 2],
  {3, 2},
  TestID -> "PellFundExtract-d2-fundamental"
]

(* (x,y)^2 for d=2: (3+2√2)^2 = 17+12√2, should extract {3,2} *)
VerificationTest[
  PellFundamentalExtract[17, 12, 2],
  {3, 2},
  TestID -> "PellFundExtract-d2-squared"
]

(* ============================================ *)
(* PellBallotCount: lattice paths above hyperbola *)
(* ============================================ *)

VerificationTest[
  PellBallotCount[2, {3, 2}],
  2,
  TestID -> "PellBallotCount-d2-Pell"
]

VerificationTest[
  PellBallotCount[3, {2, 1}],
  1,
  TestID -> "PellBallotCount-d3-Pell"
]

VerificationTest[
  PellBallotCount[5, {9, 4}],
  55,
  TestID -> "PellBallotCount-d5-Pell"
]

VerificationTest[
  PellBallotCount[7, {8, 3}],
  15,
  TestID -> "PellBallotCount-d7-Pell"
]

(* Ballot formula: count = Binomial[x+y-1, y] / x *)
VerificationTest[
  PellBallotCount[10, {19, 6}],
  Binomial[24, 6] / 19,
  TestID -> "PellBallotCount-d10-ballot-formula"
]

(* ============================================ *)
(* PellBallotQ: CF path detection               *)
(* ============================================ *)

VerificationTest[
  PellBallotQ[2, {3, 2}],
  True,
  TestID -> "PellBallotQ-d2-Pell-True"
]

VerificationTest[
  PellBallotQ[13, {4, 1}],
  True,
  TestID -> "PellBallotQ-d13-convergent-True"
]

VerificationTest[
  PellBallotQ[13, {5, 1}],
  False,
  TestID -> "PellBallotQ-d13-nonCF-False"
]

VerificationTest[
  PellBallotQ[13, {29, 8}],
  True,
  TestID -> "PellBallotQ-d13-semiconvergent-True"
]

EndTestSection[]
