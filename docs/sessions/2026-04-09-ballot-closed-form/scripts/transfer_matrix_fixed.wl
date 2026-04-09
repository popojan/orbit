(* FIXED: Block transfer matrix — rise FIRST, then within-stair *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    (* RISE first: extend + L_{m+1} *)
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    (* THEN within-stair: L_m^{w-1} *)
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

(* === Pi block {3,3,3,3,3,3,4} from dim=8 (height 7) === *)
M = blockTransfer[8, {3, 3, 3, 3, 3, 3, 4}];
Print["M dimensions: ", Dimensions[M]];

v25 = {1, 22, 247, 1872, 10647, 47502, 166257, 420732};
vPred = M . v25;

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

v47 = Table[pathsRat[47, 15, j], {j, 0, 14}];
Print["M.v(25) = v(47)? ", vPred === v47];
Print[""];

If[vPred =!= v47,
  Print["STILL MISMATCH: ", vPred - v47]; Print[""];
  Print["M.v(25): ", vPred]; Print["v(47):   ", v47],
  (* SUCCESS — analyze the matrix *)
  Print["=== SUCCESS: M correctly maps v(25) to v(47) ==="];
  Print[""];

  (* Show M *)
  Print["M = "];
  Do[Print["  row ", j, ": ", M[[j + 1]]], {j, 0, 14}];
  Print[""];

  (* Column 7 (last column) = contribution of v_7(25) = B(25,8) *)
  Print["Last column of M (contribution of B(25,8)):"];
  Print[M[[All, 8]]];
  Print[""];

  (* === KEY: express M[j,s] in terms of binomial coefficients === *)
  (* The transfer within each stair is L_m^{w-1} with entries C(i-j+w-2, w-2) *)
  (* The rise is prefix sum (L_{m+1}) after extension by 0 *)
  (* Combined 7-step operation... *)

  (* Check: does M have the structure M[j,s] = f(j,s) for some closed form? *)
  Print["=== M[j,s] for j=8..14, s=0..7 (the correction part) ==="];
  Do[
    Print["j=", j, ": ", Table[M[[j + 1, s + 1]], {s, 0, 7}]],
    {j, 8, 14}];
  Print[""];

  (* === Correction vector = M . v(25) - vLin(47, 3, .) === *)
  Print["=== Correction = M.v(25) - vLin(47,3,j) ==="];
  Do[
    corr = vPred[[j + 1]] - vLin[47, 3, j];
    Print["j=", j, " corr=", corr],
    {j, 0, 14}];
  Print[""];

  (* === Decompose: which row of M contributes how much to correction? === *)
  Print["=== Contribution of each v_s(25) to correction at j=8 ==="];
  j = 8;
  lin = vLin[47, 3, 8]; (* what vLinear predicts *)
  total = 0;
  Do[
    contrib = M[[j + 1, s + 1]] * v25[[s + 1]];
    total += contrib;
    Print["  s=", s, " M[8,", s, "]=", M[[j + 1, s + 1]],
      " * v_", s, "(25)=", v25[[s + 1]], " -> ", contrib],
    {s, 0, 7}];
  Print["  Total: ", total, " (should be ", vPred[[j + 1]], ")"];
  Print["  vLin(47,3,8) = ", lin];
  Print["  Correction: ", total - lin];
];
