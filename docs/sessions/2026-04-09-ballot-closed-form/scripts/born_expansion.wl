(* Q1: BORN EXPANSION for d >= q1 corrections at level 2          *)
(*                                                                 *)
(* M2 = SB4 . SB3 . SB2 . SB1 . Lpre                            *)
(* Each standard SBi = Ti - Di where Ti is Toeplitz(p1-1=8)       *)
(* Di = level-1 correction (q1-1 nonzero rows)                    *)
(*                                                                 *)
(* First order: residual ≈ sum of T...T.Di.T...T.Lpre sandwiches  *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];
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

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat], {w, pattern}];
  mat
]

alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
a2 = 4; (* second partial quotient *)
initDim2 = q1 + q2 + 1; (* 22 *)
A2 = q1 + q2 - 1; (* 20: offset for level-2 correction *)

Print["===== SETUP: sqrt(5) ====="];
Print["w=", ww, " p1=", p1, " q1=", q1, " p2=", p2, " q2=", q2, " a2=", a2];
Print["initDim2=", initDim2, " A2=", A2];
Print["Simple formula valid for d=0..", q1 - 1, " (rows ", A2 + 2, "..", A2 + q1 + 1, ")"];
Print["Born expansion needed for d>=", q1, " (rows ", A2 + q1 + 2, "+)"];
Print[""];

(* === Build actual M2 and its Toeplitz decomposition === *)
M2 = blockTransferActual[initDim2, alpha, p1 + p2, p1 + 2 p2];
T2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 21}];
D2actual = T2 - M2;

(* Simple formula predictions *)
simpleRows = Table[
  Table[Sum[vLin[p2 - ww m, ww, d - m + 1] *
    Binomial[A2 + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}], {s, 0, 21}],
  {d, 0, 16}];

(* Residual beyond simple formula *)
Print["===== ACTUAL RESIDUAL vs SIMPLE FORMULA ====="];
Do[
  d = dd; j = A2 + 2 + d;
  actual = D2actual[[j + 1]];
  simple = simpleRows[[d + 1]];
  residual = actual - simple;
  isZero = residual === Table[0, 22];
  If[!isZero,
    Print["d=", d, " (row ", j, "): residual nonzero, first entries = ",
      residual[[1 ;; Min[6, 22]]]],
    Print["d=", d, " (row ", j, "): residual = 0  [simple formula exact]"]],
  {dd, 0, 12}];
Print[""];

(* === Build sub-blocks === *)
(* Stair widths computed from actual rise positions *)
rises = {}; prevS = Floor[(p1 + p2)/alpha];
Do[curS = Floor[x/alpha]; If[curS > prevS, AppendTo[rises, x]]; prevS = curS,
  {x, p1 + p2 + 1, p1 + 2 p2}];

(* Pre-rise: columns before first rise *)
preRiseWidth = First[rises] - (p1 + p2) - 1;
Print["Pre-rise width: ", preRiseWidth];
Print["Rises at: ", rises];

(* Sub-block boundary: every q1 rises *)
sbBounds = {0, q1, 2 q1, 3 q1, q2}; (* {0,4,8,12,17} *)
Print["Sub-block boundaries (rise indices): ", sbBounds];

(* Sub-block stair widths *)
risesFull = Prepend[rises, p1 + p2 + preRiseWidth]; (* adjust for blockTransfer convention *)
widthsBT = Differences[risesFull];
Print["All stair widths: ", widthsBT];

sbWidths = Table[widthsBT[[sbBounds[[i]] + 1 ;; sbBounds[[i + 1]]]], {i, 1, 4}];
Do[Print["SB", i, " widths: ", sbWidths[[i]]], {i, 1, 4}];
Print[""];

(* Build each sub-block *)
sbDims = {22, 26, 30, 34}; (* starting dimensions *)
SBs = Table[blockTransfer[sbDims[[i]], sbWidths[[i]]], {i, 1, 4}];
Lpre = MatrixPower[Lmat[initDim2 - 1], preRiseWidth + 1]; (* pre-rise + the column to first rise *)

