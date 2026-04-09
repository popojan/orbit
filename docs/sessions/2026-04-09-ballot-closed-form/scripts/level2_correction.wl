(* LEVEL-2 CORRECTION ANALYSIS for sqrt(5) = [2; 4, 4, 4, ...] *)
(* Goal: discover self-similar correction structure at level 2 *)

(* Core functions *)
Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

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

(* === Parameters for sqrt(5) === *)
ww = 2; a1 = 4; a2 = 4;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* Sturmian patterns *)
pattern1 = Table[Ceiling[p1 k/q1] - Ceiling[p1 (k - 1)/q1], {k, 1, q1}];
pattern2 = Table[Ceiling[p2 k/q2] - Ceiling[p2 (k - 1)/q2], {k, 1, q2}];

Print["Level-1 pattern (", p1, "/", q1, "): ", pattern1];
Print["Level-2 pattern (", p2, "/", q2, "): ", pattern2];

(* Verify grouping into level-1 sub-blocks *)
Print["Level-2 grouped into sub-blocks:"];
pos = 1;
blockList = {};
While[pos <= q2,
  found = False;
  Do[
    subPat = pattern2[[pos ;; pos + len - 1]];
    If[subPat === pattern1,
      AppendTo[blockList, {"std", pattern1}]; pos += len; found = True; Break[]],
    {len, {q1}}];
  If[!found,
    rest = pattern2[[pos ;; q2]];
    AppendTo[blockList, {"anom", rest}]; pos = q2 + 1]];
Do[Print["  ", blockList[[i]]], {i, Length[blockList]}];
Print[""];

(* === Level-1 block transfer (recap) === *)
Print["=== Level-1: M1 (", p1, "/", q1, " block, init dim ", q1+1, ") ==="];
M1 = blockTransfer[q1 + 1, pattern1];
T1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 2 q1}, {s, 0, q1}];
D1 = T1 - M1;
Print["Dims: ", Dimensions[M1]];
Do[If[D1[[j + 1]] =!= Table[0, q1 + 1],
  Print["  j=", j, ": Delta1 = ", D1[[j + 1]]]], {j, 0, 2 q1}];
Print[""];

(* === Level-2 "PURE" block transfer (init dim = q2+1 = 18) === *)
Print["=== Level-2: M2 (", p2, "/", q2, " block, init dim ", q2 + 1, ") ==="];
M2 = blockTransfer[q2 + 1, pattern2];
{nrows2, ncols2} = Dimensions[M2];
T2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, nrows2 - 1}, {s, 0, ncols2 - 1}];
D2 = T2 - M2;
Print["Dims: ", Dimensions[M2]];

(* Find correction rows *)
corrRows = {};
Do[If[D2[[j + 1]] =!= Table[0, ncols2],
  AppendTo[corrRows, j]], {j, 0, nrows2 - 1}];
Print["Correction rows: ", corrRows];
Print["Count: ", Length[corrRows], " (expected q2-1 = ", q2 - 1, ")"];
If[corrRows =!= {},
  Print["First: j=", First[corrRows], " (expected q2+2 = ", q2 + 2, ")"];
  Print["Last: j=", Last[corrRows]]];
Print[""];

(* Show correction rows *)
Print["=== Correction Delta2 values ==="];
Do[
  j = corrRows[[i]];
  Print["  j=", j, " (d=", j - First[corrRows], "): ", D2[[j + 1]]],
  {i, 1, Min[10, Length[corrRows]]}];
If[Length[corrRows] > 10, Print["  ..."]];
Print[""];

(* === KEY TEST: Does Delta2 have same structure as Delta1? === *)
(* At level 1: Delta1[a1+2+d, s] = sum_m c * C(a1+m(w+1)-s, mw-1) *)
(* The basis functions are C(a1+m*(w+1)-s, m*w-1)                  *)
(* At level 2: Delta2[q2+2+d, s] = sum_m c * C(q2+m*?-s, ?-1)     *)
(* What are the level-2 "effective parameters"?                     *)
(*   At level 1: "unit width" = w = a0, "unit+1 width" = w+1       *)
(*   At level 2: "unit width" = p1 = 9, "unit+1 width" = p1+p0 = 11 ? *)

