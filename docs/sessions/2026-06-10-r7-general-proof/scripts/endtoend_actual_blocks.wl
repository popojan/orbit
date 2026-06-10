(* End-to-end: actual level-1 block transfer Delta vs R7 with
   d0 = input dimension (= q0 + q1 - 1 = a1 for level 1), depth d = j - d0,
   across several irrationals. Also re-derive correct Example 4.3 values. *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat]

vLin[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]
r7[d0_, w_, p1_, d_, s_] := Sum[
  vLin[p1 - w m, w, d - m + 1] * Binomial[d0 - 2 + m (w + 1) - s, m w - 1],
  {m, 1, d + 1}]

checkAlpha[alpha_, label_] := Module[
  {cf, w, a1, p1, q1, d0, mBlk, dims, tFree, delta, ok},
  cf = ContinuedFraction[alpha, 3];
  w = cf[[1]]; a1 = cf[[2]];
  p1 = w a1 + 1; q1 = a1; d0 = q1; (* q0 + q1 - 1 = 1 + a1 - 1 *)
  mBlk = blockTransferActual[d0, alpha, 0, p1];
  dims = Dimensions[mBlk];
  tFree = Table[If[j >= s, Binomial[p1 - 1 + j - s, j - s], 0],
    {j, 0, dims[[1]] - 1}, {s, 0, dims[[2]] - 1}];
  delta = tFree - mBlk;
  (* rows below d0 must be zero; rows d0+d must equal r7 *)
  ok = And @@ Join[
    Table[delta[[j + 1]] === Table[0, {dims[[2]]}], {j, 0, d0 - 1}],
    Flatten @ Table[delta[[d0 + d + 1, s + 1]] === r7[d0, w, p1, d, s],
      {d, 0, q1 - 1}, {s, 0, dims[[2]] - 1}]];
  Print[label, ": w=", w, " a1=", a1, " p1=", p1, " d0=", d0,
    "  zero rows 0..", d0 - 1, ", R7 rows ", d0, "..", d0 + q1 - 1, ": ",
    If[ok, "MATCH", "MISMATCH"]];
  ok]

Print["=== Actual block Delta vs R7 (d0 = input dim, depth = j - d0) ==="];
allOk = And @@ {
  checkAlpha[Sqrt[2], "sqrt2 "],
  checkAlpha[Sqrt[3], "sqrt3 "],
  checkAlpha[Sqrt[5], "sqrt5 "],
  checkAlpha[Sqrt[7], "sqrt7 "],
  checkAlpha[GoldenRatio, "phi   "],
  checkAlpha[Sqrt[37], "sqrt37"],
  checkAlpha[E, "e     "],
  checkAlpha[1 + Pi/10, "1+pi/10"]};
Print["ALL: ", If[allOk, "MATCH", "MISMATCH"]];
Print[""];

(* Corrected Example 4.3 values for the paper (sqrt5, d0=4) *)
Print["=== Corrected Example values (sqrt5, w=2, p1=9, q1=4, d0=4) ==="];
Do[
  Print["Delta[", 4 + d, ", s] = ",
    Sum[vLin[9 - 2 m, 2, d - m + 1] *
      HoldForm[Binomial[a, b]] /. {a -> 2 + 3 m - s2, b -> 2 m - 1},
      {m, 1, d + 1}] /. s2 -> s],
  {d, 0, 1}];
Print["  numeric check d=0: ", Table[r7[4, 2, 9, 0, s], {s, 0, 3}]];
Print["  numeric check d=1: ", Table[r7[4, 2, 9, 1, s], {s, 0, 3}]];
Print["  vLin[7,2,1] = ", vLin[7, 2, 1], " (paper says 3)"];
Print[""];
Print["===== DONE ====="];
