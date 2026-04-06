(* ================================================================ *)
(* CONSTRAINT POWER v2: enumerate over COLUMNS (integer 4-tuples)   *)
(* For each choice of k₁<k₂<k₃<k₄, the matrix is determined       *)
(* by the row parameters a_n. Count valid matrices.                 *)
(* ================================================================ *)

gEx = Table[N[Im[ZetaZero[n]], 20], {n, 4}];
lpEx = Table[Log[N[Prime[j], 20]], {j, 4}];
wEx = Table[Floor[gEx[[n]] lpEx[[j]] / (2 Pi)], {n, 4}, {j, 4}];
Print["Exact W: ", wEx];
Print["Exact columns: {2, 3, 5, 7}\n"];

(* === For given integers k₁<k₂<k₃<k₄, find all valid 4×4 matrices === *)
(* ℓⱼ = ln(kⱼ). Row n has w_{nj} = ⌊aₙ·ℓⱼ⌋.                        *)
(* For fixed ℓ, enumerate all ordered 4-tuples of distinct rows.      *)

countForColumns[ks_] := Module[
  {lnk, validRows, nRows, aMax, aStep, count, row, mat,
   foundExact = False},
  lnk = Log[N[ks]];

  (* Find all valid rows: vary a from small to large *)
  (* Row changes at breakpoints a = m/ℓⱼ for integer m *)
  (* Collect all breakpoints, evaluate row at each *)
  aMax = 20.;  (* a_n = γ_n/(2π), γ₄ ≈ 30 → a₄ ≈ 4.8, leave margin *)
  Module[{bps = {}, row0, rows = {}},
    Do[
      Do[bps = Union[bps, {m / lnk[[j]]}], {m, 1, Ceiling[aMax * lnk[[j]]]}],
    {j, 4}];
    bps = Select[Sort[bps], 0 < # <= aMax &];
    (* At midpoint of each interval, compute the row *)
    Do[
      Module[{a = (bps[[i]] + bps[[i + 1]]) / 2},
        row = Table[Floor[a * lnk[[j]]], {j, 4}];
        If[row[[1]] >= 1, AppendTo[rows, row]]],
    {i, Length[bps] - 1}];
    validRows = Union[rows]];

  nRows = Length[validRows];

  (* Count ordered 4-tuples with componentwise monotonicity *)
  count = 0;
  Do[
    If[AllTrue[Range[4], validRows[[b, #]] >= validRows[[a, #]] &],
      Do[
        If[AllTrue[Range[4], validRows[[c, #]] >= validRows[[b, #]] &],
          Do[
            If[AllTrue[Range[4], validRows[[d, #]] >= validRows[[c, #]] &],
              count++;
              mat = {validRows[[a]], validRows[[b]],
                     validRows[[c]], validRows[[d]]};
              If[mat == wEx, foundExact = True]],
          {d, c, nRows}]],
      {c, b, nRows}]],
  {a, 1, nRows}, {b, a, nRows}];

  {nRows, count, foundExact}
]

(* === Systematic enumeration === *)
maxK = 25;  (* upper bound on integers *)

Print["╔═══════════════════════════════════════════════════╗"];
Print["║  Enumerate 4-tuples k₁<k₂<k₃<k₄ of integers     ║"];
Print["║  For each: count valid 4×4 matrices               ║"];
Print["╚═══════════════════════════════════════════════════╝\n"];

(* === Level 0: ALL integers 2..maxK === *)
Print["=== C0: All integer 4-tuples from {2,...,", maxK, "} ==="];
totalMats0 = 0; totalCols0 = 0; exactFound0 = False;
Do[
  {nr, nm, fe} = countForColumns[{k1, k2, k3, k4}];
  totalMats0 += nm; totalCols0++;
  If[fe, exactFound0 = True],
{k1, 2, maxK - 3}, {k2, k1 + 1, maxK - 2},
{k3, k2 + 1, maxK - 1}, {k4, k3 + 1, maxK}];
Print["  Column 4-tuples: ", totalCols0];
Print["  Total matrices:  ", totalMats0];
Print["  Exact W found:   ", exactFound0];

(* === Level 1: k₁=2 (smallest prime must be 2) === *)
Print["\n=== C3: Fix k₁=2 ==="];
totalMats1 = 0; totalCols1 = 0; exactFound1 = False;
Do[
  {nr, nm, fe} = countForColumns[{2, k2, k3, k4}];
  totalMats1 += nm; totalCols1++;
  If[fe, exactFound1 = True],
{k2, 3, maxK - 2}, {k3, k2 + 1, maxK - 1}, {k4, k3 + 1, maxK}];
Print["  Column 4-tuples: ", totalCols1];
Print["  Total matrices:  ", totalMats1];
Print["  Exact W found:   ", exactFound1];

(* === Level 2: k₁=2, rest odd === *)
Print["\n=== C5: k₁=2, k₂,k₃,k₄ odd ==="];
totalMats2 = 0; totalCols2 = 0; exactFound2 = False;
Do[
  {nr, nm, fe} = countForColumns[{2, k2, k3, k4}];
  totalMats2 += nm; totalCols2++;
  If[fe, exactFound2 = True],
{k2, 3, maxK - 2, 2}, {k3, k2 + 2, maxK - 1, 2}, {k4, k3 + 2, maxK, 2}];
Print["  Column 4-tuples: ", totalCols2];
Print["  Total matrices:  ", totalMats2];
Print["  Exact W found:   ", exactFound2];

(* === Level 3: k₁=2, rest odd, self-sieve (not divisible by earlier) === *)
Print["\n=== C7: k₁=2, rest odd + self-sieve ==="];
totalMats3 = 0; totalCols3 = 0; exactFound3 = False;
oddPrimeLike = Select[Range[3, maxK, 2],
  Function[k, !AnyTrue[Range[3, Floor[Sqrt[k]], 2], Mod[k, #] == 0 &]]];
Print["  Sieve survivors (odd, no small factors): ", oddPrimeLike];
Do[
  {nr, nm, fe} = countForColumns[{2, k2, k3, k4}];
  totalMats3 += nm; totalCols3++;
  If[fe, exactFound3 = True],
{k2, oddPrimeLike}, {k3, Select[oddPrimeLike, # > k2 &]},
{k4, Select[oddPrimeLike, # > k3 &]}];
Print["  Column 4-tuples: ", totalCols3];
Print["  Total matrices:  ", totalMats3];
Print["  Exact W found:   ", exactFound3];

(* === Summary === *)
Print["\n╔═══════════════════════════════════╗"];
Print["║         SUMMARY TABLE             ║"];
Print["╠═══════════════════════════════════╣"];
Print["║ Constraint    │ Cols  │ Matrices  ║"];
Print["╠───────────────┼───────┼───────────╣"];
Print["║ C0 all ints   │ ", PaddedForm[totalCols0, 5],
  " │ ", PaddedForm[totalMats0, 9], " ║"];
Print["║ C3 k₁=2       │ ", PaddedForm[totalCols1, 5],
  " │ ", PaddedForm[totalMats1, 9], " ║"];
Print["║ C5 +odd       │ ", PaddedForm[totalCols2, 5],
  " │ ", PaddedForm[totalMats2, 9], " ║"];
Print["║ C7 +sieve     │ ", PaddedForm[totalCols3, 5],
  " │ ", PaddedForm[totalMats3, 9], " ║"];
Print["╚═══════════════╧═══════╧═══════════╝"];
