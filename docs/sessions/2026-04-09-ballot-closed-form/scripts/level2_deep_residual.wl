(* DEEP RESIDUAL: understand d >= q1 corrections at level 2 *)
(* Key idea: M2 = M1_anom . M1^3, so corrections come from  *)
(* composing (T1 - D1) blocks. The residual should involve  *)
(* PRODUCTS of level-1 corrections propagated by Toeplitz.   *)

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

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat], {w, pattern}];
  mat
]

alpha = Sqrt[5];
ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
initDim2 = q1 + q2 + 1; (* 22 *)
a2k = initDim2 - 2; (* 20 *)

(* === Build M2 from sub-blocks === *)
Print["=== Decomposing M2 into sub-block transfers ==="];

(* Actual stair widths between 47 and 85 *)
rises = {}; prevS = Floor[47/alpha];
Do[curS = Floor[x/alpha]; If[curS > prevS, AppendTo[rises, x]]; prevS = curS,
  {x, 48, 85}];
Print["17 rises at: ", rises];

(* Group into sub-blocks *)
(* From the actual pattern: {3,2,2,2, 3,2,2,2, 3,2,2,2, 3,2,2,2,2} *)
(* Sub-block 1: rises 1-4 (heights 22-25), Sub-block 2: rises 5-8 (h26-29) *)
(* Sub-block 3: rises 9-12 (h30-33), Sub-block 4: rises 13-17 (h34-38) *)

(* Each sub-block starts from the END of previous sub-block *)
subBlockEnds = {rises[[4]], rises[[8]], rises[[12]], 85};
(* Wait: sub-block ends at last column before next sub-block *)
(* Sub-block 1: x=48..56 (through rise 4), Sub-block 2: x=57..65, etc. *)

(* Actually: look at stair widths *)
widths = {};
Do[curS = Floor[x/alpha];
  If[curS > prevS2, AppendTo[widths, x - lastRise]; lastRise = x];
  prevS2 = curS,
  {x, 48, 85}] /. {prevS2 -> Floor[47/alpha], lastRise -> 47};

(* Simpler: compute from rise positions *)
risesFull = Prepend[rises, 47]; (* add start *)
stairWidths = Differences[Append[risesFull, 86]]; (* widths including end *)
(* Actually: width of stair k = rise_{k+1} - rise_k *)
(* But for blockTransfer, width includes the rise column *)
(* blockTransfer width = gap between consecutive rises *)
widthsBT = Differences[risesFull];
Print["Stair widths (blockTransfer convention): ", widthsBT];
Print[""];

(* The pre-rise part: 2 columns at height 21 *)
preRise = First[rises] - 48;
Print["Pre-rise columns: ", preRise]; (* should be 2 *)
Print[""];

(* Build M2 as: sub-blocks composed *)
(* Sub-block boundaries: every q1=4 rises, last has q1+q0=5 *)
(* Standard sub-block: 4 rises, pattern from actual staircase *)
(* Sub-block 1: widths of stairs 1-4 *)
(* Sub-block 2: widths of stairs 5-8 *)
(* etc. *)

(* But including pre-rise, the full transfer is: *)
(* L_21^preRise . (sub-block 4) . (sub-block 3) ... wrong order *)
(* Actually: process left-to-right *)
(* Pre-rise: within-stair at height 21, 2 columns *)
(* Then 17 rises with their widths *)

(* Let me build each sub-block transfer matrix individually *)
(* Sub-block 1: starts at dim 22, has rises at x=50,52,54,56 *)
(* But first there are 2 pre-rise columns *)

(* Actually, let me think about this differently *)
(* The FULL transfer is: process columns 48..85 in order *)
(* I want to FACTORIZE this into sub-block transfers *)

(* A sub-block of 4 rises takes dim d to d+4 *)
(* A sub-block of 5 rises takes dim d to d+5 *)
(* Pre-rise takes dim d to dim d (just L^w multiplications) *)

