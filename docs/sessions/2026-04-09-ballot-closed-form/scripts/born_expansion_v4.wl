(* Q1: BORN EXPANSION v4 — CORRECTED Toeplitz (enforce j>=s) *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];

(* CORRECT Toeplitz: lower-triangular! *)
toep[a_, j_, s_] := If[j >= s, Binomial[a + j - s, j - s], 0]

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

(* Sub-blocks: 3 standard (p1 cols each) + 1 anomalous (p0+p1 cols) *)
sb1End = startPos + p1; sb2End = sb1End + p1;
sb3End = sb2End + p1; sb4End = sb3End + p0 + p1;

SB1 = blockTransferActual[22, alpha, startPos, sb1End];
SB2 = blockTransferActual[26, alpha, sb1End, sb2End];
SB3 = blockTransferActual[30, alpha, sb2End, sb3End];
SB4 = blockTransferActual[34, alpha, sb3End, sb4End];
M2 = blockTransferActual[initDim2, alpha, startPos, sb4End];
Print["Composition check: ", SB4 . SB3 . SB2 . SB1 === M2];

(* Corrected Toeplitz matrices *)
tSB1 = Table[toep[p1 - 1, j, s], {j, 0, 25}, {s, 0, 21}];
tSB2 = Table[toep[p1 - 1, j, s], {j, 0, 29}, {s, 0, 25}];
tSB3 = Table[toep[p1 - 1, j, s], {j, 0, 33}, {s, 0, 29}];
tSB4 = Table[toep[p0 + p1 - 1, j, s], {j, 0, 38}, {s, 0, 33}];

(* Corrections *)
dSB1 = tSB1 - SB1; dSB2 = tSB2 - SB2;
dSB3 = tSB3 - SB3; dSB4 = tSB4 - SB4;

