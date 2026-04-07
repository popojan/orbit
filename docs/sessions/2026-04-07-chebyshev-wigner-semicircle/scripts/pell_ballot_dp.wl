(* Pell-Ballot Conjecture: Dynamic Programming Verification *)
(* Count lattice paths from (1,0) to (x1,y1) staying above x^2 - D*y^2 >= 1 *)
(* Conjecture: count = Binomial[x1+y1-1, y1] / x1 (ballot number) *)

<< Orbit`

(* DP path counter: monotonic lattice paths (right/up unit steps) *)
(* from (1,0) to (x1,y1) visiting only points with u^2 - d*r^2 >= 1 *)
countPathsAboveHyperbola[d_Integer, {x1_Integer, y1_Integer}] := Module[{dp},
  dp = Table[0, {x1}, {y1 + 1}];
  Do[
    Do[
      If[u^2 - d r^2 >= 1,
        dp[[u, r + 1]] =
          If[u == 1 && r == 0, 1, 0] +
          If[u > 1, dp[[u - 1, r + 1]], 0] +
          If[r > 0, dp[[u, r]], 0],
        dp[[u, r + 1]] = 0
      ],
    {r, 0, y1}],
  {u, 1, x1}];
  dp[[x1, y1 + 1]]
]

(* Ballot number = generalized Catalan *)
ballotNumber[x1_, y1_] := Binomial[x1 + y1 - 1, y1] / x1

(* Verify for all non-square D up to maxD *)
verifyPellBallot[maxD_Integer: 50] := Module[{x1, y1, dpCount, ballot, allOK = True},
  Print["D | (x1,y1) | DP count | Ballot | Match"];
  Print["--|----------|----------|--------|------"];
  Do[
    If[!IntegerQ[Sqrt[d]],
      {x1, y1} = PellSolve[d];
      dpCount = countPathsAboveHyperbola[d, {x1, y1}];
      ballot = ballotNumber[x1, y1];
      If[dpCount =!= ballot, allOK = False];
      Print["D=", d, " | (", x1, ",", y1, ") | ", dpCount, " | ", ballot,
            " | ", If[dpCount === ballot, "OK", "FAIL"]]
    ],
  {d, 2, maxD}];
  Print[""];
  Print[If[allOK, "ALL MATCH", "SOME FAILURES"]];
]

(* Run *)
verifyPellBallot[50]