(* Full decomposition: *)
(* Step 1: Pre-rise (2 within-stair cols at height 21): L_21^2 on dim 22 *)
(* Step 2: Sub-block 1 (4 rises, widths {2,2,2,3}): dim 22 -> 26 *)
(* Step 3: Sub-block 2 (4 rises, widths {2,2,2,3}): dim 26 -> 30 *)
(* Step 4: Sub-block 3 (4 rises, widths {2,2,2,3}): dim 30 -> 34 *)
(* Step 5: Sub-block 4 (5 rises, widths {2,2,2,2,?}): dim 34 -> 39 *)
(* But what's the last width? Rise at x=85 leaves 0 columns *)
(* So sub-block 4 widths: {2,2,2,2,1}? *)

(* Let me compute sub-block widths from the actual rises *)
(* Rises: {50,52,54,56, 59,61,63,65, 68,70,72,74, 77,79,81,83,85} *)

(* Sub-block 1: rises 50,52,54,56 *)
(* Widths: 50-47(adjusted)=3... wait, let me think in blockTransfer terms *)
(* After pre-rise (x=48,49), the first rise is at x=50 *)
(* Sub-block 1 processes rises at x=50,52,54,56 *)
(* Width of first stair (from pre-rise end to second rise): 52-50=2 *)
(* Width = next_rise - this_rise for interior, and next_rise - this_rise for last *)
sb1widths = {52 - 50, 54 - 52, 56 - 54, 59 - 56}; (* {2,2,2,3} *)
sb2widths = {61 - 59, 63 - 61, 65 - 63, 68 - 65}; (* {2,2,2,3} *)
sb3widths = {70 - 68, 72 - 70, 74 - 72, 77 - 74}; (* {2,2,2,3} *)
sb4widths = {79 - 77, 81 - 79, 83 - 81, 85 - 83, 86 - 85}; (* {2,2,2,2,1} *)
(* Wait, there's no column after 85, so the last width should reflect that *)
(* The rise at x=85 contributes 1 column (just the rise, no within-stair) *)
(* blockTransfer width 1 = rise only, no L^{w-1} *)

Print["Sub-block widths:"];
Print["  SB1: ", sb1widths, " (standard, 4 rises)"];
Print["  SB2: ", sb2widths, " (standard, 4 rises)"];
Print["  SB3: ", sb3widths, " (standard, 4 rises)"];
Print["  SB4: ", sb4widths, " (anomalous, 5 rises)"];
Print[""];

(* Build transfer matrices for each sub-block *)
(* Pre-rise: L_21^2 on 22-dim *)
Lpre = MatrixPower[Lmat[21], 2];

(* Sub-block transfers *)
SB1 = blockTransfer[22, sb1widths];
SB2 = blockTransfer[26, sb2widths];
SB3 = blockTransfer[30, sb3widths];
SB4 = blockTransfer[34, sb4widths];

Print["Sub-block dims: SB1=", Dimensions[SB1], " SB2=", Dimensions[SB2],
  " SB3=", Dimensions[SB3], " SB4=", Dimensions[SB4]];

(* Compose: M2 = SB4 . SB3 . SB2 . SB1 . Lpre *)
M2composed = SB4 . SB3 . SB2 . SB1 . Lpre;
Print["M2 composed dims: ", Dimensions[M2composed]];

(* Compare with actual M2 *)
M2actual = blockTransferActual[22, alpha, 47, 85];
Print["M2 composed = M2 actual? ", M2composed === M2actual];
Print[""];

(* === Now: Toeplitz decomposition of each sub-block === *)
(* Standard sub-block (4 rises, pattern {2,2,2,3}): T - D *)
(* But the Toeplitz part has entries C(p1-1+j-s, j-s) *)
(* And the correction is our known level-1 formula *)

(* For SB1 (dim 22 -> 26): T1[j,s] = C(p1-1+j-s, j-s) = C(8+j-s, j-s) *)
(* Wait, the sub-block has 9 columns (4 rises) but starts at dim 22 *)
(* The Toeplitz for a block of width p1=9 starting at dim 22 is: *)
(* T1_SB[j,s] = C(8+j-s, j-s) for j=0..25, s=0..21 *)

T_SB1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
D_SB1 = T_SB1 - SB1;
corr_SB1 = Select[Range[0, 25], D_SB1[[# + 1]] =!= Table[0, 22] &];
Print["SB1 correction rows: ", corr_SB1];

(* For the standard sub-block from dim 5, the correction is at j=6,7,8 *)
(* For dim 22, correction should be at j=23,24,25 (= dim+1, dim+2, dim+3)? *)
(* Actually, from our level-1 analysis: A1 = dim-1, correction at A1+2 = dim+1 *)
Print["Expected SB1 correction start: j=", 22 + 1, " (dim+1)"];
Print[""];

(* Let me check SB1 correction structure *)
If[corr_SB1 =!= {},
  Print["SB1 correction values:"];
  Do[j = corr_SB1[[i]];
    Print["  j=", j, ": ", D_SB1[[j + 1, 1 ;; Min[6, 22]]], "..."],
    {i, 1, Min[3, Length[corr_SB1]]}]
];
Print[""];

(* === KEY: compute T2 - (T_SB4 . T_SB3 . T_SB2 . T_SB1 . Lpre) === *)
(* The Toeplitz composition should give T2 by Vandermonde convolution *)
(* And the corrections should give the level-2 Delta *)

(* T for each sub-block (as infinite/large Toeplitz matrix) *)
(* T_SB_k[j,s] = C(p_block-1+j-s, j-s) *)
(* For standard blocks: p_block = p1 = 9 *)
(* For anomalous block: p_block = p1+p0 = 11 *)

(* But we also need to account for the pre-rise *)
(* Pre-rise is L_21^2 which is equivalent to within-stair of width 2 *)
(* As a Toeplitz: C(2-1+j-s, j-s) = C(1+j-s, j-s) = 1 for j >= s, 0 otherwise *)
(* Wait: L^2 has entries C(j-s+1, 1) for j >= s *)
(* No: L^w has entries C(j-s+w-1, w-1) *)
(* L^2 entries: C(j-s+1, 1) = j-s+1 for j >= s *)

(* The FULL Toeplitz should be: *)
(* T2 = T_anom . T_std^3 . T_pre *)
(* where T_pre has entries C(1+j-s, 1) = (j-s+1) *)
(* and T_std has entries C(8+j-s, j-s) *)
(* and T_anom has entries C(10+j-s, j-s) *)

(* By Vandermonde: T_pre . T_std^3 . T_anom should give *)
(* C(1+8*3+10+j-s, j-s)? No, that's not right *)

(* Actually, convolution of Toeplitz: *)
(* T_a with entries C(a+j-s, j-s), T_b with C(b+j-s, j-s) *)
(* Product (T_a . T_b)[j,s] = Sum_t C(a+j-t, j-t) C(b+t-s, t-s) *)
(* = C(a+b+1+j-s, j-s) by Vandermonde *)

(* So T_pre(a=1) . T_std(a=8)^3 . T_anom(a=10) = *)
(* T(1+8+1+8+1+8+1+10 = 38-1 = 37) ... hmm *)

(* Let me verify: C(37+j-s, j-s) should be T2 *)
(* T2[j,s] = C(p2-1+j-s, j-s) = C(37+j-s, j-s). Yes! *)

(* Convolution chain: *)
(* T_pre(1) . T_std(8) . T_std(8) . T_std(8) . T_anom(10) *)
(* = T(1+8+1+8+1+8+1+10) = T(38) ... wait *)

(* Sum of a-values: 1 (pre) + 8 (std) + 8 (std) + 8 (std) + 10 (anom) = 35 *)
(* Plus (k-1) from the k compositions? *)
(* Actually: T_a . T_b = T_{a+b+1} *)
(* So T_pre . T_std = T_{1+8+1} = T_{10} *)
(* T_{10} . T_std = T_{10+8+1} = T_{19} *)
(* T_{19} . T_std = T_{19+8+1} = T_{28} *)
(* T_{28} . T_anom = T_{28+10+1} = T_{39}? But we want T_{37}! *)

(* Hmm, 39 ≠ 37. Let me recheck the Vandermonde convolution. *)
(* (T_a . T_b)[j,s] = Sum_t C(a+j-t, j-t) C(b+t-s, t-s) *)
(* Using standard Vandermonde-Chu: = C(a+b+j-s+1, j-s) ? *)
(* Let me verify: Sum_t C(a+j-t, j-t) C(b+t-s, t-s) *)
(* Let u = t-s: Sum_u C(a+j-s-u, j-s-u) C(b+u, u) *)
(* = C(a+b+j-s+1, j-s) by Vandermonde-Chu with x=j-s *)

(* So T_a . T_b = T_{a+b+1}. And: *)
(* T_1 . T_8 = T_{10} *)
(* T_{10} . T_8 = T_{19} *)
(* T_{19} . T_8 = T_{28} *)
(* T_{28} . T_{10} = T_{39}. But p2-1 = 37, so T_{37} ≠ T_{39}! *)

(* The discrepancy is 2 = preRise. *)
(* Pre-rise is L^2 = MatrixPower[Lmat[21], 2], NOT a Toeplitz matrix! *)
(* L^2 has entries C(j-s+1, 1) for j >= s, which IS Toeplitz with a=1 *)
(* But wait: Lmat[21] is (22x22), not infinite. The Toeplitz property *)
(* only holds for the upper-left block. *)

(* Hmm, actually the issue might be that the pre-rise operates on the *)
(* SAME dimension (no rise), while the Toeplitz abstraction assumes *)
(* the full infinite matrix. *)

(* Let me just skip the Toeplitz factorization and focus on the *)
(* sub-block decomposition of the CORRECTION Delta. *)

Print["=== Sub-block correction interaction analysis ==="];

(* M2 = SB4 . SB3 . SB2 . SB1 . Lpre *)
(* Each SB_i = T_i - D_i where T_i is Toeplitz part of sub-block i *)
(* M2 = (T4-D4)(T3-D3)(T2-D2)(T1-D1) . Lpre *)

(* First-order correction: -Sum_i T4...T_{i+1} . D_i . T_{i-1}...T1 . Lpre *)
(* This is the contribution from SINGLE sub-block corrections *)

(* Let's compute: how much of M2's correction comes from each sub-block? *)
(* Replace each SB_i with its Toeplitz part and see the effect *)

(* M2_noCorr = T4 . T3 . T2 . T1 . Lpre *)
T_SB = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
(* All standard sub-blocks have same Toeplitz *)
(* But different dimensions! *)

(* Let me just compute each contribution numerically *)
(* Replace SB1 with T_SB1 and keep the rest *)
M2_noSB1 = SB4 . SB3 . SB2 . T_SB1 . Lpre;
corr_from_SB1 = M2actual - M2_noSB1;

(* Replace SB2 with T_SB2 *)
T_SB2 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 29}, {s, 0, 25}];
M2_noSB2 = SB4 . SB3 . T_SB2 . SB1 . Lpre;
corr_from_SB2 = M2actual - M2_noSB2;

(* Replace SB3 with T_SB3 *)
T_SB3 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 33}, {s, 0, 29}];
M2_noSB3 = SB4 . T_SB3 . SB2 . SB1 . Lpre;
corr_from_SB3 = M2actual - M2_noSB3;

(* Contribution from SB4 anomaly *)
T_SB4 = Table[Binomial[p1 + p0 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 33}];
M2_noSB4 = T_SB4 . SB3 . SB2 . SB1 . Lpre;
corr_from_SB4 = M2actual - M2_noSB4;

(* Also: M2 with ALL Toeplitz *)
M2_allT = T_SB4 . T_SB3 . T_SB2 . T_SB1 . Lpre;

(* Delta_total *)
D2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 21}] - M2actual;