(* Actually: let me build correctly from the actual transfer *)
(* Sub-block 1: from first rise to 4th rise *)
(* We need to process columns from (p1+p2+1) to end *)
(* But it's easier to extract from the actual computation *)

(* Build sub-blocks by processing actual columns *)
buildSB[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat
]

(* Find the exact column ranges for each sub-block *)
(* Rises: {50,52,54,56, 59,61,63,65, 68,70,72,74, 77,79,81,83,85} *)
(* Sub-block i ends at the last column before the (i+1)-th sub-block starts *)
(* Or equivalently: SB_i processes from rise_{4(i-1)+1} to rise_{4i} plus any trailing stair *)

(* Let me build it step by step from the rise structure *)
(* pre-rise: columns 48..49 (before first rise at 50) *)
(* SB1: processes 4 rises: 50,52,54,56; next rise at 59, so SB1 covers 50..58 *)
(* SB2: rises 59,61,63,65; next at 68, so covers 59..67 *)
(* SB3: rises 68,70,72,74; next at 77, so covers 68..76 *)
(* SB4: rises 77,79,81,83,85; covers 77..85 *)

Print["===== SUB-BLOCK TRANSFERS ====="];
SB1 = buildSB[22, alpha, 47, 58];
SB2 = buildSB[26, alpha, 58, 67];
SB3 = buildSB[30, alpha, 67, 76];
SB4 = buildSB[34, alpha, 76, 85];

Print["SB1: ", Dimensions[SB1], " SB2: ", Dimensions[SB2],
  " SB3: ", Dimensions[SB3], " SB4: ", Dimensions[SB4]];

(* Verify composition *)
M2check = SB4 . SB3 . SB2 . SB1;
Print["M2 = SB4.SB3.SB2.SB1 matches actual? ", M2check === M2];
Print[""];

(* === Toeplitz decomposition of each sub-block === *)
(* Standard sub-blocks: T_i[j,s] = C(p1-1+j-s, j-s) *)
(* But ONLY for the rows/cols within that sub-block's range *)

(* For SB1 (26x22): T[j,s] = C(8+j-s, j-s) for j=0..25, s=0..21 *)
T_SB1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
D_SB1 = T_SB1 - SB1;

T_SB2 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 29}, {s, 0, 25}];
D_SB2 = T_SB2 - SB2;

T_SB3 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 33}, {s, 0, 29}];
D_SB3 = T_SB3 - SB3;

(* Anomalous: T has parameter p0+p1-1 = 10 *)
T_SB4 = Table[Binomial[p0 + p1 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 33}];
D_SB4 = T_SB4 - SB4;

