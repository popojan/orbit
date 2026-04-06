(* ================================================================ *)
(* WHY ζ(3) AND NOT ζ(2)?                                         *)
(* Compare det trajectories at k=ζ(2), ζ(3), ζ(4) for same n     *)
(* Focus on n where ζ(2) first fails (n=9)                        *)
(*                                                                  *)
(* Also: Euler product connection.                                  *)
(* ζ(s) · ln(p_j) = ln(p_j) · p_j^s/(p_j^s - 1) · Π_{q≠p_j}... *)
(* The per-column correction 1/(1-p_j^{-s}) depends on s.         *)
(* ================================================================ *)

nMax = 20;
gList = Table[N[Im[ZetaZero[n]], 25], {n, nMax}];
lpList = Table[Log[N[Prime[j], 25]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

z2 = N[Zeta[2], 25];
z3 = N[Zeta[3], 25];
z4 = N[Zeta[4], 25];

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  WHY ζ(3) NOT ζ(2)? Comparing failure modes          ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

(* ================================================================ *)
(* 1. WHERE does each ζ(s) first fail?                              *)
(* ================================================================ *)
Print["=== First singularity for each ζ(s) ===\n"];
Do[
  zs = N[Zeta[s], 25];
  firstFail = None;
  Do[
    If[Det[fWM[n, zs]] == 0,
      firstFail = n; Break[]],
  {n, 3, 50}];
  Print["ζ(", s, ") = ", NumberForm[zs, {8, 5}],
    "  first singular at: ", If[firstFail === None, "NEVER (to n=50)", "n=" <> ToString[firstFail]]],
{s, 2, 7}];

(* ================================================================ *)
(* 2. At n=9 (where ζ(2) fails): what kills ζ(2) but saves ζ(3)?  *)
(* ================================================================ *)
n = 9;
Print["\n=== Autopsy at n=", n, " ===\n"];
Do[
  {zs, label} = entry;
  w = fWM[n, zs];
  d = Det[w];
  rk = MatrixRank[w];
  svs = SingularValueList[N[w]];
  Print[label, ": det=", d, "  rank=", rk,
    "  σ_min=", NumberForm[Last[svs], {6, 4}]];
  If[d == 0,
    ns = NullSpace[w];
    Do[
      v = ns[[i]];
      active = Select[Range[n], v[[#]] != 0 &];
      Print["  null vec: rows ", active, " coeffs ", v[[active]]],
    {i, Length[ns]}]],
{{z2, "ζ(2)"}, {z3, "ζ(3)"}, {z4, "ζ(4)"}}];

(* Compare the actual matrices entry by entry *)
Print["\nW^(ζ(2)) - W^(ζ(3)) at n=", n, ":"];
w2 = fWM[n, z2]; w3 = fWM[n, z3];
diff = w2 - w3;
Print[MatrixForm[diff]];

(* ================================================================ *)
(* 3. EULER PRODUCT perspective                                     *)
(* ζ(s) · ln(p_j) contains factor p_j^s/(p_j^s - 1) per column   *)
(* This is a column-dependent scaling.                              *)
(* ================================================================ *)
Print["\n=== Euler product per-column factor: p^s/(p^s - 1) ===\n"];
Print["j   p_j   s=2         s=3         s=4"];
Do[
  pj = Prime[j];
  f2 = N[pj^2/(pj^2 - 1)];
  f3 = N[pj^3/(pj^3 - 1)];
  f4 = N[pj^4/(pj^4 - 1)];
  Print[PaddedForm[j, 3], "  ", PaddedForm[pj, 4], "  ",
    NumberForm[f2, {6, 4}], "    ",
    NumberForm[f3, {6, 4}], "    ",
    NumberForm[f4, {6, 4}]],
{j, 10}];

(* Column correction: how much does ζ(s) distort each column from "pure" rank-1? *)
Print["\n=== Column distortion: ζ(s)·ln(p) vs C·ln(p) ==="];
Print["If ζ(s) were just a constant C, columns would scale as C·ln(p) (rank 1)."];
Print["The Euler product adds per-column correction ε_j = ln(p_j)·[1/(1-p_j^{-s}) - 1]\n"];

Do[
  Print["s=", s, ":");
  zs = N[Zeta[s], 25];
  corrections = Table[
    pj = Prime[j];
    eps = lpList[[j]] * (1/(1 - pj^(-s)) - 1);
    {j, Prime[j], eps, eps / (zs * lpList[[j]])},  (* relative correction *)
  {j, 10}];
  Print["  j  p   ε_j (absolute)      ε_j/entry (relative)"];
  Do[
    {jj, pj, eps, rel} = corrections[[i]];
    Print["  ", jj, "  ", pj, "  ",
      ScientificForm[eps, 3], "    ",
      ScientificForm[rel, 3]],
  {i, 10}];
  (* Total relative correction *)
  totalRel = Total[corrections[[All, 4]]^2] // Sqrt;
  Print["  RMS relative correction: ", ScientificForm[totalRel, 3]];
  Print[""],
{s, {2, 3, 4}}];

(* ================================================================ *)
(* 4. KEY TEST: does removing the Euler product correction help?    *)
(* Use k·ln(p_j) with UNIFORM k instead of ζ(s)·ln(p_j)          *)
(* Compare: k_uniform = ζ(3) vs k_per_column = ζ(3)·(1-p_j^-3)   *)
(* ================================================================ *)
Print["=== Test: strip Euler correction ==="];
Print["W'_{nj} = Floor[C · γ_n · ln(p_j) · (1 - p_j^{-s}) / (2π)]"];
Print["This removes the per-column Euler factor.\n"];

Do[
  Print["s=", s, "  C=ζ(", s, ")=", NumberForm[N[Zeta[s]], {8, 5}]];
  zs = N[Zeta[s], 25];
  singWithEuler = {};
  singWithout = {};
  Do[
    (* With Euler product (standard) *)
    w1 = fWM[nn, zs];
    d1 = Det[w1];
    (* Without: strip per-column factor *)
    w2 = Table[
      Floor[zs * gList[[i]] * lpList[[j]] * (1 - Prime[j]^(-s)) / (2 Pi)],
    {i, nn}, {j, nn}];
    d2 = Det[w2];
    If[d1 == 0, AppendTo[singWithEuler, nn]];
    If[d2 == 0, AppendTo[singWithout, nn]],
  {nn, 3, 30}];
  Print["  With Euler product: sing at ", singWithEuler];
  Print["  Without (stripped): sing at ", singWithout];
  Print[""],
{s, {2, 3, 4, 5}}];