Print["=== STRUCTURAL ANALYSIS ==="];

(* At level 1: d=0 row is single binomial C(a1+w+1-s, w-1) *)
(* Try the same at level 2: is d=0 row a single binomial?  *)
If[corrRows =!= {},
  d0row = D2[[First[corrRows] + 1]];
  Print["d=0 row: ", d0row];

  (* Try C(A-s, B) for various A, B *)
  Print["Fitting C(A-s, B) to d=0 row:"];
  found = False;
  Do[
    test = Table[Binomial[a - s, b], {s, 0, ncols2 - 1}];
    If[test === d0row,
      Print["  MATCH: C(", a, "-s, ", b, ")"];
      Print["  At level 1: C(a1+w+1-s, w-1) = C(", a1 + ww + 1, "-s, ", ww - 1, ")"];
      Print["  Level-2 analogue check:"];
      Print["    a1 -> q2 = ", q2, "? a = ", a, " vs q2+?+1 = ..."];
      Print["    w -> p1 = ", p1, "? b = ", b, " vs p1-1 = ", p1 - 1];
      found = True; Break[]],
    {b, 1, 25}, {a, b + ncols2 - 1, 80}];
  If[!found, Print["  NO simple C(A-s, B) fit found"]];
  Print[""]
];

(* === Decompose into binomial basis === *)
(* At level 1: basis_m(s) = C(a1+m(w+1)-s, mw-1) for m=1,2,... *)
(* At level 2: try basis_m(s) = C(q2+m(p1+p0+1)-s, m*p1-1)     *)
(* or other combinations                                         *)

Print["=== Binomial basis decomposition of Delta2 ==="];

(* Try several candidate bases *)
(* Candidate 1: B_m(s) = C(q2+m*(p1+1)-s, m*p1-1) *)
(* Candidate 2: B_m(s) = C(q2+m*(ww+1)*(a1+1)-s, m*ww*a1-1) *)
(* Candidate 3: direct fit *)

If[Length[corrRows] >= 1,
  d0row = D2[[First[corrRows] + 1]];

  (* For the d=0 row, try to express as C(X-s, Y) *)
  (* This gives us the level-2 analogue of w+1 and w *)
  Print["Testing candidate bases for d=0 row:"];

  (* Level-1: d=0 is C(a1 + (w+1) - s, w - 1) = C(7-s, 1) for sqrt5 *)
  (* So for level 2: C(q2 + W2 - s, W2 - 2) where W2 is "effective width" *)
  (* Or: C(q2 + ? - s, ? - 1) *)
];

(* === Compare with iterated M1 === *)
Print[""];
Print["=== M2 vs iterated M1 (3 standard + 1 anomalous) ==="];

(* Anomalous level-1 pattern *)
(* For sqrt(5): standard = {2,2,2,3} (4 stairs), anomalous = ? *)
(* The anomalous block has q1+q0 = 5 stairs, width p1+p0 = 11 *)
anomPattern = Table[Ceiling[(p1 + p0) k/(q1 + q0)] - Ceiling[(p1 + p0) (k - 1)/(q1 + q0)],
  {k, 1, q1 + q0}];
Print["Standard pattern: ", pattern1, " (", q1, " stairs, width ", p1, ")"];
Print["Anomalous pattern: ", anomPattern, " (", q1 + q0, " stairs, width ", p1 + p0, ")"];

(* Verify: full pattern = concat of 3 standard + 1 anomalous? *)
fullConcat = Join[pattern1, pattern1, pattern1, anomPattern];
Print["Concat matches pattern2? ", fullConcat === pattern2];

(* Build M2 as product of sub-block transfers *)
(* Order: process blocks left-to-right, so first block acts first *)
d = q2 + 1; (* starting dimension *)
M2iter = IdentityMatrix[d];

(* 3 standard blocks *)
Do[
  curDim = Dimensions[M2iter][[1]];
  Mstd = blockTransfer[curDim, pattern1];
  M2iter = Mstd . M2iter,
  {3}];
(* 1 anomalous block *)
curDim = Dimensions[M2iter][[1]];
Manom = blockTransfer[curDim, anomPattern];
M2iter = Manom . M2iter;

