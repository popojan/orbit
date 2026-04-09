(* Q1: BORN EXPANSION v2 — focused computation *)
(* Key question: can we PREDICT the d >= q1 corrections? *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

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

(* === Build M2 and its Toeplitz reference === *)
M2 = blockTransferActual[initDim2, alpha, p1 + p2, p1 + 2 p2];
T2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 21}];
D2actual = T2 - M2; (* actual total correction *)

(* Simple formula *)
simpleFormula[d_, s_] := Sum[vLin[p2 - ww m, ww, d - m + 1] *
  Binomial[A2 + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}]

(* === Find rise positions to define sub-block boundaries === *)
rises = {};
prevS = Floor[(p1 + p2)/alpha];
Do[curS = Floor[x/alpha];
  If[curS > prevS, AppendTo[rises, x]]; prevS = curS,
  {x, p1 + p2 + 1, p1 + 2 p2}];
Print["17 rises: ", rises];

(* Sub-blocks by rise groups *)
(* SB1: first q1=4 rises (50,52,54,56), columns 48-58 *)
(* SB2: next q1=4 rises (59,61,63,65), columns 59-67 *)
(* SB3: next q1=4 rises (68,70,72,74), columns 68-76 *)
(* SB4: last q0+q1=5 rises (77,79,81,83,85), columns 77-85 *)
(* But the boundary between SB1 and SB2 is at the column AFTER the last *)
(* rise of SB1. Last rise of SB1 = 56, then stair until 58. *)

(* Build directly: process column ranges *)
SB1 = blockTransferActual[22, alpha, 47, 58];  (* 26x22, 4 rises *)
SB2 = blockTransferActual[26, alpha, 58, 67];  (* 30x26, 4 rises *)
SB3 = blockTransferActual[30, alpha, 67, 76];  (* 34x30, 4 rises *)
SB4 = blockTransferActual[34, alpha, 76, 85];  (* 39x34, 5 rises *)

Print["Dims: SB1=", Dimensions[SB1], " SB2=", Dimensions[SB2],
  " SB3=", Dimensions[SB3], " SB4=", Dimensions[SB4]];
Print["Composition check: ", SB4 . SB3 . SB2 . SB1 === M2];
Print[""];

(* === Toeplitz parts === *)
(* Standard SBs: each processes p1=9 columns, Toeplitz param = p1-1 = 8 *)
(* BUT: SB1 processes 47→58 = 11 columns, not 9! *)
(* The issue: sub-blocks include within-stair columns too *)
(* Actual column count: SB1 = 58-47 = 11, SB2 = 67-58 = 9, SB3 = 76-67 = 9, SB4 = 85-76 = 9+? *)

(* For the Toeplitz, what matters is the TOTAL horizontal displacement *)
(* SB1: 11 cols with 4 rises. Within each stair, L^w gives Toeplitz(w-1) *)
(* After all operations: Toeplitz param = total_cols - 1 *)

(* Let me compute the Toeplitz directly from the sub-block structure *)
(* SB[j,s] = T[j,s] for j <= d0, where d0 = input dim *)
(* So T_SBi[j,s] = SBi[j,s] for small j *)

(* Actually: the Toeplitz for a sub-block that processes N columns with R rises *)
(* is C(N-1+j-s, j-s) = C(ncols-1+j-s, j-s) *)
ncols1 = 58 - 47; (* 11 *)
ncols2 = 67 - 58; (* 9 *)
ncols3 = 76 - 67; (* 9 *)
ncols4 = 85 - 76; (* 9 *)
Print["Column counts: SB1=", ncols1, " SB2=", ncols2,
  " SB3=", ncols3, " SB4=", ncols4];
Print["Total: ", ncols1 + ncols2 + ncols3 + ncols4, " = ", 85 - 47,
  " (should be ", p1 + 2 p2 - (p1 + p2), " = ", p2, ")"];