Print["Correction rows:"];
Do[{name, mat, ncol} = sb;
  nonzero = Select[Range[Length[mat]],
    mat[[#]] =!= Table[0, ncol] &] - 1;
  Print["  ", name, ": rows ", nonzero],
  {sb, {{"dSB1", dSB1, 22}, {"dSB2", dSB2, 26},
    {"dSB3", dSB3, 30}, {"dSB4", dSB4, 34}}}];
Print[""];

(* All-Toeplitz product *)
allT = tSB4 . tSB3 . tSB2 . tSB1;
t2ref = Table[toep[p2 - 1, j, s], {j, 0, 38}, {s, 0, 21}];
Print["allT == T(p2-1)? ", allT === t2ref];
If[allT =!= t2ref,
  disc = Select[Range[39], allT[[#]] =!= t2ref[[#]] &] - 1;
  Print["Discrepancy rows: ", disc]];
Print[""];

(* === BORN EXPANSION === *)
(* M2 = (tSB4-dSB4)(tSB3-dSB3)(tSB2-dSB2)(tSB1-dSB1) *)
(* = allT - born1 + born2 - born3 + born4 *)

(* First-order terms *)
bA = tSB4 . tSB3 . tSB2 . dSB1;  (* D1 propagated *)
bB = tSB4 . tSB3 . dSB2 . tSB1;  (* D2 propagated *)
bC = tSB4 . dSB3 . tSB2 . tSB1;  (* D3 propagated *)
bD = dSB4 . tSB3 . tSB2 . tSB1;  (* D4 propagated *)
born1 = bA + bB + bC + bD;

(* Second-order *)
bAB = tSB4 . tSB3 . dSB2 . dSB1;
bAC = tSB4 . dSB3 . tSB2 . dSB1;
bAD = dSB4 . tSB3 . tSB2 . dSB1;
bBC = tSB4 . dSB3 . dSB2 . tSB1;
bBD = dSB4 . tSB3 . dSB2 . tSB1;
bCD = dSB4 . dSB3 . tSB2 . tSB1;
born2 = bAB + bAC + bAD + bBC + bBD + bCD;

(* Third-order *)
bABC = tSB4 . dSB3 . dSB2 . dSB1;
bABD = dSB4 . tSB3 . dSB2 . dSB1;
bACD = dSB4 . dSB3 . tSB2 . dSB1;
bBCD = dSB4 . dSB3 . dSB2 . tSB1;
born3 = bABC + bABD + bACD + bBCD;

(* Fourth-order *)
born4 = dSB4 . dSB3 . dSB2 . dSB1;

(* Verify *)
bornCheck = allT - born1 + born2 - born3 + born4;
Print["Born expansion: allT - b1 + b2 - b3 + b4 == M2? ", bornCheck === M2];
Print[""];

(* === REFERENCE: total correction and simple formula === *)
d2actual = t2ref - M2;

simpleF[d_, s_] := Sum[vLin[p2 - ww m, ww, d - m + 1] *
  Binomial[A2 + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}]

(* === MAIN ANALYSIS === *)
Print["===== BORN ORDER ANALYSIS ====="];
Do[
  d = dd; j = A2 + 2 + d;
  simple = Table[simpleF[d, s], {s, 0, 21}];
  actual = d2actual[[j + 1]];
  residual = actual - simple;
  isExact = residual === Table[0, 22];

  o1 = born1[[j + 1]]; o2 = born2[[j + 1]];
  o3 = born3[[j + 1]]; o4 = born4[[j + 1]];
  atEq = allT[[j + 1]] === t2ref[[j + 1]];

  Print["d=", d, " (row ", j, "): allT=T2? ", atEq,
    If[isExact, " simple=EXACT", " residual[0]=" <> ToString[residual[[1]]]]];
  Print["  |O1|=", Max[Abs[o1]], " |O2|=", Max[Abs[o2]],
    " |O3|=", Max[Abs[o3]], " |O4|=", Max[Abs[o4]]];

  (* Does born1_D4 (= bD) alone reproduce the simple formula? *)
  If[atEq,
    Print["  bD==simple? ", bD[[j + 1]] === simple];
    If[!isExact,
      stdBorn = (bA + bB + bC)[[j + 1]];
      Print["  bA+bB+bC==residual? ", stdBorn === residual];
      (* First-order Born prediction *)
      bornPred = bD[[j + 1]] + stdBorn;
      Print["  Born1 total==actual? ", (born1[[j + 1]]) === actual];
      Print["  Born1 residual from actual: ", Max[Abs[actual - born1[[j + 1]]]]]]];
  Print[""],
  {dd, 0, 10}];

(* === KEY: for d >= q1, does the FIRST-ORDER capture the residual? === *)
Print["===== FIRST-ORDER BORN vs ACTUAL (d >= q1) ====="];
Do[
  d = dd; j = A2 + 2 + d;
  actual = d2actual[[j + 1]];
  bornFirst = born1[[j + 1]];
  bornAll = (born1 - born2 + born3 - born4)[[j + 1]];

  errFirst = Max[Abs[actual - bornFirst]];
  errAll = Max[Abs[actual - bornAll]];

  Print["d=", d, ": |actual|=", Max[Abs[actual]],
    " |Born1 err|=", errFirst,
    " |BornAll err|=", errAll,
    " Born1 frac=", If[Max[Abs[actual]] > 0, N[errFirst / Max[Abs[actual]], 4], 0]],
  {dd, q1, q1 + 8}];
Print[""];

(* === STRUCTURE of bA (T4.T3.T2.D1) at d=q1 === *)
Print["===== bA STRUCTURE (T.T.T.D1) ====="];
Print["dSB1 nonzero rows: ",
  Select[Range[26], dSB1[[#]] =!= Table[0, 22] &] - 1];

(* bA[j] = sum_t tSB4.tSB3.tSB2[j,t] * dSB1[t,:] *)
(* tSB4.tSB3.tSB2 = Toeplitz with param (10)+(8)+1+(8)+1 = 28 *)
(* (composing T(10).T(8).T(8) via Vandermonde) *)
composedT = tSB4 . tSB3 . tSB2;
refT28 = Table[toep[28, j, s], {j, 0, 38}, {s, 0, 21}];
Print["T4.T3.T2 == T(28)? ", composedT === refT28];
Print[""];

(* So bA[j,:] = sum_{t in corr rows of dSB1} T(28)[j,t] * dSB1[t,:] *)
corrRowsD1 = Select[Range[26], dSB1[[#]] =!= Table[0, 22] &] - 1; (* {22,23,24,25} *)
Print["bA[j,:] = sum over t in ", corrRowsD1, " of C(28+j-t, j-t) * dSB1[t,:]"];

Do[d = dd; j = A2 + 2 + d;
  predicted = Table[
    Sum[toep[28, j, t] * dSB1[[t + 1, s + 1]], {t, corrRowsD1}], {s, 0, 21}];
  actual = bA[[j + 1]];
  Print["d=", d, ": predicted==actual? ", predicted === actual,
    " first 3: pred=", predicted[[1 ;; 3]], " act=", actual[[1 ;; 3]]],
  {dd, q1 - 1, q1 + 3}];
Print[""];

(* === Similarly for bB === *)
(* bB = T4.T3.D2.T1 *)
(* D2.T1 = dSB2 . tSB1 *)
d2t1 = dSB2 . tSB1; (* 30x22 *)
corrRowsD2t1 = Select[Range[30], d2t1[[#]] =!= Table[0, 22] &] - 1;
Print["dSB2.tSB1 nonzero rows: ", corrRowsD2t1];

(* T4.T3 = Toeplitz param 10+8+1 = 19 *)
composedT43 = tSB4 . tSB3;
refT19 = Table[toep[19, j, s], {j, 0, 38}, {s, 0, 29}];
Print["T4.T3 == T(19)? ", composedT43 === refT19];

(* bB[j,:] = sum over t in corrRowsD2t1 of T(19)[j,t] * d2t1[t,:] *)
Do[d = dd; j = A2 + 2 + d;
  predicted = Table[
    Sum[toep[19, j, t] * d2t1[[t + 1, s + 1]], {t, corrRowsD2t1}], {s, 0, 21}];
  actual = bB[[j + 1]];
  Print["d=", d, ": bB predicted==actual? ", predicted === actual],
  {dd, q1, q1 + 2}];
Print[""];

(* === bC === *)
(* bC = T4.D3.T2.T1 *)
(* T2.T1 = T(8+8+1) = T(17) *)
(* D3.(T2.T1) = dSB3 . (tSB2.tSB1) *)
t21 = tSB2 . tSB1; (* 30x22 *)
refT17 = Table[toep[17, j, s], {j, 0, 29}, {s, 0, 21}];
Print["T2.T1 == T(17)? ", t21 === refT17];

d3t21 = dSB3 . t21; (* 34x22 *)
corrRowsD3t21 = Select[Range[34], d3t21[[#]] =!= Table[0, 22] &] - 1;
Print["dSB3.(T2.T1) nonzero rows: ", corrRowsD3t21];

(* bC[j,:] = sum over t of T(10)[j,t] * d3t21[t,:] *)
Do[d = dd; j = A2 + 2 + d;
  predicted = Table[
    Sum[toep[10, j, t] * d3t21[[t + 1, s + 1]], {t, corrRowsD3t21}], {s, 0, 21}];
  actual = bC[[j + 1]];
  Print["d=", d, ": bC predicted==actual? ", predicted === actual],
  {dd, q1, q1 + 2}];
Print[""];

Print["===== DONE ====="];
