(* ================================================================ *)
(* Winding matrix: differences, diagonals, sequence recognition     *)
(* Looking for patterns in the integer structure                    *)
(* ================================================================ *)

nz = 30; np = 30;
gammas = Table[N[Im[ZetaZero[n]], 15], {n, nz}];
lnP = Table[Log[N[Prime[j], 15]], {j, np}];
w = Table[Floor[gammas[[n]] lnP[[j]] / (2 Pi)], {n, nz}, {j, np}];

Print["=== Winding matrix ", nz, "×", np, " ===\n"];
Print["Corner (8×8):"];
Print[MatrixForm[w[[1;;8, 1;;8]]]];

(* === Row differences: Δ_n w = w_{n+1} - w_n === *)
Print["\n=== Row differences (consecutive zeros, same prime) ===\n"];
rowDiffs = Table[w[[n + 1]] - w[[n]], {n, nz - 1}];
Print["Δw (first 8 rows, 8 cols):"];
Print[MatrixForm[rowDiffs[[1;;8, 1;;8]]]];

Print["\nRow diff values (unique per row):"];
Do[Print["  Δ_", n, ": ", Union[rowDiffs[[n, 1;;Min[15,np]]]]], {n, 8}];

(* === Column differences: Δ_p w = w_{n,p_{j+1}} - w_{n,p_j} === *)
Print["\n=== Column differences (consecutive primes, same zero) ===\n"];
colDiffs = Table[w[[n, j + 1]] - w[[n, j]], {n, nz}, {j, np - 1}];
Print["Δw_col (first 8 rows, 8 cols):"];
Print[MatrixForm[colDiffs[[1;;8, 1;;8]]]];

(* === Diagonals === *)
Print["\n=== Main diagonal and anti-diagonal ===\n"];
mainDiag = Table[w[[k, k]], {k, Min[nz, np]}];
Print["Main diagonal: ", mainDiag[[1;;15]]];
Print["Differences: ", Differences[mainDiag][[1;;14]]];

antiDiag = Table[w[[k, Min[nz,np] + 1 - k]], {k, Min[nz, np]}];
Print["Anti-diagonal: ", antiDiag[[1;;15]]];

(* Sub-diagonals *)
Print["\nFirst sub-diagonal (w_{n, n+1}):"];
subDiag1 = Table[w[[k, k + 1]], {k, Min[nz, np] - 1}];
Print[subDiag1[[1;;15]]];

Print["Super-diagonal (w_{n+1, n}):"];
supDiag1 = Table[w[[k + 1, k]], {k, Min[nz, np] - 1}];
Print[supDiag1[[1;;15]]];

(* === FindSequenceFunction on rows, columns, diagonals === *)
Print["\n=== FindSequenceFunction attempts ===\n"];

(* First row: w_{1,j} = Floor[γ₁ ln p_j / (2π)] *)
Print["Row 1: ", w[[1, 1;;15]]];
seq1 = Quiet[FindSequenceFunction[w[[1, 1;;15]]]];
Print["  FindSequenceFunction: ", If[seq1 === Null, "NONE FOUND", seq1]];

(* First column: w_{n,1} = Floor[γ_n ln 2 / (2π)] *)
Print["Col 1 (p=2): ", w[[1;;15, 1]]];
seq2 = Quiet[FindSequenceFunction[w[[1;;15, 1]]]];
Print["  FindSequenceFunction: ", If[seq2 === Null, "NONE FOUND", seq2]];

(* Main diagonal *)
Print["Main diag: ", mainDiag[[1;;15]]];
seq3 = Quiet[FindSequenceFunction[mainDiag[[1;;15]]]];
Print["  FindSequenceFunction: ", If[seq3 === Null, "NONE FOUND", seq3]];

(* Row differences - first row *)
Print["Row diffs (row 1): ", rowDiffs[[1, 1;;15]]];
seq4 = Quiet[FindSequenceFunction[rowDiffs[[1, 1;;15]]]];
Print["  FindSequenceFunction: ", If[seq4 === Null, "NONE FOUND", seq4]];

(* Column of row diffs *)
Print["Row diffs (col 1, p=2): ", rowDiffs[[1;;15, 1]]];
seq5 = Quiet[FindSequenceFunction[rowDiffs[[1;;15, 1]]]];
Print["  FindSequenceFunction: ", If[seq5 === Null, "NONE FOUND", seq5]];

(* === OEIS-friendly: check specific sequences === *)
Print["\n=== Specific sequences ===\n"];
Print["Row 1: ", w[[1, 1;;20]]];
Print["Row 2: ", w[[2, 1;;20]]];
Print["Col 1 (p=2): ", w[[1;;20, 1]]];
Print["Col 2 (p=3): ", w[[1;;20, 2]]];
Print["Main diag: ", mainDiag[[1;;20]]];
Print["Row diffs col 1: ", rowDiffs[[1;;20, 1]]];

(* === Row difference PATTERNS === *)
Print["\n=== Row differences: is Δ_n w_{n,p} = Floor[Δγ_n ln p/(2π)]? ==="];
Print["(Δγ_n = γ_{n+1} - γ_n = zero gap)\n"];
Print["n  | Δγ_n  | Δw_row (p=2,3,5,7)    | Floor[Δγ ln p/(2π)]"];
Do[
  dg = gammas[[n+1]] - gammas[[n]];
  dw = rowDiffs[[n, 1;;4]];
  predicted = Table[Floor[dg lnP[[j]] / (2 Pi)], {j, 4}];
  Print[n, If[n<10," ",""], " | ", NumberForm[dg, {4, 2}],
    " | ", dw, " | ", predicted,
    If[dw == predicted, " ✓", " ✗"]],
{n, 15}];
