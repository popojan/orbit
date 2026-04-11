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

(* ============================================ *)
(* BeattyBallotCount: paths under Beatty staircase *)
(* ============================================ *)

(* Convergent hits — should equal ballot numbers *)
VerificationTest[
  BeattyBallotCount[Sqrt[7], 8],
  Binomial[8 + 3 - 1, 3] / 8, (* = 15, convergent 8/3 *)
  TestID -> "BeattyBallotCount-sqrt7-conv8"
]

VerificationTest[
  BeattyBallotCount[Pi, 22],
  Binomial[22 + 7 - 1, 7] / 22, (* = 53820, convergent 22/7 *)
  TestID -> "BeattyBallotCount-pi-conv22"
]

VerificationTest[
  BeattyBallotCount[GoldenRatio, 8],
  Binomial[8 + 5 - 1, 5] / 8, (* = 99, shadow: 8/5 convergent, S(8)=4, B(8,5)=99 *)
  SameTest -> Equal,
  TestID -> "BeattyBallotCount-phi-conv8"
]

(* Shadow hits — DP = B(p, S(p)+1) *)
VerificationTest[
  BeattyBallotCount[Sqrt[7], 5],
  Binomial[5 + 2 - 1, 2] / 5, (* = 3, shadow: 5/2 convergent *)
  TestID -> "BeattyBallotCount-sqrt7-shadow5"
]

(* Non-convergent — NOT a ballot number *)
VerificationTest[
  BeattyBallotCount[Pi, 9],
  15, (* direct DP value, not B(9,2)=5 nor B(9,3)=55/3 *)
  TestID -> "BeattyBallotCount-pi-nonconv9"
]

(* Explicit target form *)
VerificationTest[
  BeattyBallotCount[Sqrt[7], {8, 3}],
  BeattyBallotCount[Sqrt[7], 8],
  TestID -> "BeattyBallotCount-explicit-target"
]

(* Trivial case *)
VerificationTest[
  BeattyBallotCount[Pi, 1],
  1,
  TestID -> "BeattyBallotCount-trivial"
]

(* Agrees with PellBallotCount at convergent for alpha = Sqrt[d] *)
VerificationTest[
  BeattyBallotCount[Sqrt[2], 3],
  PellBallotCount[2, 3], (* both = 2 = C_2 *)
  TestID -> "BeattyBallotCount-agrees-PellBallot-d2"
]

(* Sequence form: All counts in single DP pass *)
VerificationTest[
  BeattyBallotCount[Pi, All, 5],
  Table[BeattyBallotCount[Pi, k], {k, 1, 5}],
  TestID -> "BeattyBallotCount-All-pi-5"
]

VerificationTest[
  BeattyBallotCount[Sqrt[7], All, 8],
  Table[BeattyBallotCount[Sqrt[7], k], {k, 1, 8}],
  TestID -> "BeattyBallotCount-All-sqrt7-8"
]

VerificationTest[
  BeattyBallotCount[GoldenRatio, All, 1],
  {1},
  TestID -> "BeattyBallotCount-All-trivial"
]

(* BeattyBallotCount[alpha, All, {n, m}]: fixed-height row *)

(* entry at convergent column must match the scalar form *)
VerificationTest[
  BeattyBallotCount[Pi, All, {22, 7}][[22]],
  BeattyBallotCount[Pi, 22],
  TestID -> "BeattyBallotCount-All-nm-pi-convergent"
]

(* leading entries where Floor[x/Pi] < 7 must be zero *)
VerificationTest[
  Take[BeattyBallotCount[Pi, All, {22, 7}], 21],
  Table[0, {21}],
  TestID -> "BeattyBallotCount-All-nm-pi-zeros"
]

(* row at height 0 is all ones *)
VerificationTest[
  BeattyBallotCount[Pi, All, {5, 0}],
  {1, 1, 1, 1, 1},
  TestID -> "BeattyBallotCount-All-nm-height0"
]

(* consistency: row at height S(n) must match All-n form *)
VerificationTest[
  BeattyBallotCount[Sqrt[7], All, {8, Floor[8/Sqrt[7]]}][[8]],
  BeattyBallotCount[Sqrt[7], 8],
  TestID -> "BeattyBallotCount-All-nm-sqrt7-conv8"
]

(* ============================================ *)
(* BeattyBallotQ                                *)
(* ============================================ *)

VerificationTest[
  BeattyBallotQ[Pi, 22],
  True,
  TestID -> "BeattyBallotQ-pi-conv22-True"
]

VerificationTest[
  BeattyBallotQ[Pi, 9],
  False,
  TestID -> "BeattyBallotQ-pi-nonconv9-False"
]

VerificationTest[
  BeattyBallotQ[Pi, 25],
  True, (* semi-convergent *)
  TestID -> "BeattyBallotQ-pi-semiconv25-True"
]

VerificationTest[
  BeattyBallotQ[Sqrt[7], 5],
  True, (* shadow convergent *)
  TestID -> "BeattyBallotQ-sqrt7-shadow5-True"
]

VerificationTest[
  BeattyBallotQ[Sqrt[7], 6],
  False,
  TestID -> "BeattyBallotQ-sqrt7-nonconv6-False"
]

EndTestSection[]
