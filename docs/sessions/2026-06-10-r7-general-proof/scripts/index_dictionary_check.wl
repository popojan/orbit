(* Pin the d0 dictionary: compute the ACTUAL block transfer for sqrt(5)
   level-1 block (w=2, a1=4, p1=9, input rows 0..3), Toeplitz T = L^9,
   Delta = T - M, and compare nonzero rows against (a) paper Example 4.3,
   (b) the phase recursion with symbolic d0 evaluated at candidate values. *)

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

alpha = Sqrt[5]; initDim = 4; p1 = 9; w = 2; q1 = 4;

mBlk = blockTransferActual[initDim, alpha, 0, p1];
dims = Dimensions[mBlk];
Print["Block transfer dims: ", dims];

(* Free Toeplitz for 9 transitions, output rows 0..7, input cols 0..3 *)
tFree = Table[If[j >= s, Binomial[p1 - 1 + j - s, j - s], 0],
  {j, 0, dims[[1]] - 1}, {s, 0, dims[[2]] - 1}];

delta = tFree - mBlk;
Print["Nonzero correction rows (0-based): ",
  Select[Range[0, dims[[1]] - 1], delta[[# + 1]] =!= Table[0, {dims[[2]]}] &]];
Print[""];
Do[
  Print["Delta[", j, ", s]: ", delta[[j + 1]]],
  {j, 0, dims[[1]] - 1}];
Print[""];

(* Paper Example 4.3 claims: Delta[6,s] = Binom[7-s,1],
   Delta[7,s] = 3 Binom[7-s,1] + Binom[10-s,3] *)
ex6 = Table[Binomial[7 - s, 1], {s, 0, dims[[2]] - 1}];
ex7 = Table[3 Binomial[7 - s, 1] + Binomial[10 - s, 3], {s, 0, dims[[2]] - 1}];
Print["Example 4.3 row 6 match: ", delta[[7]] === ex6];
Print["Example 4.3 row 7 match: ", delta[[8]] === ex7];
Print[""];

(* Which d0 value makes r7 reproduce the actual Delta rows?
   Try mapping depth d -> absolute row jFirst + d for candidate jFirst,
   with formula-d0 = candidate val *)
Do[
  Module[{jFirst, ok},
    jFirst = Select[Range[0, dims[[1]] - 1],
      delta[[# + 1]] =!= Table[0, {dims[[2]]}] &];
    If[jFirst === {}, Print["no nonzero rows?!"],
      jFirst = First[jFirst];
      ok = And @@ Flatten[Table[
        delta[[jFirst + d + 1, s + 1]] === r7[d0cand, w, p1, d, s],
        {d, 0, dims[[1]] - 1 - jFirst - 1 + 1 - 1},
        {s, 0, dims[[2]] - 1}]];
      Print["formula-d0 = ", d0cand, " (rows ", jFirst, "..",
        dims[[1]] - 1, "): ", If[ok, "MATCHES", "no"]]]],
  {d0cand, 3, 8}];

Print[""];
Print["===== DONE ====="];
