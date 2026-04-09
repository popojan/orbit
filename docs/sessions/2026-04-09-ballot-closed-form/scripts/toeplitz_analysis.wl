(* Symbolic analysis of M: Toeplitz part vs correction *)
(* Goal: decompose M[j,s] = C(p1-1+j-s, j-s) - Delta[j,s] *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

(* ===== Pi: w=3, a1=7, p1=22, q1=7 ===== *)
Print["===== Pi: [3; 7, ...] ====="];
M = blockTransfer[8, {3, 3, 3, 3, 3, 3, 4}];

(* Toeplitz part: C(p1-1+j-s, j-s) where p1=22 *)
p1 = 22;
MToep = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 14}, {s, 0, 7}];

Delta = MToep - M;
Print["Correction Delta = MToep - M:"];
Do[
  row = Delta[[j + 1]];
  If[row =!= Table[0, 8], Print["  j=", j, ": ", row]],
  {j, 0, 14}];
Print[""];

(* Check: what ARE those correction values? *)
Print["=== Correction at j=9 (first nonzero): ==="];
Print["Delta[9, s] = ", Delta[[10]]];
Print[""];

(* Are they binomials? C(11-s, something)? *)
Print["=== Checking if Delta[j,s] = C(a, j-s-q1-1) * something ==="];
Do[
  row = Delta[[j + 1]];
  If[row =!= Table[0, 8],
    Print["j=", j, " Delta=", row];
    (* Check ratios between consecutive nonzero entries *)
    nonzero = Select[Table[{s, row[[s + 1]]}, {s, 0, 7}], #[[2]] != 0 &];
    If[Length[nonzero] > 1,
      ratios = Table[nonzero[[i + 1, 2]]/nonzero[[i, 2]], {i, Length[nonzero] - 1}];
      Print["  ratios: ", ratios // N]
    ]
  ],
  {j, 8, 14}];
Print[""];

(* === Try different interpretation: Delta[j,s] as function of j and s separately === *)
Print["=== Delta[j,0] (first column correction) ==="];
Do[Print["j=", j, " Delta=", Delta[[j + 1, 1]]], {j, 8, 14}];
Print[""];

Print["=== Delta[j, 7] (last column correction) ==="];
Do[Print["j=", j, " Delta=", Delta[[j + 1, 8]]], {j, 8, 14}];
Print[""];

(* === Is Delta itself a product of two vectors (rank-1)? === *)
Print["=== Rank of correction matrix ==="];
DeltaSub = Delta[[10 ;; 15, 1 ;; 8]]; (* rows 9-14, cols 0-7 *)
Print["Delta submatrix (rows 9-14):"];
Do[Print["  ", DeltaSub[[i]]], {i, 1, 6}];
Print["Rank: ", MatrixRank[DeltaSub]];
Print[""];

(* ===== Now do the same for sqrt(5): w=2, a1=4, pattern={2,2,2,3} ===== *)
Print["===== sqrt(5): [2; 4, ...] ====="];
M5 = blockTransfer[5, {2, 2, 2, 3}];
p1s5 = 9;
MToep5 = Table[Binomial[p1s5 - 1 + j - s, j - s], {j, 0, Dimensions[M5][[1]] - 1}, {s, 0, 4}];
Delta5 = MToep5 - M5;
Print["Correction Delta (sqrt5):"];
Do[
  row = Delta5[[j + 1]];
  If[row =!= Table[0, 5], Print["  j=", j, ": ", row]],
  {j, 0, Dimensions[M5][[1]] - 1}];
Print[""];
DeltaSub5 = Delta5[[Select[Range[Dimensions[M5][[1]]], Delta5[[#]] =!= Table[0, 5] &]]];
Print["Rank of correction (sqrt5): ", If[Length[DeltaSub5] > 0, MatrixRank[DeltaSub5], 0]];
Print[""];

(* ===== sqrt(2): w=1, a1=2, pattern={1,1,2} ===== *)
Print["===== sqrt(2): [1; 2, ...] ====="];
M2 = blockTransfer[3, {1, 1, 2}];
p1s2 = 3;
MToep2 = Table[Binomial[p1s2 - 1 + j - s, j - s], {j, 0, Dimensions[M2][[1]] - 1}, {s, 0, 2}];
Delta2 = MToep2 - M2;
Print["Correction Delta (sqrt2):"];
Do[
  row = Delta2[[j + 1]];
  If[row =!= Table[0, 3], Print["  j=", j, ": ", row]],
  {j, 0, Dimensions[M2][[1]] - 1}];
Print[""];

(* ===== e: [2; 1, 2, 1, ...], try first block ===== *)
Print["===== e: [2; 1, 2, 1, ...] ====="];
(* first block: a1=1, pattern = {2,3} but wait... *)
(* For e = [2;1,2,1,1,4,...] the staircase has w=2, first convergent 3/1 *)
(* Between positions 2 and 3: pattern is {3} (single stair of width w+1=3) *)
(* Actually a1=1 means only 1 stair in the block, width w+1=3 *)
Me = blockTransfer[2, {3}];
p1e = 3;
MToepe = Table[Binomial[p1e - 1 + j - s, j - s], {j, 0, Dimensions[Me][[1]] - 1}, {s, 0, 1}];
Deltae = MToepe - Me;
Print["Correction Delta (e):"];
Do[
  row = Deltae[[j + 1]];
  If[row =!= Table[0, 2], Print["  j=", j, ": ", row]],
  {j, 0, Dimensions[Me][[1]] - 1}];
Print[""];

(* ===== GENERAL (w, a1): Symbolic block transfer ===== *)
Print["===== General (w, a1) ====="];
Print["Generating block transfer for general w, a1..."];
(* Pattern: a1-1 stairs of width w, then 1 stair of width w+1 *)
(* = {w, w, ..., w, w+1} with a1 entries *)
generalBlock[w_, a1_, dim_] := blockTransfer[dim, Append[Table[w, a1 - 1], w + 1]]

(* Try small cases *)
Do[
  M = generalBlock[w, a1, a1 + 1];
  p1 = w * a1 + 1;
  MToep = Table[Binomial[p1 - 1 + j - s, j - s],
    {j, 0, Dimensions[M][[1]] - 1}, {s, 0, a1}];
  Delta = MToep - M;
  nonzeroRows = Select[Range[Dimensions[M][[1]]],
    Delta[[#]] =!= Table[0, a1 + 1] &];
  If[Length[nonzeroRows] > 0,
    Print["w=", w, " a1=", a1, " p1=", p1,
      " first correction at row ", nonzeroRows[[1]] - 1,
      " (should be ", a1 + 2, ")"];
    Print["  Delta[", nonzeroRows[[1]] - 1, "] = ", Delta[[nonzeroRows[[1]]]]];
  ,
    Print["w=", w, " a1=", a1, " p1=", p1, " — no correction (2-term CF)"];
  ],
  {w, 1, 4}, {a1, 1, 5}];
