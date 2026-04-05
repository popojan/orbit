(* ================================================================ *)
(* Systematic sequence search in winding matrix                     *)
(* Try: longer sequences, subsample, skip first elements           *)
(* ================================================================ *)

nz = 50; np = 50;
gammas = Table[N[Im[ZetaZero[n]], 15], {n, nz}];
lnP = Table[Log[N[Prime[j], 15]], {j, np}];
w = Table[Floor[gammas[[n]] lnP[[j]] / (2 Pi)], {n, nz}, {j, np}];

(* === Columns: w_{n,j} for fixed j, varying n === *)
Print["=== FindSequenceFunction on COLUMNS (longer, up to 50) ===\n"];
Do[
  col = w[[1;;50, j]];
  Print["Column ", j, " (p=", Prime[j], ", α=γ_n·ln", Prime[j], "/(2π)):"];
  Print["  Values: ", col[[1;;18]]];
  Print["  Diffs:  ", Differences[col][[1;;17]]];

  (* Try full 50 *)
  seq = Quiet[FindSequenceFunction[col]];
  Print["  Full 50: ", If[seq === Null, "NONE", seq]];

  (* Try diffs *)
  diffs = Differences[col];
  seqD = Quiet[FindSequenceFunction[diffs]];
  Print["  Diffs: ", If[seqD === Null, "NONE", seqD]];

  (* Try skipping first 2 *)
  seq2 = Quiet[FindSequenceFunction[col[[3;;50]]]];
  Print["  Skip first 2: ", If[seq2 === Null, "NONE", seq2]];

  (* Three-distance check on fractional parts *)
  fracs = FractionalPart[gammas[[1;;50]] lnP[[j]] / (2 Pi)];
  sortedFracs = Sort[fracs];
  gaps = Join[Differences[sortedFracs], {1 - Last[sortedFracs] + First[sortedFracs]}];
  distinctGaps = Union[Round[gaps, 0.0001]];
  Print["  Fractional parts: ", Length[distinctGaps], " distinct gap sizes",
    If[Length[distinctGaps] <= 3, " ✓ (three-distance!)", ""]];
  Print["  Gap sizes: ", NumberForm[#, {4, 3}] & /@ distinctGaps[[1;;Min[5, Length[distinctGaps]]]]];
  Print[""],
{j, {1, 2, 3, 5, 10}}];

(* === Rows: w_{n,j} for fixed n, varying j === *)
Print["=== FindSequenceFunction on ROWS ===\n"];
Do[
  row = w[[n, 1;;50]];
  Print["Row ", n, " (γ_", n, "=", NumberForm[gammas[[n]], {5, 1}], "):"];
  Print["  Values: ", row[[1;;18]]];
  diffs = Differences[row];
  Print["  Diffs:  ", diffs[[1;;17]]];

  seq = Quiet[FindSequenceFunction[row]];
  Print["  Full: ", If[seq === Null, "NONE", seq]];

  seqD = Quiet[FindSequenceFunction[diffs]];
  Print["  Diffs: ", If[seqD === Null, "NONE", seqD]];
  Print[""],
{n, {1, 2, 3, 5, 10}}];

(* === Diagonals === *)
Print["=== FindSequenceFunction on DIAGONALS ===\n"];
mainDiag = Table[w[[k, k]], {k, 50}];
Print["Main diagonal (50 terms): ", mainDiag[[1;;18]]];
Print["  Diffs: ", Differences[mainDiag][[1;;17]]];
seq = Quiet[FindSequenceFunction[mainDiag]];
Print["  Full: ", If[seq === Null, "NONE", seq]];
seqD = Quiet[FindSequenceFunction[Differences[mainDiag]]];
Print["  Diffs: ", If[seqD === Null, "NONE", seqD]];

(* Sub-diag *)
Print["\nSub-diagonal w_{n, n+1} (49 terms): "];
subDiag = Table[w[[k, k + 1]], {k, 49}];
Print[subDiag[[1;;18]]];
seq = Quiet[FindSequenceFunction[subDiag]];
Print["  Full: ", If[seq === Null, "NONE", seq]];

(* === Every k-th element === *)
Print["\n=== Subsample: every 2nd, 3rd element of column 1 ===\n"];
col1 = w[[1;;50, 1]];
Print["Col 1, every 2nd (odd n):  ", col1[[1;;50;;2]]];
Print["Col 1, every 2nd (even n): ", col1[[2;;50;;2]]];
seq2a = Quiet[FindSequenceFunction[col1[[1;;50;;2]]]];
seq2b = Quiet[FindSequenceFunction[col1[[2;;50;;2]]]];
Print["  Odd: ", If[seq2a === Null, "NONE", seq2a]];
Print["  Even: ", If[seq2b === Null, "NONE", seq2b]];

Print["\nCol 1, every 3rd: ", col1[[1;;49;;3]]];
seq3 = Quiet[FindSequenceFunction[col1[[1;;49;;3]]]];
Print["  Every 3rd: ", If[seq3 === Null, "NONE", seq3]];