(* How many nonzero rows does each contribution have? *)
Print["Correction contribution from each sub-block:"];
Do[
  {name, corr} = block;
  nonzero = Select[Range[0, 38], corr[[# + 1]] =!= Table[0, 22] &];
  Print["  ", name, ": ", Length[nonzero], " nonzero rows, first=",
    If[nonzero =!= {}, First[nonzero], "none"]],
  {block, {{"SB1", corr_from_SB1}, {"SB2", corr_from_SB2},
    {"SB3", corr_from_SB3}, {"SB4 (anom)", corr_from_SB4}}}];
Print[""];

(* === KEY: Does the SIMPLE formula capture SB4 (anomalous) contribution? === *)
Print["=== Simple formula vs SB4 contribution ==="];

(* The simple formula should capture the contribution from the ANOMALOUS *)
(* sub-block (SB4), since it's the level-2 analogue of the anomalous stair *)
(* The residual should come from SB1, SB2, SB3 (standard) corrections *)

simpleFormula = Table[
  Sum[vLin[p2 - ww m, ww, d - m + 1] *
    Binomial[a2k + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
  {d, 0, 16}, {s, 0, 21}];

Print["Row-by-row comparison:"];
Do[
  d = dd;
  j = a2k + 2 + d;
  actual = D2[[j + 1]];
  simple = simpleFormula[[d + 1]];
  fromSB4 = corr_from_SB4[[j + 1]];

  Print["d=", d, ": actual==simple? ", actual === simple,
    "  actual==SB4? ", actual === fromSB4,
    "  simple==SB4? ", simple === fromSB4],
  {dd, 0, Min[8, 16]}];
Print[""];

(* === Is residual = contribution from standard sub-blocks? === *)
Print["=== Residual vs standard sub-block contributions ==="];
(* Total correction from standard blocks = SB1 + SB2 + SB3 corrections *)
(* (approximately, ignoring cross-terms) *)

Do[
  d = dd;
  j = a2k + 2 + d;
  residual = D2[[j + 1]] - simpleFormula[[d + 1]];
  fromStd = corr_from_SB1[[j + 1]] + corr_from_SB2[[j + 1]] + corr_from_SB3[[j + 1]];
  If[residual =!= Table[0, 22],
    Print["d=", d, ": residual[0..2]=", residual[[1 ;; 3]],
      "  fromStd[0..2]=", fromStd[[1 ;; 3]],
      "  match? ", residual === fromStd]],
  {dd, 0, Min[10, 16]}];
