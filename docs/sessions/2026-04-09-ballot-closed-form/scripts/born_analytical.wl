(* ANALYTICAL BORN PREDICTION: predict d >= q1 corrections from pure algebra *)
(* No DP computation — just the closed-form formulas *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
toep[a_, j_, s_] := If[j >= s, Binomial[a + j - s, j - s], 0]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
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
a2 = 4; initDim2 = q1 + q2 + 1; A2 = q1 + q2 - 1;
startPos = p1 + p2;

(* === ANALYTICAL D_SBi formulas === *)
(* For standard sub-blocks with pattern {3,2,2,2}: A = d0 - 2 *)
(* Sub-block i starts at dim d0i *)
d01 = initDim2;     (* 22 *)
d02 = d01 + q1;     (* 26 *)
d03 = d02 + q1;     (* 30 *)

(* D_SBi[d0i + d, s] for d = 0..q1-1 *)
dSBformula[d0_, d_, s_] :=
  Sum[vLin[p1 - ww m, ww, d - m + 1] *
    Binomial[(d0 - 2) + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}]

(* === BORN TERMS (analytical) === *)
(* bA[j,s] = sum_t C(28+j-t, j-t) * D_SB1[t, s] *)
(* where t ranges over correction rows of SB1: {d01, d01+1, ..., d01+q1-1} *)
(* Toeplitz param for T4.T3.T2: *)
(* T2(8).T3(8) = T(17), then T4(10).T(17) = T(28) *)
paramA = (p0 + p1 - 1) + (p1 - 1) + 1 + (p1 - 1) + 1; (* 10+8+1+8+1 = 28 *)

bornA[j_, s_] := Sum[
  toep[paramA, j, d01 + d] * dSBformula[d01, d, s],
  {d, 0, q1 - 1}]

(* bB[j,s] = sum_t C(19+j-t, j-t) * (D_SB2 . T_SB1)[t, s] *)
(* T_SB1[u,s] = toep[8, u, s] *)
(* D_SB2[t, u] = dSBformula[d02, t-d02, u] for t in {d02..d02+q1-1} *)
(* (D_SB2 . T_SB1)[t, s] = sum_u D_SB2[t, u] * T_SB1[u, s] *)
paramB = (p0 + p1 - 1) + (p1 - 1) + 1; (* 10+8+1 = 19 *)

dSB2transported[t_, s_] := Sum[
  dSBformula[d02, t - d02, u] * toep[p1 - 1, u, s],
  {u, 0, d02 - 1}] (* sum over input columns of SB1 *)

bornB[j_, s_] := Sum[
  toep[paramB, j, d02 + d] * dSB2transported[d02 + d, s],
  {d, 0, q1 - 1}]

(* bC[j,s] = sum_t C(10+j-t, j-t) * (D_SB3 . T_SB2 . T_SB1)[t, s] *)
(* T_SB2 . T_SB1 = T(17) (Vandermonde) *)
paramC = p0 + p1 - 1; (* 10 *)

dSB3transported[t_, s_] := Sum[
  dSBformula[d03, t - d03, u] * toep[17, u, s],
  {u, 0, d03 - 1}]

bornC[j_, s_] := Sum[
  toep[paramC, j, d03 + d] * dSB3transported[d03 + d, s],
  {d, 0, q1 - 1}]

(* === TOTAL first-order Born at level 2 === *)
(* For d < q1: only bA contributes (rows 22-25) *)
(* For d >= q1: bA + bB + bC *)
(* bD starts at row 34 (d=12), ignore for now *)

bornFirst[j_, s_] := bornA[j, s] + bornB[j, s] + bornC[j, s]

(* === VERIFY against actual M2 === *)
Print["===== ANALYTICAL BORN vs ACTUAL M2 ====="];
Print["Computing actual M2 via DP..."];
M2 = blockTransferActual[initDim2, alpha, startPos, startPos + p2];
t2ref = Table[toep[p2 - 1, j, s], {j, 0, 38}, {s, 0, 21}];
d2actual = t2ref - M2;

Print[""];
Print["Row-by-row verification:"];
Do[
  d = dd; j = A2 + 2 + d;
  actual = d2actual[[j + 1]];
  born = Table[bornFirst[j, s], {s, 0, 21}];
  residual = actual - born;
  maxErr = Max[Abs[residual]];
  maxAct = Max[Abs[actual]];

  If[maxErr === 0,
    Print["d=", d, " (row ", j, "): EXACT MATCH"],
    Print["d=", d, " (row ", j, "): |err|=", maxErr,
      " |actual|=", maxAct,
      " frac=", N[maxErr/maxAct, 4]]],
  {dd, 0, 10}];
Print[""];

(* === SHOW the analytical formula at d=q1 === *)
Print["===== ANALYTICAL VALUES at d=q1=4 (row 26) ====="];
j = A2 + 2 + q1; (* = 26 *)
Print["bA contributions:"];
Do[d = dd;
  t = d01 + d;
  coeff = toep[paramA, j, t];
  corrVal = dSBformula[d01, d, 0];
  Print["  t=", t, " (d=", d, "): C(", paramA, "+", j, "-", t, ",", j - t,
    ")=", coeff, " * D1[", t, ",0]=", corrVal, " => ", coeff * corrVal],
  {dd, 0, q1 - 1}];
Print["  bA[", j, ",0] = ", bornA[j, 0]];
Print[""];

Print["bB contributions:"];
Do[d = dd;
  t = d02 + d;
  coeff = toep[paramB, j, t];
  transVal = dSB2transported[t, 0];
  Print["  t=", t, " (d=", d, "): C(", paramB, "+", j, "-", t, ",", j - t,
    ")=", coeff, " * D2T1[", t, ",0]=", transVal, " => ", coeff * transVal],
  {dd, 0, q1 - 1}];
Print["  bB[", j, ",0] = ", bornB[j, 0]];
Print[""];

Print["bC contributions:"];
Do[d = dd;
  t = d03 + d;
  coeff = toep[paramC, j, t];
  transVal = dSB3transported[t, 0];
  Print["  t=", t, " (d=", d, "): C(", paramC, "+", j, "-", t, ",", j - t,
    ")=", coeff, " * D3T21[", t, ",0]=", transVal],
  {dd, 0, q1 - 1}];
Print["  bC[", j, ",0] = ", bornC[j, 0]];
Print[""];

Print["Total born1[", j, ", 0] = ", bornFirst[j, 0]];
Print["Actual D2[", j, ", 0] = ", d2actual[[j + 1, 1]]];
Print["Difference = ", d2actual[[j + 1, 1]] - bornFirst[j, 0]];
Print[""];

Print["===== DONE ====="];
