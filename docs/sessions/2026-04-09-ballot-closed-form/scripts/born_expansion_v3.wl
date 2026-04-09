(* Q1: BORN EXPANSION v3 — CORRECT sub-block boundaries *)
(* Key insight: sub-blocks are defined by CF column counts,            *)
(* NOT by rise positions!                                               *)
(* Standard: p1=9 columns each. Anomalous: p0+p1=11 columns.          *)
(* a2-1=3 standard + 1 anomalous = 4 sub-blocks, total p2=38 columns. *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat
]

alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
a2 = 4;
initDim2 = q1 + q2 + 1; (* 22 *)
A2 = q1 + q2 - 1; (* 20 *)
startPos = p1 + p2; (* 47 *)

(* === CORRECT sub-block boundaries === *)
(* a2-1 = 3 standard blocks of p1 columns + 1 anomalous of (p0+p1) columns *)
sb1End = startPos + p1;       (* 56 *)
sb2End = sb1End + p1;         (* 65 *)
sb3End = sb2End + p1;         (* 74 *)
sb4End = sb3End + p0 + p1;   (* 85 = startPos + p2 *)

Print["Sub-block boundaries: ", startPos, " -> ", sb1End, " -> ", sb2End,
  " -> ", sb3End, " -> ", sb4End];
Print["Column counts: ", {sb1End - startPos, sb2End - sb1End,
  sb3End - sb2End, sb4End - sb3End}, " = ", {p1, p1, p1, p0 + p1}];
Print[""];

(* Build sub-blocks *)
SB1 = blockTransferActual[22, alpha, startPos, sb1End];
SB2 = blockTransferActual[26, alpha, sb1End, sb2End];
SB3 = blockTransferActual[30, alpha, sb2End, sb3End];
SB4 = blockTransferActual[34, alpha, sb3End, sb4End];

Print["Dims: SB1=", Dimensions[SB1], " SB2=", Dimensions[SB2],
  " SB3=", Dimensions[SB3], " SB4=", Dimensions[SB4]];

(* Build actual M2 *)
M2 = blockTransferActual[initDim2, alpha, startPos, sb4End];
Print["M2 dims: ", Dimensions[M2]];
Print["Composition: SB4.SB3.SB2.SB1 == M2? ", SB4 . SB3 . SB2 . SB1 === M2];
Print[""];

(* === Toeplitz parts === *)
(* Standard: T(p1-1) = T(8). Anomalous: T(p0+p1-1) = T(10). *)
TSB1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
TSB2 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 29}, {s, 0, 25}];
TSB3 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 33}, {s, 0, 29}];
TSB4 = Table[Binomial[p0 + p1 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 33}];

(* Verify Toeplitz matches for small rows *)
Print["Toeplitz check (first d0+1 rows should match):"];
Print["  TSB1[0..22] == SB1[0..22]? ", TSB1[[1 ;; 23]] === SB1[[1 ;; 23]]];
Print["  TSB2[0..26] == SB2[0..26]? ", TSB2[[1 ;; 27]] === SB2[[1 ;; 27]]];
Print["  TSB3[0..30] == SB3[0..30]? ", TSB3[[1 ;; 31]] === SB3[[1 ;; 31]]];
Print["  TSB4[0..34] == SB4[0..34]? ", TSB4[[1 ;; 35]] === SB4[[1 ;; 35]]];
Print[""];

(* Corrections *)
DSB1 = TSB1 - SB1; DSB2 = TSB2 - SB2;
DSB3 = TSB3 - SB3; DSB4 = TSB4 - SB4;