Print["M2 (direct):   dims = ", Dimensions[M2]];
Print["M2 (iterated): dims = ", Dimensions[M2iter]];
Print["Match: ", M2 === M2iter];

(* If not matching, try other ordering *)
If[M2 =!= M2iter,
  Print["Trying anomalous-first ordering..."];
  d = q2 + 1;
  M2iter2 = IdentityMatrix[d];
  curDim = d;
  Manom2 = blockTransfer[curDim, anomPattern];
  M2iter2 = Manom2 . M2iter2;
  Do[
    curDim = Dimensions[M2iter2][[1]];
    Mstd = blockTransfer[curDim, pattern1];
    M2iter2 = Mstd . M2iter2,
    {3}];
  Print["Anom-first match: ", M2 === M2iter2]
];
Print[""];

(* === DP VERIFICATION === *)
Print["=== DP Verification ==="];
(* v(38, 17) from scratch *)
v38 = Table[pathsRat[p2, q2, j], {j, 0, q2}];
vUnif38 = Table[vLin[p2, ww, j], {j, 0, q2}];
Print["v(38) DP: ", v38];
Print["v(38) uniform: ", vUnif38];
Print["Corrections: ", v38 - vUnif38];
Print[""];

(* v at level-2 semi-convergent positions *)
Print["=== State vectors at level-2 semi-convergent positions ==="];
Do[
  pos = p1 + k p2;
  qq = q1 + k q2;
  vDP = Table[pathsRat[pos, qq, j], {j, 0, qq}];
  vU = Table[vLin[pos, ww, j], {j, 0, qq}];
  corr = vDP - vU;
  (* Find first nonzero correction *)
  firstCorr = FirstPosition[corr, x_ /; x =!= 0];
  Print["v(", pos, "): dim=", Length[vDP],
    " last=", Last[vDP],
    " first_corr_at j=", If[firstCorr === Missing["NotFound"], "none", firstCorr[[1]] - 1]],
  {k, 1, 3}];
Print[""];

(* === COMPARE PURE M2 (dim 18) vs contextualized M2 (dim 22) === *)
Print["=== Contextualized M2 (init dim 22 = q1+q2+1) ==="];
M2ctx = blockTransfer[q1 + q2 + 1, pattern2];
Print["Dims: ", Dimensions[M2ctx]];
T2ctx = Table[Binomial[p2 - 1 + j - s, j - s],
  {j, 0, Dimensions[M2ctx][[1]] - 1}, {s, 0, Dimensions[M2ctx][[2]] - 1}];
D2ctx = T2ctx - M2ctx;

corrCtx = {};
Do[If[D2ctx[[j + 1]] =!= Table[0, Dimensions[M2ctx][[2]]],
  AppendTo[corrCtx, j]], {j, 0, Dimensions[M2ctx][[1]] - 1}];
Print["Correction rows: first=", If[corrCtx =!= {}, First[corrCtx], "none"],
  " count=", Length[corrCtx]];

(* Verify with DP *)
v47 = Table[pathsRat[47, 21, j], {j, 0, 21}];
v85dp = Table[pathsRat[85, 38, j], {j, 0, 38}];
v85formula = M2ctx . v47;
Print["M2ctx . v(47) = v(85)? ", v85formula === v85dp];
Print[""];

(* === DETAILED CORRECTION STRUCTURE OF PURE M2 === *)
Print["=== DETAILED: Pure M2 correction structure ==="];
Print["Level-1 params: a1=", a1, " w=", ww, " p1=", p1, " q1=", q1];
Print["Level-2 params: a2=", a2, " p2=", p2, " q2=", q2];
Print[""];

(* The key question: how does Delta2 decompose? *)
(* At level 1: Delta1 rows start at j = a1+2 *)
(* At level 2: Delta2 rows start at j = ? *)
(* Hypothesis 1: j = q2+2 = 19 (dimension analogy) *)
(* Hypothesis 2: j starts earlier, with level-1 corrections embedded *)

Print["Delta2 row-by-row:"];
Do[
  j = corrRows[[i]];
  d = j - First[corrRows];
  row = D2[[j + 1]];
  (* Try to express as sum of binomials *)
  Print["j=", j, " d=", d, ": ", row],
  {i, 1, Length[corrRows]}];
