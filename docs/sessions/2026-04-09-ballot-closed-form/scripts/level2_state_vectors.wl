(* Full state vectors at level-2 semi-convergent positions for Pi *)
(* Goal: find closed form for v_j at positions 22, 25, 47, 69, 91, ... *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

(* Compute full state vectors up to x=200 *)
dpTransferFull[alpha_, xMax_] := Module[
  {v = {1}, m = 0, prevS = 0, curS, results = <||>},
  results[1] = {0, {1}};
  Do[
    curS = Floor[x/alpha];
    If[curS == prevS,
      v = Lmat[m] . v,
      v = Lmat[m + 1] . Append[v, 0]; m++];
    prevS = curS;
    results[x] = {m, v},
    {x, 2, xMax}];
  results
]

Print["Computing state vectors for Pi up to x=200..."];
data = dpTransferFull[Pi, 200];
Print["Done."];
Print[""];

(* Level-1 semi-convergent positions (between p0=3 and p1=22) *)
(* p = 3+3j for j=0..6, then p1=22. Actually p = {3,4,7,10,13,16,19,22} *)
level1 = {3, 4, 7, 10, 13, 16, 19, 22};

(* Level-2 semi-convergent positions (between p1=22 and p2=333) *)
(* p = 3+22j for j=0..15, but also: 22, 25, 47, 69, 91, ... *)
level2 = Join[{22}, Table[3 + 22 j, {j, 1, 8}]];
(* = {22, 25, 47, 69, 91, 113, 135, 157, 179} *)

Print["=== Level-2 semi-convergent positions ==="];
Print[level2];
Print[""];

(* Extract and display state vectors *)
Print["=== Full state vectors at level-2 positions ==="];
Do[
  {m, v} = data[x];
  Print["x=", x, " m=", m, " |v|=", Length[v]];
  Print["  v = ", v];
  Print["  DP = ", Last[v]];
  Print[""],
  {x, level2}];

(* === Look for patterns in entries === *)
(* At level-1, the formula was: v_j^(k) = (3(k-j)+1)/(3k+1) * C(3k+j, j) *)
(* At level-2, what are the entries? *)

Print["=== Examining entry-by-entry patterns ==="];
Print[""];

(* Collect v_j for fixed j across level-2 positions *)
(* Note: level-2 step index: x=22 is step 0, x=25 is step 1, x=47 is step 2, etc. *)
Do[
  Print["--- Entry j=", j, " across level-2 positions ---"];
  Do[
    {m, v} = data[level2[[idx]]];
    If[j < Length[v],
      Print["  step ", idx - 1, " (x=", level2[[idx]], "): v_", j, " = ", v[[j + 1]]],
      Print["  step ", idx - 1, " (x=", level2[[idx]], "): -- (vector too short)"]],
    {idx, 1, Length[level2]}];
  Print[""],
  {j, 0, 4}];

(* === Try to express v_j in terms of binomial coefficients === *)
Print["=== Testing generalized formula at level-2 positions ==="];
Print[""];

(* At level-2, p = 3+22*s, q = 1+7*s for step s=1..8 *)
(* The ballot number at step s is B(3+22s, 1+7s) *)
(* Hypothesis: v_j at step s might be:                          *)
(*   (something)/(something) * Binomial(something+j, j)        *)

(* Let's look at ratios v_j / C(N+j, j) for various N *)
Do[
  s = idx - 1; (* step index: 0 = x=22, 1 = x=25, ... *)
  If[s <= 0, Continue[]];
  x = level2[[idx]];
  {m, v} = data[x];
  p = x;
  q = m + 1; (* q for the semi-convergent = m+1 if shadow, or m if direct *)

  (* For shadow: DP = B(p, m+1), direct: DP = B(p, m) *)
  bShadow = B[p, m + 1];
  bDirect = B[p, m];
  isShadow = (Last[v] === bShadow);

  qSC = If[isShadow, m + 1, m]; (* the q in the semi-convergent *)

  Print["Step s=", s, " x=", p, " q_SC=", qSC, " m=S(x)=", m,
    If[isShadow, " SHADOW", " DIRECT"]];

  (* Show ratios v_j * (p) / C(p+j-1, j) for each j *)
  (* This is v_j / B(p, j) *)
  Do[
    vj = v[[j + 1]];
    bpj = B[p, j];
    ratio = If[bpj =!= 0, vj / bpj, "undef"];
    Print["  j=", j, " v_j=", vj, " B(", p, ",", j, ")=", bpj,
      " ratio=", ratio],
    {j, 0, Min[3, Length[v] - 1]}];
  Print[""],
  {idx, 2, Min[5, Length[level2]]}];

(* === Direct formula test for level-1 structure embedded in level-2 === *)
(* Between level-2 semi-convergents, the stair pattern is that of p1/q1 = 22/7. *)
(* So the "block transfer" from step s to step s+1 involves a 22/7 staircase. *)
(* The level-1 formula gives entries for uniform w=3 staircases.              *)
(* The 22/7 staircase is {3,3,3,3,3,3,4} = 6×3 + 1×4.                      *)
(*                                                                             *)
(* Key idea: the 22-col block is a RATIONAL staircase Floor[7x/22].          *)
(* Path count under this from (0,0) to (22,7) = B(22,7) by Prop 1 of paper. *)
(* What about the "partial" path counts, i.e., the column of the matrix?     *)

Print["=== Transfer matrix for one 22/7 block ==="];
Print[""];

(* Build the explicit transfer matrix for the {3,3,3,3,3,3,4} pattern *)
(* Starting from a state of dimension d, produces d+7 dimensional state *)
buildBlockTransfer[d_, pattern_] := Module[
  {v, m = d - 1, dim = d, matrices = {}},
  Do[
    (* Within stair: L_m^(w-1) *)
    If[w > 1,
      AppendTo[matrices, {"stair", m, w - 1}]];
    (* Rise *)
    AppendTo[matrices, {"rise", m + 1}];
    m++; dim++,
    {w, pattern}];
  {matrices, dim}
]

{ops, finalDim} = buildBlockTransfer[1, {3, 3, 3, 3, 3, 3, 4}];
Print["Block ops: ", ops];
Print["Input dim: 1, Output dim: ", finalDim];
Print[""];

(* Apply the block to a single basis vector e_0 = {1} to get first column *)
applyBlock[v0_, pattern_] := Module[
  {v = v0, m = Length[v0] - 1},
  Do[
    If[w > 1, v = MatrixPower[Lmat[m], w - 1] . v];
    v = Lmat[m + 1] . Append[v, 0]; m++,
    {w, pattern}];
  v
]

(* The block applied to {1} gives the state vector *)
vBlock = applyBlock[{1}, {3, 3, 3, 3, 3, 3, 4}];
Print["Block({1}, {3,3,3,3,3,3,4}) = ", vBlock];
Print["Last entry = ", Last[vBlock], " = B(22,7) = ", B[22, 7]];
Print[""];

(* Compare with level-1 formula (for uniform w=3, this would be different) *)
Print["Level-1 formula for w=3, k=7:"];
Do[
  formula = (3 (7 - j) + 1)/(3*7 + 1) * Binomial[3*7 + j, j];
  Print["  v_", j, " formula=", formula, " actual=", vBlock[[j + 1]],
    If[formula === vBlock[[j + 1]], " MATCH", " DIFFER"]],
  {j, 0, 7}];
Print[""];

(* === The block for {3,3,3,3,3,3,4} vs pure {3,3,3,3,3,3,3} === *)
Print["=== Comparing mixed block {3^6,4} vs uniform {3^7} ==="];
vMixed = applyBlock[{1}, {3, 3, 3, 3, 3, 3, 4}];
vUniform = applyBlock[{1}, {3, 3, 3, 3, 3, 3, 3}];
Print["Mixed:   ", vMixed];
Print["Uniform: ", vUniform];
Print["Ratios:  ", MapThread[If[#2 =!= 0, #1/#2, "inf"] &, {vMixed, vUniform}]];
Print[""];

(* === What about applying the block to a NON-trivial starting vector? === *)
(* The actual state at x=25 (before the block) *)
{m25, v25} = data[25];
Print["State at x=25: m=", m25, " v=", v25];

(* Apply the {3,3,3,3,3,3,4} block starting from height m25 *)
applyBlockFromHeight[v0_, pattern_, m0_] := Module[
  {v = v0, m = m0},
  Do[
    If[w > 1, v = MatrixPower[Lmat[m], w - 1] . v];
    v = Lmat[m + 1] . Append[v, 0]; m++,
    {w, pattern}];
  v
]

(* But first: from x=25, we need to rise to height 8, then do the block *)
(* Actually, the rise at x=26 is the FIRST rise of the block *)
(* Wait: from x=25 (height 7), we have: *)
(* x=26: rise to 8 (this is the start of the block) *)
(* Then 6 more rises within the block, ending at height 14 *)
(* But the pattern is: rise at start of each stair *)

(* Let me trace carefully from v(25): *)
Print[""];
Print["=== Tracing from x=25 to x=47 ==="];
v = v25; m = m25;
Print["x=25: m=", m, " v=", v, " DP=", Last[v]];

(* The block from 26 to 47 has stair widths {3,3,3,3,3,3,4} *)
(* But this starts with a rise (at x=26, S goes from 7 to 8) *)
pattern = {3, 3, 3, 3, 3, 3, 4};
Do[
  w = pattern[[i]];
  (* Rise *)
  v = Lmat[m + 1] . Append[v, 0]; m++;
  (* Within stair *)
  If[w > 1, v = MatrixPower[Lmat[m], w - 1] . v];
  Print["After stair ", i, " (w=", w, "): m=", m, " DP=", Last[v]],
  {i, 1, Length[pattern]}];

Print[""];
Print["Final v: ", v];
{m47, v47} = data[47];
Print["Actual v(47): ", v47];
Print["Match: ", v === v47];
Print[""];

(* But we need to account for the 3 pre-steps from x=22 to x=25 *)
(* v(22) → L_7^3 → v(25) → block{3,...,4} → v(47) *)
(* So the FULL transfer from v(22) to v(47) is: block ∘ L_7^3 *)
(* And from v(47) to v(69): the SAME structure? *)
Print["=== Tracing from x=47 to x=69 ==="];
(* From x=47 (m=14), we first have within-stair to x=47+3=50, wait... *)
(* The stair at height 14 has width 4 (from x=44 to x=47). *)
(* Next rise is at x=48 (to height 15). *)
(* Then similar block from 48 to 69. *)

(* Check: from x=47 to x=69 = 22 columns *)
(* S(47)=14, S(48)=15 (rise), ..., S(69)=? *)
Print["S(47)=", Floor[47/Pi], " S(48)=", Floor[48/Pi], " S(69)=", Floor[69/Pi]];

(* So the block from x=48 to x=69 should also have pattern {3,...,4} *)
(* But wait: is there a pre-block phase like the 3-step L^3 we had before? *)
(* Between x=47 and x=48: immediate rise (no pre-steps) *)
(* Because the stair at height 14 ends at x=47 (width 4), next x=48 is rise *)
Print[""];
Print["=== Rise positions from x=47 to x=90 ==="];
prevS = Floor[47/Pi];
Do[
  curS = Floor[x/Pi];
  If[curS > prevS, Print["Rise at x=", x, " to S=", curS]];
  prevS = curS,
  {x, 48, 90}];

(* So from 47 to 69: *)
(* x=48: rise to 15. Stair width? *)
(* From the gaps: 48,51,54,57,60,63,66,70 *)
(* Widths: 3,3,3,3,3,3,4 — SAME PATTERN *)

Print[""];
Print["=== Block from 48 to 69 ==="];
v = v47; m = 14; (* m47 *)
Do[
  w = pattern[[i]];
  v = Lmat[m + 1] . Append[v, 0]; m++;
  If[w > 1, v = MatrixPower[Lmat[m], w - 1] . v],
  {i, 1, Length[pattern]}];
Print["Computed v(69): DP=", Last[v]];
{m69, v69} = data[69];
Print["Actual v(69): DP=", Last[v69]];
Print["Match: ", v === v69];
Print[""];

(* Hmm wait, from x=47 the last stair (height 14) continues to x=47 *)
(* then rises at x=48. So the block starts IMMEDIATELY at x=48 with rise. *)
(* No pre-block L^3 phase! That was special for the first block (22→25). *)

(* Let me check: is the pre-block phase (22→25) actually part of the *)
(* transition from level 1 to level 2? *)
(* At x=22: last stair of the LEVEL-1 pattern has width 4 (the anomalous one). *)
(* Stair at height 7: width 4 (x=22,23,24,25 -- wait, that's wrong) *)

(* From the stair widths: the stair at S=7 starts at x=22. *)
(* Previous stair at S=6: x=19,20,21 (width 3). Rise at x=22 to S=7. *)
(* Stair at S=7: starts at x=22. Next rise at x=26 (width 4 for this stair). *)
(* Wait: gaps between rises: rise at x=22 (to S=7), rise at x=26 (to S=8) *)
(* So stair at S=7 has width 4! That's the last stair before level-2 begins. *)
(* Width = 26-22 = 4. But this stair is at the LEVEL-1 boundary. *)

Print["=== Clarifying the level-1/level-2 transition ==="];
Print["Stair widths near x=22:"];
prevS = Floor[18/Pi];
Do[
  curS = Floor[x/Pi];
  If[curS > prevS, Print["Rise at x=", x, " to S=", curS, " (stair width ", x - prevRise, ")")];
  If[curS > prevS, prevRise = x];
  prevS = curS,
  {x, 19, 50}] /. prevRise -> 19;

(* Hmm that has a scoping issue. Let me just list rise positions *)
Print[""];
riseList = {};
prevS = Floor[1/Pi];
Do[
  curS = Floor[x/Pi];
  If[curS > prevS, AppendTo[riseList, x]];
  prevS = curS,
  {x, 2, 90}];
Print["All rise positions x=2..90: ", riseList];
widths = Differences[riseList];
Print["Stair widths: ", widths];
Print["Widths in groups of 7: "];
Do[Print["  ", Take[widths, {7 i + 1, Min[7 i + 7, Length[widths]]}]],
  {i, 0, Floor[(Length[widths] - 1)/7]}];
