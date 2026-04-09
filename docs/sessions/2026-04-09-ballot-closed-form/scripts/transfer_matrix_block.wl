(* Transfer matrix for block {3,3,3,3,3,3,4} *)
(* Compute M such that v(47) = M . v(25) (extended) *)
(* Then check: correction = M . v(25) - vLinear prediction *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

(* Build the SYMBOLIC block transfer matrix *)
(* Input: vector of dim d (heights 0..d-1) *)
(* Block pattern: {w1, w2, ..., wk} = stair widths *)
(* Each stair: L_m^{w-1} then rise (extend + L_{m+1}) *)

blockTransferMatrix[d_, pattern_] := Module[
  {m = d - 1, dim = d, mat},
  (* Start with identity *)
  mat = IdentityMatrix[d];
  Do[
    (* Within stair: L_m^(w-1) *)
    If[w > 1,
      mat = MatrixPower[Lmat[m], w - 1] . mat];
    (* Rise: extend by 0 row/col, then L_{m+1} *)
    mat = ArrayPad[mat, {{0, 1}, {0, 0}}]; (* add zero row at bottom *)
    mat = Lmat[m + 1] . mat;
    m++; dim++,
    {w, pattern}];
  mat
]

(* === Pi block: {3,3,3,3,3,3,4}, starting from height 8 (dim=9) === *)
(* Wait: v(25) has 8 entries (height 0..7). The block starts with a RISE *)
(* from height 7 to 8. So input dim = 8. *)

Print["=== Block transfer matrix M for {3,3,3,3,3,3,4} from dim=8 ==="];
M = blockTransferMatrix[8, {3, 3, 3, 3, 3, 3, 4}];
Print["M dimensions: ", Dimensions[M]]; (* should be 15 x 8 *)
Print[""];

(* State vector at x=25 *)
v25 = {1, 22, 247, 1872, 10647, 47502, 166257, 420732};

(* Compute M . v25 *)
vPredicted = M . v25;
Print["M . v(25) = ", vPredicted];
Print[""];

(* Actual v(47) from pathsRational *)
pathsRat[pp_, qq_, jj_] := Module[{S, dp},
  If[jj == 0, Return[1]]; If[jj < 0, Return[0]];
  S = Table[Min[Floor[qq x/pp], jj], {x, 1, pp}];
  If[jj > S[[pp]], Return[0]];
  dp = Table[0, {pp}, {jj + 1}];
  Do[Do[If[y <= S[[x]],
    dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
      If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
      If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[jj, S[[x]]]}], {x, 1, pp}];
  dp[[pp, jj + 1]]
]

v47actual = Table[pathsRat[47, 15, j], {j, 0, 14}];
Print["v(47) actual = ", v47actual];
Print[""];

(* But wait: M . v(25) gives the state AFTER the block transfer. *)
(* The actual v(47) also includes the 3 pre-steps from x=22 to x=25 *)
(* v(25) = L_7^3 . v(22). But we're starting from v(25), not v(22). *)
(* And v(47) is reached from v(25) via: rise + block operations. *)
(* But v(25) is at height 7. The block {3,3,3,3,3,3,4} starts with *)
(* a rise from height 7 to 8. So M should do exactly that. *)

Print["=== Comparison ==="];
Print["Match: ", vPredicted === v47actual];
If[vPredicted =!= v47actual,
  Print["Differences: ", vPredicted - v47actual]];
Print[""];

(* === Now: decompose M into vLinear structure === *)
(* Each column M_s of M tells us: contribution of v_s(25) to v_j(47) *)
Print["=== Column structure of M ==="];
Do[
  Print["Column s=", s, " (contribution of v_", s, "(25)):"];
  col = M[[All, s + 1]];
  Print["  ", col],
  {s, 0, 7}];
Print[""];

(* === Key: what does column 0 look like? === *)
(* Column 0 = M . e_0 = what happens to a unit vector at height 0 *)
(* This should be the state vector for a path starting with 1 at height 0 *)
Print["=== Column 0 (M . {1,0,...,0}): ==="];
col0 = M[[All, 1]];
Print[col0];

(* And vLinear(25, 3, j) for j=0..7 is the state vector at 25 *)
(* The correction at j comes from: *)
(* v_j(47) = Sum_s M[j,s] * v_s(25)  *)
(* vLinear(47,3,j) = single-term approximation *)
(* correction = Sum_s M[j,s] * v_s(25) - vLinear(47,3,j) *)

(* === Express M in terms of ballot-number ratios === *)
Print[""];
Print["=== M[j,s] / B(25, s) ratios (M normalized by v(25) entries) ==="];
Do[
  ratios = Table[
    If[v25[[s + 1]] =!= 0, M[[j + 1, s + 1]] / v25[[s + 1]], "?"],
    {s, 0, 7}];
  Print["j=", j, ": ", ratios],
  {j, 0, 14}];
Print[""];

(* === What is the "pure block" transfer from {1,0,...,0}? === *)
(* This is paths under the BLOCK staircase starting fresh *)
vBlock = M . UnitVector[8, 1]; (* = column 0 of M *)
Print["=== Block transfer of e_0: ==="];
Print[vBlock];

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

(* Compare with vLinear for appropriate parameters *)
(* The block has 22 columns, 7 rises, so it's a 22/7 staircase starting from height 8 *)
(* But applied to e_0 at height 0, it should give paths from height 0 through 7 stairs *)
Print[""];
Print["vBlock vs vLinear(22, 3, j) for j=0..7:"];
Do[
  Print["  j=", j, " block=", vBlock[[j + 1]],
    " vLin(22,3,", j, ")=", vLin[22, 3, j],
    If[vBlock[[j + 1]] === vLin[22, 3, j], " MATCH", " diff"]],
  {j, 0, Min[7, Length[vBlock] - 1]}];

(* === THE KEY DECOMPOSITION: M = outer product structure? === *)
Print[""];
Print["=== Testing: is M rank-1 (outer product)? ==="];
Print["Rank of M: ", MatrixRank[M]];
Print[""];

(* If rank > 1, try SVD or look at column dependencies *)
If[MatrixRank[M] > 1,
  Print["M is NOT rank 1. Looking at column ratios..."];
  (* Check if columns are proportional *)
  Do[
    If[col0[[j + 1]] =!= 0,
      ratios = Table[M[[j + 1, s + 1]] / col0[[j + 1]], {s, 0, 7}];
      Print["  Row j=", j, ": M[j,:]/M[j,0] = ", ratios]],
    {j, 0, 14}]];