(* Correction rows *)
Print["Correction rows:"];
Do[{name, mat, dim0} = sb;
  nonzero = Select[Range[Length[mat]],
    mat[[#]] =!= Table[0, Dimensions[mat][[2]]] &] - 1;
  Print["  ", name, " (d0=", dim0, "): rows ", nonzero],
  {sb, {{"DSB1", DSB1, 22}, {"DSB2", DSB2, 26},
    {"DSB3", DSB3, 30}, {"DSB4", DSB4, 34}}}];
Print[""];

(* === ALL-TOEPLITZ PRODUCT === *)
allT = TSB4 . TSB3 . TSB2 . TSB1;
T2ref = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 21}];
Print["===== ALL-TOEPLITZ PRODUCT ====="];
Print["allT == T(p2-1)? ", allT === T2ref];
discRows = Select[Range[39], allT[[#]] =!= T2ref[[#]] &] - 1;
Print["Discrepancy rows: ", discRows];
Print["(Should be NONE if Vandermonde convolution holds for finite matrices)"];
Print[""];

(* === BORN EXPANSION === *)
(* M2 = (T4-D4)(T3-D3)(T2-D2)(T1-D1) *)
(* = allT - born1 + born2 - born3 + born4 *)
(* where born_k = sum over k-subsets of {1,2,3,4} of sandwiches *)

Print["===== FIRST-ORDER BORN TERMS ====="];
(* Replace ONE SBi with Di, keep rest as Ti *)
born1_1 = TSB4 . TSB3 . TSB2 . DSB1;
born1_2 = TSB4 . TSB3 . DSB2 . TSB1;
born1_3 = TSB4 . DSB3 . TSB2 . TSB1;
born1_4 = DSB4 . TSB3 . TSB2 . TSB1;
born1 = born1_1 + born1_2 + born1_3 + born1_4;

Do[{name, mat} = term;
  nonzero = Select[Range[39], mat[[#]] =!= Table[0, 22] &] - 1;
  Print["  ", name, ": first nonzero row = ",
    If[nonzero =!= {}, First[nonzero], "none"],
    ", total = ", Length[nonzero]],
  {term, {{"born1_1 (T.T.T.D1)", born1_1}, {"born1_2 (T.T.D2.T)", born1_2},
    {"born1_3 (T.D3.T.T)", born1_3}, {"born1_4 (D4.T.T.T)", born1_4}}}];
Print[""];

(* Second order *)
born2_12 = TSB4 . TSB3 . DSB2 . DSB1;
born2_13 = TSB4 . DSB3 . TSB2 . DSB1;
born2_14 = DSB4 . TSB3 . TSB2 . DSB1;
born2_23 = TSB4 . DSB3 . DSB2 . TSB1;
born2_24 = DSB4 . TSB3 . DSB2 . TSB1;
born2_34 = DSB4 . DSB3 . TSB2 . TSB1;
born2 = born2_12 + born2_13 + born2_14 + born2_23 + born2_24 + born2_34;

(* Third order *)
born3_123 = TSB4 . DSB3 . DSB2 . DSB1;
born3_124 = DSB4 . TSB3 . DSB2 . DSB1;
born3_134 = DSB4 . DSB3 . TSB2 . DSB1;
born3_234 = DSB4 . DSB3 . DSB2 . TSB1;
born3 = born3_123 + born3_124 + born3_134 + born3_234;

(* Fourth order *)
born4 = DSB4 . DSB3 . DSB2 . DSB1;

(* Verify full expansion *)
bornCheck = allT - born1 + born2 - born3 + born4;
Print["Full expansion allT - born1 + born2 - born3 + born4 == M2? ",
  bornCheck === M2];
Print[""];

(* === REFERENCE: actual total correction === *)
D2actual = T2ref - M2;

(* Simple formula *)
simpleFormula[d_, s_] := Sum[vLin[p2 - ww m, ww, d - m + 1] *
  Binomial[A2 + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}]

(* === MAIN RESULT: Born order at each correction depth === *)
Print["===== BORN ORDER ANALYSIS ====="];
Print["For each d: what orders contribute to the total correction?"];
Print[""];

Do[
  d = dd; j = A2 + 2 + d;
  simple = Table[simpleFormula[d, s], {s, 0, 21}];
  actual = D2actual[[j + 1]];
  residual = actual - simple;

  (* Born terms at this row (relative to allT, not T2) *)
  b1 = born1[[j + 1]];
  b2 = born2[[j + 1]];
  b3 = born3[[j + 1]];
  b4 = born4[[j + 1]];

  (* If allT == T2 at this row, then born terms directly give the correction *)
  atMatch = allT[[j + 1]] === T2ref[[j + 1]];

  isSimpleExact = residual === Table[0, 22];

  Print["d=", d, " (row ", j, "):"];
  Print["  allT==T2? ", atMatch];
  If[isSimpleExact,
    Print["  Simple formula EXACT"],
    Print["  Residual[0..3] = ", residual[[1 ;; 4]]]];

  (* Max absolute value of each Born order *)
  Print["  |O1|=", Max[Abs[b1]], " |O2|=", Max[Abs[b2]],
    " |O3|=", Max[Abs[b3]], " |O4|=", Max[Abs[b4]]];

  (* Check: does born1_4 (D4 term alone) reproduce the simple formula? *)
  d4term = born1_4[[j + 1]];
  If[atMatch,
    Print["  born1_4 == simple? ", d4term === simple];
    If[!isSimpleExact,
      Print["  born1_std == residual? ",
        (born1_1 + born1_2 + born1_3)[[j + 1]] === residual]]],
    Print["  (allT != T2, need adjustment)"]];
  Print[""],
  {dd, 0, 12}];

(* === DETAILED: structure of born1_1 (T.T.T.D1) at d=q1 === *)
Print["===== born1_1 STRUCTURE (propagated D1 correction) ====="];
Print["D1 correction rows: ", Select[Range[26],
  DSB1[[#]] =!= Table[0, 22] &] - 1];
Print[""];

Print["DSB1 correction entries:"];
Do[j = jj;
  row = DSB1[[j + 1]];
  If[row =!= Table[0, 22],
    Print["  j=", j, ": ", row[[1 ;; Min[8, 22]]], "..."]],
  {jj, 0, 25}];
Print[""];

(* born1_1 at rows around A2+2+q1 *)
Print["born1_1 at correction depths d=q1-1..q1+3:"];
Do[d = dd; j = A2 + 2 + d;
  row = born1_1[[j + 1]];
  If[row =!= Table[0, 22],
    Print["  d=", d, " (j=", j, "): ", row[[1 ;; 4]], "..."],
    Print["  d=", d, " (j=", j, "): zero"]],
  {dd, q1 - 1, q1 + 3}];
Print[""];

(* === DETAILED: what's the formula for born1_1? === *)
(* born1_1 = T4.T3.T2.D1 *)
(* T4.T3.T2 = T(p1-1+p1-1+1+p0+p1-1+1) wait, Vandermonde composition *)
(* T(a).T(b) = T(a+b+1) for correct Toeplitz convention *)
(* T2(8).T3(8) first: T(8+8+1) = T(17) *)
(* T(17).T4(10): T(17+10+1) = T(28) *)
(* Wait, the order is T4.T3.T2, not T2.T3.T4 *)
(* T3.T2: 34x30 . 30x26 = 34x26, Toeplitz T(8+8+1) = T(17)? *)
(* Vandermonde: (T_a . T_b)[j,s] = C(a+b+1+j-s, j-s) *)
(* T3(8) . T2(8): entries C(17+j-s, j-s). Check: sum_t C(8+j-t,j-t)C(8+t-s,t-s) = C(17+j-s,j-s) ✓ *)
(* T4(10) . T3T2(17): entries C(28+j-s, j-s) *)

(* So: T4.T3.T2 has entries C(28+j-s, j-s) for "large enough" matrices *)
(* And born1_1[j,s] = sum_t C(28+j-t, j-t) * DSB1[t, s] *)
(* DSB1 is nonzero only at rows t = 23, 24, 25 *)
(* So born1_1[j,s] = C(28+j-23, j-23)*DSB1[23,s] + C(28+j-24, j-24)*DSB1[24,s] *)
(*                  + C(28+j-25, j-25)*DSB1[25,s] *)

(* For j = A2+2+q1 = 26: *)
(* born1_1[26,s] = C(31, 3)*DSB1[23,s] + C(30, 2)*DSB1[24,s] + C(29, 1)*DSB1[25,s] *)
Print["===== ANALYTICAL born1_1 PREDICTION ====="];
Print["born1_1[j,s] = sum_{t=23}^{25} C(28+j-t, j-t) * DSB1[t,s]"];
Print[""];

(* Verify this formula *)
Do[d = dd; j = A2 + 2 + d;
  predicted = Table[
    Sum[Binomial[28 + j - t, j - t] * DSB1[[t + 1, s + 1]], {t, 23, 25}],
    {s, 0, 21}];
  actual = born1_1[[j + 1]];
  Print["d=", d, " (j=", j, "): predicted == actual? ", predicted === actual],
  {dd, q1, q1 + 4}];
Print[""];

(* === Similarly for born1_2 and born1_3 === *)
(* born1_2 = T4.T3.D2.T1 *)
(* T3.D2 then T4.(T3D2): D2 has correction at rows 27,28,29 *)
(* T1 has entries C(8+j-s, j-s) *)
(* T3(8).D2: entries at rows >= 27 *)
(* Actually: born1_2 = T4.T3.D2.T1 *)
(* = T4 . (T3 . D2 . T1) *)
(* T3.D2 has nonzero rows at 27+ (from D2 correction at 27,28,29 propagated by T3) *)
(* Wait: D2.T1 has nonzero rows at 27,28,29 (D2 only acts on rows 27-29) *)
(* T3.(D2.T1): propagates rows 27-29 via Toeplitz *)
(* T4.(T3.D2.T1): further propagates *)

(* Alternatively: *)
(* T4.T3 has entries C(10+8+1+j-s, j-s) = C(19+j-s, j-s) *)
(* born1_2[j,s] = sum_{t,u} T4T3[j,t] . D2[t,u] . T1[u,s] *)
(* = sum_t C(19+j-t, j-t) * (sum_u D2[t,u] * C(8+u-s, u-s)) *)
(* D2 has correction at t = 27,28,29 *)
(* The inner sum is the "Toeplitz-transported correction" *)

(* More directly: define D2_transported = D2 . T1 *)
D2_T1 = DSB2 . TSB1; (* 30x22 *)
Print["DSB2.TSB1 (D2 transported by T1):"];
Do[j = jj;
  row = D2_T1[[j + 1]];
  If[row =!= Table[0, 22],
    Print["  j=", j, ": first 4 = ", row[[1 ;; 4]]]],
  {jj, 26, 29}];
Print[""];

(* born1_2 = T4.T3 . D2_T1 *)
(* T4.T3 has Toeplitz param 10+8+1 = 19 *)
(* born1_2[j,s] = sum_t C(19+j-t, j-t) * D2_T1[t,s] *)
(* D2_T1 is nonzero at rows 27,28,29 *)
Print["born1_2[j,s] = sum_{t=27}^{29} C(19+j-t, j-t) * (DSB2.TSB1)[t,s]"];
Do[d = dd; j = A2 + 2 + d;
  predicted = Table[
    Sum[Binomial[19 + j - t, j - t] * D2_T1[[t + 1, s + 1]], {t, 27, 29}],
    {s, 0, 21}];
  actual = born1_2[[j + 1]];
  Print["d=", d, " (j=", j, "): predicted == actual? ", predicted === actual],
  {dd, q1, q1 + 2}];
Print[""];

Print["===== DONE ====="];