(* Build Toeplitz matrices *)
TSB1 = Table[Binomial[ncols1 - 1 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
TSB2 = Table[Binomial[ncols2 - 1 + j - s, j - s], {j, 0, 29}, {s, 0, 25}];
TSB3 = Table[Binomial[ncols3 - 1 + j - s, j - s], {j, 0, 33}, {s, 0, 29}];
TSB4 = Table[Binomial[ncols4 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 33}];

(* Verify: Toeplitz matches sub-block for small rows *)
Print["TSB1 matches SB1 for rows 0..22? ",
  TSB1[[1 ;; 23]] === SB1[[1 ;; 23]]];
Print["TSB2 matches SB2 for rows 0..26? ",
  TSB2[[1 ;; 27]] === SB2[[1 ;; 27]]];
Print["TSB3 matches SB3 for rows 0..30? ",
  TSB3[[1 ;; 31]] === SB3[[1 ;; 31]]];
Print["TSB4 matches SB4 for rows 0..34? ",
  TSB4[[1 ;; 35]] === SB4[[1 ;; 35]]];
Print[""];

(* Correction matrices *)
DSB1 = TSB1 - SB1;
DSB2 = TSB2 - SB2;
DSB3 = TSB3 - SB3;
DSB4 = TSB4 - SB4;

(* Where are corrections? *)
Print["===== CORRECTION ROWS ====="];
Do[{name, mat, dim0} = sb;
  nonzero = Select[Range[Length[mat]],
    mat[[#]] =!= Table[0, Dimensions[mat][[2]]] &] - 1;
  Print[name, ": nonzero at rows ", nonzero],
  {sb, {{"DSB1", DSB1, 22}, {"DSB2", DSB2, 26},
    {"DSB3", DSB3, 30}, {"DSB4", DSB4, 34}}}];
Print[""];

(* === ALL-TOEPLITZ PRODUCT === *)
allT = TSB4 . TSB3 . TSB2 . TSB1; (* 39x22 *)
Print["allT dims: ", Dimensions[allT]];
Print["allT matches T2? ", allT === T2];
(* Expected: NO (finite-dim effects) *)
discRows = Select[Range[39], allT[[#]] =!= T2[[#]] &] - 1;
Print["Discrepancy rows: ", discRows];
Print[""];

(* === BORN EXPANSION === *)
(* M2 = (TSB4-DSB4)(TSB3-DSB3)(TSB2-DSB2)(TSB1-DSB1) *)
(* = allT - born1 + born2 - born3 + born4 *)

(* First order terms *)
b1a = TSB4 . TSB3 . TSB2 . DSB1;
b1b = TSB4 . TSB3 . DSB2 . SB1;  (* use actual SB1, not TSB1! *)
b1c = TSB4 . DSB3 . SB2 . SB1;
b1d = DSB4 . SB3 . SB2 . SB1;

(* Wait: for a proper Born expansion, each term replaces ONE SBi *)
(* with Di, and keeps the REST as ACTUAL SBi (not Toeplitz). *)
(* This gives the EXACT contribution of each sub-block's correction. *)

(* Method: compute M2 with one sub-block replaced by its Toeplitz *)
M2_noD1 = SB4 . SB3 . SB2 . TSB1;     (* remove D1 *)
M2_noD2 = SB4 . SB3 . TSB2 . SB1;     (* remove D2 *)
M2_noD3 = SB4 . TSB3 . SB2 . SB1;     (* remove D3 *)
M2_noD4 = TSB4 . SB3 . SB2 . SB1;     (* remove D4 *)
M2_allT2 = TSB4 . TSB3 . TSB2 . TSB1;  (* remove all *)

(* Exact contribution of each sub-block's correction *)
contrib1 = M2 - M2_noD1;  (* what D1 adds *)
contrib2 = M2 - M2_noD2;
contrib3 = M2 - M2_noD3;
contrib4 = M2 - M2_noD4;

Print["===== EXACT CONTRIBUTION OF EACH SUB-BLOCK ====="];
Do[{name, mat} = sb;
  nonzero = Select[Range[39], mat[[#]] =!= Table[0, 22] &] - 1;
  Print[name, ": ", Length[nonzero], " nonzero rows, first=",
    If[nonzero =!= {}, First[nonzero], "none"],
    " last=", If[nonzero =!= {}, Last[nonzero], "none"]],
  {sb, {{"D1 contrib", contrib1}, {"D2 contrib", contrib2},
    {"D3 contrib", contrib3}, {"D4 contrib", contrib4}}}];
Print[""];

(* === COMPARE: simple formula vs D4 contribution === *)
Print["===== D4 CONTRIBUTION vs SIMPLE FORMULA ====="];
(* The simple formula should capture D4's contribution *)
(* Note: contribution is relative to M2, simple formula is relative to T2 *)
(* So we need: simple = T2 - M2_noD4 correction part *)
(* Actually: D4_contrib = M2 - M2_noD4 *)
(* And: T2 - M2 = total correction *)
(* T2 - M2_noD4 = total correction without D4's effect *)
(* D4_contrib[j] = (T2-M2_noD4)[j] - (T2-M2)[j]... no: *)
(* M2 = M2_noD4 + contrib4, so T2-M2 = (T2-M2_noD4) - contrib4 *)
(* contrib4 = (T2-M2_noD4) - (T2-M2) = D2actual_noD4 - D2actual... hmm *)
(* Simpler: contrib4[j] = M2[j] - M2_noD4[j] *)

(* The simple formula predicts D2actual[j] for d < q1 *)
(* Is D2actual = -contrib4 + (allT - T2) for these rows? *)
(* D2actual = T2 - M2 = T2 - SB4.SB3.SB2.SB1 *)
(* contrib4 = M2 - M2_noD4 = SB4.SB3.SB2.SB1 - TSB4.SB3.SB2.SB1 *)
(*          = (SB4 - TSB4).SB3.SB2.SB1 = -DSB4.SB3.SB2.SB1 *)

Print["Direct D4 contribution: -DSB4 . SB3 . SB2 . SB1"];
direct_D4 = -DSB4 . SB3 . SB2 . SB1; (* note: negative because DSB4 = T-SB4 *)
Print["contrib4 == direct_D4? ", contrib4 === direct_D4];
Print[""];

(* Now: what about the relationship to T2 - allT ? *)
(* T2 - M2 = T2 - allT + (allT - M2) *)
(*         = (T2 - allT) + (allT - M2) *)
(* allT - M2 = born expansion of corrections *)
(* T2 - allT = discrepancy from finite Toeplitz composition *)

Print["===== DECOMPOSITION OF TOTAL CORRECTION ====="];
finiteDiscr = T2 - allT; (* finite-dim Toeplitz composition error *)
bornTotal = allT - M2;    (* corrections from sub-block Di's *)

Print["T2 - M2 = (T2 - allT) + (allT - M2)"];
Print["Verify: ", (finiteDiscr + bornTotal) === D2actual];
Print[""];

(* Where does each part contribute? *)
fdRows = Select[Range[39], finiteDiscr[[#]] =!= Table[0, 22] &] - 1;
btRows = Select[Range[39], bornTotal[[#]] =!= Table[0, 22] &] - 1;
Print["Finite discrepancy rows: ", fdRows];
Print["Born total rows: ", btRows];
Print[""];

(* === THE KEY CHECK === *)
(* For d=0..q1-1 (rows 22-25): simple formula captures everything *)
(* For d=q1..2q1-1 (rows 26-29): what's the structure? *)

Print["===== ROW-BY-ROW ANALYSIS at d >= q1 ====="];
Do[
  d = dd; j = A2 + 2 + d; (* j = 22+d *)
  simple = Table[simpleFormula[d, s], {s, 0, 21}];
  actual = D2actual[[j + 1]];
  residual = actual - simple;
  fd = finiteDiscr[[j + 1]];
  bt = bornTotal[[j + 1]];
  c4 = -contrib4[[j + 1]]; (* negative sign: contrib4 = M2 - M2_noD4 *)

  Print["--- d=", d, " (row ", j, ") ---"];
  If[residual === Table[0, 22],
    Print["  Simple formula EXACT"],
    (* else *)
    Print["  Residual[0..3] = ", residual[[1 ;; 4]]];
    Print["  Finite discr[0..3] = ", fd[[1 ;; 4]]];
    Print["  Born total[0..3] = ", bt[[1 ;; 4]]];
    Print["  D4 contrib[0..3] = ", c4[[1 ;; 4]]];
    Print["  Residual == finite_discr + born_std? ",
      residual === fd + bt + c4 - simple];
    (* Check: D1+D2+D3 born contributions *)
    std123 = -(contrib1 + contrib2 + contrib3)[[j + 1]];
    Print["  D1+D2+D3 born[0..3] = ", std123[[1 ;; 4]]];
    Print["  residual == std123 + fd? ",
      residual === std123 + fd]],
  {dd, 0, 10}];
Print[""];

(* === INDIVIDUAL STANDARD CONTRIBUTIONS at d=q1 === *)
Print["===== INDIVIDUAL CONTRIBUTIONS at d=q1=", q1, " (row ", A2 + 2 + q1, ") ====="];
j = A2 + 2 + q1;
Print["D1 contrib: ", -contrib1[[j + 1, 1 ;; 6]]];
Print["D2 contrib: ", -contrib2[[j + 1, 1 ;; 6]]];
Print["D3 contrib: ", -contrib3[[j + 1, 1 ;; 6]]];
Print["D4 contrib: ", -contrib4[[j + 1, 1 ;; 6]]];
Print["Finite discr: ", finiteDiscr[[j + 1, 1 ;; 6]]];
Print["Sum D1+D2+D3+D4+fd: ",
  (-contrib1 - contrib2 - contrib3 - contrib4 + finiteDiscr)[[j + 1, 1 ;; 6]]];
Print["Actual D2: ", D2actual[[j + 1, 1 ;; 6]]];
Print[""];

(* === CHECK if sum of ALL individual contributions = total === *)
totalReconstructed = -contrib1 - contrib2 - contrib3 - contrib4;
Print["Sum of individual contribs = allT - M2? ",
  totalReconstructed === bornTotal];
(* This should NOT be true because individual contribs have cross-terms *)
(* The individual contribs are NOT additive *)

(* Better: check additivity *)
(* M2 = SB4.SB3.SB2.SB1 *)
(* M2_noD1 = SB4.SB3.SB2.TSB1 *)
(* contrib1 = M2 - M2_noD1 = SB4.SB3.SB2.(SB1-TSB1) = -SB4.SB3.SB2.DSB1 *)
(* This IS exact (no cross-terms) because only SB1 is changed *)

(* So: contrib1 + contrib2 + contrib3 + contrib4 = M2 - M2_noD1 + ... *)
(* But these are NOT additive: changing D1 affects D2's contribution *)
(* The EXACT decomposition: *)
(* allT - M2 = contrib of ALL corrections = non-additive *)

(* Let me check explicitly *)
Print["Individual contribs are additive? ", totalReconstructed === bornTotal];

(* If not, what's the cross-term structure? *)
crossTerm = bornTotal - totalReconstructed;
crossRows = Select[Range[39], crossTerm[[#]] =!= Table[0, 22] &] - 1;
Print["Cross-term nonzero rows: ", crossRows];
If[crossRows =!= {},
  Print["First cross-term row ", First[crossRows], ": ",
    crossTerm[[First[crossRows] + 1, 1 ;; 4]]]];
Print[""];

Print["===== DONE ====="];
