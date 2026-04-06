(* ================================================================ *)
(* SINGULARITY STRUCTURE ANALYSIS                                  *)
(* For each n: rank defect, condition number, smallest singular    *)
(* value, null space structure at singular k values                 *)
(* ================================================================ *)

Needs["Orbit`"];

nMax = 30;
gList = Table[N[Im[ZetaZero[n]], 20], {n, nMax}];
lpList = Table[Log[N[Prime[j], 20]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

z3 = N[Zeta[3], 20];

(* ================================================================ *)
(* 1. RANK DEFECT at k=1 vs k=ζ(3)                                *)
(* ================================================================ *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  SINGULARITY STRUCTURE                               ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Print["=== Rank defect & condition number ===\n"];
Print["n    k=1              k=ζ(3)            k=11/4             k=2π"];
Print["     rk  det  κ       rk  det  κ        rk  det  κ        rk  det  κ"];
Do[
  kvals = {1, z3, 11/4, N[2 Pi, 20]};
  line = PaddedForm[n, 3];
  Do[
    w = fWM[n, kv];
    d = Det[w];
    rk = MatrixRank[w];
    defect = n - rk;
    svs = SingularValueList[N[w]];
    cond = If[Last[svs] > 0, First[svs]/Last[svs], Infinity];
    smin = Last[svs];
    line = line <> "    " <>
      ToString[PaddedForm[defect, 2]] <> " " <>
      ToString[PaddedForm[d, 5]] <> " " <>
      If[cond === Infinity, " ∞    ",
        ToString[NumberForm[cond, {5, 1}]]],
  {kv, kvals}];
  Print[line],
{n, 3, nMax}];

(* ================================================================ *)
(* 2. MAXIMUM DEFECT: what's the worst rank deficiency?            *)
(* ================================================================ *)
Print["\n=== Maximum rank defect for k=1 ===\n"];
Do[
  w = fWM[n, 1];
  rk = MatrixRank[w];
  defect = n - rk;
  If[defect > 0,
    svs = SingularValueList[N[w]];
    (* How many singular values are < 0.5? *)
    nSmall = Count[svs, _?(# < 0.5 &)];
    Print["  n=", n, ": rank=", rk, ", defect=", defect,
      ", σ_min=", NumberForm[Last[svs], {4, 3}],
      ", #(σ<0.5)=", nSmall]],
{n, 3, nMax}];

(* ================================================================ *)
(* 3. NEAR-SINGULAR at k=ζ(3): smallest singular value             *)
(* How close does ζ(3) get to singularity?                         *)
(* ================================================================ *)
Print["\n=== Smallest singular value at k=ζ(3) ===\n"];
Print["n    σ_min        σ_min/σ_max    |det|"];
Do[
  w = fWM[n, z3];
  svs = SingularValueList[N[w]];
  smin = Last[svs];
  smax = First[svs];
  d = Abs[Det[w]];
  Print[PaddedForm[n, 3], "  ",
    NumberForm[smin, {6, 4}], "    ",
    ScientificForm[smin/smax, 3], "    ",
    d],
{n, 3, nMax}];

(* ================================================================ *)
(* 4. NULL SPACE at k=1 singularities: what row combination = 0?   *)
(* ================================================================ *)
Print["\n=== Null space structure at k=1 singularities ===\n"];
Do[
  w = fWM[n, 1];
  If[Det[w] != 0, Continue[]];
  ns = NullSpace[w];
  If[Length[ns] == 0, Continue[]];
  (* Each null vector tells us which rows are linearly dependent *)
  Do[
    v = ns[[i]];
    (* Normalize so smallest nonzero = 1 *)
    nonzero = Select[Abs[v], # > 0 &];
    If[Length[nonzero] > 0, v = v / Min[nonzero]];
    (* Which rows participate? *)
    active = Select[Range[n], Abs[v[[#]]] > 0 &];
    Print["  n=", n, " null vec #", i, ": rows ", active,
      "  coeffs=", v[[active]]],
  {i, Length[ns]}],
{n, 3, 25}];

(* ================================================================ *)
(* 5. DEFECT LANDSCAPE: for k near ζ(3), where is defect > 0?     *)
(* What's the maximum defect across ALL k?                          *)
(* ================================================================ *)
Print["\n=== Defect landscape near ζ(3) for n=10 ===\n"];
n = 10;
products = Table[gList[[i]] lpList[[j]] / (2 Pi), {i, n}, {j, n}];
bps = {};
Do[
  p = products[[i, j]];
  mMin = Ceiling[(z3 - 0.05) * p];
  mMax = Floor[(z3 + 0.05) * p];
  Do[AppendTo[bps, m / p], {m, mMin, mMax}],
{i, n}, {j, n}];
bps = Union[bps];
bps = Select[bps, z3 - 0.05 < # < z3 + 0.05 &];

maxDefect = 0;
defectCounts = <|0 -> 0, 1 -> 0, 2 -> 0, 3 -> 0|>;
prevK = z3 - 0.05;
Do[
  midK = (prevK + bp) / 2;
  w = fWM[n, midK];
  rk = MatrixRank[w];
  def = n - rk;
  maxDefect = Max[maxDefect, def];
  defectCounts[def] = Lookup[defectCounts, def, 0] + 1;
  If[def >= 2,
    Print["  DEFECT ", def, " at k≈", NumberForm[midK, {10, 8}],
      "  Δk=", NumberForm[midK - z3, {6, 6}]]];
  prevK = bp,
{bp, bps}];
Print["Max defect for n=10: ", maxDefect];
Print["Defect distribution: ", Normal[defectCounts]];
Print["Total intervals: ", Length[bps] + 1];