(* Check correction structure *)
Print["===== CORRECTION STRUCTURE OF EACH SUB-BLOCK ====="];
Do[
  {name, mat, dim0} = sb;
  nonzero = Select[Range[0, Length[mat] - 1],
    mat[[# + 1]] =!= Table[0, dim0] &];
  Print[name, ": d0=", dim0, " nonzero correction rows: ", nonzero,
    " (expected: ", dim0 + 1, "..", dim0 + q1 - 1, ")"],
  {sb, {{"D_SB1", D_SB1, 22}, {"D_SB2", D_SB2, 26},
    {"D_SB3", D_SB3, 30}, {"D_SB4", D_SB4, 34}}}];
Print[""];

(* === BORN EXPANSION: FIRST-ORDER TERMS === *)
(* M2 = SB4 . SB3 . SB2 . SB1 *)
(*    = (T4-D4)(T3-D3)(T2-D2)(T1-D1) *)
(*    = T4.T3.T2.T1 (all-Toeplitz) *)
(*      - T4.T3.T2.D1 (correction from SB1) *)
(*      - T4.T3.D2.T1 (correction from SB2) *)
(*      - T4.D3.T2.T1 (correction from SB3) *)
(*      - D4.T3.T2.T1 (correction from SB4) *)
(*      + O(D^2) *)

Print["===== BORN EXPANSION: FIRST-ORDER TERMS ====="];

(* All-Toeplitz product *)
M2_allT = T_SB4 . T_SB3 . T_SB2 . T_SB1;
Print["All-Toeplitz product matches Toeplitz(p2-1)? "];
T2ref = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 21}];
Print["  T_SB4.T_SB3.T_SB2.T_SB1 == T(37)? ", M2_allT === T2ref];

(* If not, what's the discrepancy? *)
allT_discrepancy = M2_allT - T2ref;
nonzeroAllT = Select[Range[0, 38],
  allT_discrepancy[[# + 1]] =!= Table[0, 22] &];
Print["  All-Toeplitz discrepancy rows: ", nonzeroAllT];
If[Length[nonzeroAllT] > 0,
  Print["  First discrepancy at row ", First[nonzeroAllT]];
  Print["  Values: ", allT_discrepancy[[First[nonzeroAllT] + 1, 1 ;; Min[6, 22]]]]];
Print[""];

(* First-order correction terms (sandwich T...T.Di.T...T) *)
(* These are computed by replacing ONE SBi with Di and keeping others as Ti *)
born1_SB1 = T_SB4 . T_SB3 . T_SB2 . D_SB1;
born1_SB2 = T_SB4 . T_SB3 . D_SB2 . T_SB1;
born1_SB3 = T_SB4 . D_SB3 . T_SB2 . T_SB1;
born1_SB4 = D_SB4 . T_SB3 . T_SB2 . T_SB1;

Print["First-order Born terms:"];
Do[
  {name, mat} = term;
  nonzero = Select[Range[0, 38], mat[[# + 1]] =!= Table[0, 22] &];
  Print["  ", name, ": nonzero at rows ", If[Length[nonzero] > 5,
    {First[nonzero], "...", Last[nonzero], " (", Length[nonzero], " total)"},
    nonzero]],
  {term, {{"T4.T3.T2.D1", born1_SB1}, {"T4.T3.D2.T1", born1_SB2},
    {"T4.D3.T2.T1", born1_SB3}, {"D4.T3.T2.T1", born1_SB4}}}];
Print[""];

(* Total first-order Born correction *)
born1_total = born1_SB1 + born1_SB2 + born1_SB3 + born1_SB4;

(* The actual TOTAL correction = T2 - M2 = D2actual *)
(* But T2 might differ from T_SB product, so let's compute carefully: *)
(* M2 = SB4.SB3.SB2.SB1 *)
(* All-Toeplitz = T4.T3.T2.T1 *)
(* So: M2 = (allT) - born1_total + O(D^2) *)
(* => born1_total ≈ allT - M2 *)

D2_from_allT = M2_allT - M2; (* this is the ACTUAL total correction *)
born1_error = D2_from_allT - born1_total; (* should be O(D^2) *)

Print["===== BORN EXPANSION ACCURACY ====="];
Print["Total correction (allT - M2):"];
Do[
  d = dd; j = A2 + 2 + d;
  actual = D2_from_allT[[j + 1]];
  born = born1_total[[j + 1]];
  err = born1_error[[j + 1]];
  isZero = err === Table[0, 22];
  If[!isZero,
    Print["d=", d, " (row ", j, "): Born1 error nonzero, first 4: ",
      err[[1 ;; 4]]],
    Print["d=", d, " (row ", j, "): Born1 EXACT"]],
  {dd, 0, 16}];
Print[""];

(* === Now compare with the SIMPLE FORMULA === *)
(* The simple formula = correction from SB4 (anomalous block only) *)
(* The Born expansion = correction from ALL sub-blocks *)
(* Difference = correction from standard sub-blocks *)
Print["===== SIMPLE FORMULA vs BORN EXPANSION ====="];
Print["(Check: does born1_SB4 match the simple formula?)"];

(* The simple formula correction (relative to T2) *)
(* But we need it relative to allT, which may differ from T2! *)
(* If allT = T2 for these rows, then it's the same *)

Do[
  d = dd; j = A2 + 2 + d;
  born_SB4 = born1_SB4[[j + 1]];
  simple = simpleRows[[d + 1]];
  fromAllT = D2_from_allT[[j + 1]];

  (* The simple formula is relative to T2, born is relative to allT *)
  (* Check if allT = T2 at these rows *)
  allT_row = M2_allT[[j + 1]];
  T2_row = T2ref[[j + 1]];
  T_match = allT_row === T2_row;

  Print["d=", d, ": born_SB4==simple? ", born_SB4 === simple,
    "  allT==T2? ", T_match],
  {dd, 0, 8}];
Print[""];

(* === STANDARD SUB-BLOCK CONTRIBUTIONS === *)
(* These are the NEW corrections beyond the simple formula *)
Print["===== STANDARD SUB-BLOCK BORN CORRECTIONS ====="];
born1_std = born1_SB1 + born1_SB2 + born1_SB3;

Do[
  d = dd; j = A2 + 2 + d;
  std = born1_std[[j + 1]];
  isZero = std === Table[0, 22];
  If[!isZero,
    Print["d=", d, " (row ", j, "): born_std nonzero, first 4: ",
      std[[1 ;; 4]]]],
  {dd, 0, 12}];
Print[""];

(* === Per-sub-block contributions at the critical rows === *)
Print["===== PER-SUB-BLOCK CONTRIBUTIONS (d >= q1) ====="];
Do[
  d = dd; j = A2 + 2 + d;
  Print["d=", d, " (row ", j, "):"];
  Print["  born_SB1: ", born1_SB1[[j + 1, 1 ;; 4]]];
  Print["  born_SB2: ", born1_SB2[[j + 1, 1 ;; 4]]];
  Print["  born_SB3: ", born1_SB3[[j + 1, 1 ;; 4]]];
  Print["  born_SB4: ", born1_SB4[[j + 1, 1 ;; 4]]];
  Print["  total:    ", D2_from_allT[[j + 1, 1 ;; 4]]];
  Print["  Born1:    ", born1_total[[j + 1, 1 ;; 4]]];
  Print["  error:    ", born1_error[[j + 1, 1 ;; 4]]],
  {dd, q1, Min[q1 + 5, 16]}];
Print[""];

(* === CHECK: is the Born error a SECOND-ORDER term? === *)
(* Second-order = products of TWO corrections *)
Print["===== SECOND-ORDER BORN TERMS ====="];
born2_12 = T_SB4 . T_SB3 . D_SB2 . D_SB1;
born2_13 = T_SB4 . D_SB3 . T_SB2 . D_SB1;
born2_23 = T_SB4 . D_SB3 . D_SB2 . T_SB1;
born2_14 = D_SB4 . T_SB3 . T_SB2 . D_SB1;
born2_24 = D_SB4 . T_SB3 . D_SB2 . T_SB1;
born2_34 = D_SB4 . D_SB3 . T_SB2 . T_SB1;

born2_total = born2_12 + born2_13 + born2_23 + born2_14 + born2_24 + born2_34;

(* Third order *)
born3_123 = T_SB4 . D_SB3 . D_SB2 . D_SB1;
born3_124 = D_SB4 . T_SB3 . D_SB2 . D_SB1;
born3_134 = D_SB4 . D_SB3 . T_SB2 . D_SB1;
born3_234 = D_SB4 . D_SB3 . D_SB2 . T_SB1;
born3_total = born3_123 + born3_124 + born3_134 + born3_234;

(* Fourth order *)
born4 = D_SB4 . D_SB3 . D_SB2 . D_SB1;

(* Verify: allT - M2 = born1 - born2 + born3 - born4 *)
born_total_check = born1_total - born2_total + born3_total - born4;
Print["Full Born expansion (1-2+3-4) matches allT-M2? ",
  born_total_check === D2_from_allT];
Print[""];

(* Check each order's contribution at critical rows *)
Print["Born order analysis at d=", q1, " (row ", A2 + 2 + q1, "):"];
j = A2 + 2 + q1;
Print["  Order 1: ", born1_total[[j + 1, 1 ;; 4]]];
Print["  Order 2: ", born2_total[[j + 1, 1 ;; 4]]];
Print["  Order 3: ", born3_total[[j + 1, 1 ;; 4]]];
Print["  Order 4: ", born4[[j + 1, 1 ;; 4]]];
Print["  Total:   ", D2_from_allT[[j + 1, 1 ;; 4]]];
Print[""];

Do[
  d = dd; j = A2 + 2 + d;
  o1 = Max[Abs[born1_total[[j + 1]]]];
  o2 = Max[Abs[born2_total[[j + 1]]]];
  o3 = Max[Abs[born3_total[[j + 1]]]];
  o4 = Max[Abs[born4[[j + 1]]]];
  Print["d=", d, ": |O1|=", o1, " |O2|=", o2, " |O3|=", o3, " |O4|=", o4],
  {dd, 0, 12}];
Print[""];

(* === KEY: Structure of born1_SB1 at d >= q1 === *)
(* born1_SB1 = T4.T3.T2.D1 *)
(* D1 has correction rows at 23, 24, 25 (d0=22, correction at d0+1..d0+q1-1) *)
(* T2 propagates these via Toeplitz convolution *)
(* T3 further propagates *)
(* T4 further propagates *)
(* What do the propagated corrections look like? *)

Print["===== STRUCTURE OF born1_SB1 (T4.T3.T2.D1) ====="];
Print["D_SB1 correction rows:"];
Do[
  row = D_SB1[[j + 1]];
  If[row =!= Table[0, 22],
    Print["  j=", j, ": ", row[[1 ;; Min[8, 22]]], "..."]],
  {j, 0, 25}];
Print[""];

(* Intermediate product: T2.D1 *)
intermediate_T2D1 = T_SB2 . D_SB1;
Print["T2.D1 nonzero rows:"];
Do[
  row = intermediate_T2D1[[j + 1]];
  If[row =!= Table[0, 22] && Max[Abs[row]] > 0,
    Print["  j=", j, ": ", row[[1 ;; Min[6, 22]]], "..."]],
  {j, 0, 29}];
Print[""];

Print["===== DONE ====="];
