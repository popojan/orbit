(* BALLOT RECURRENCE: B(p+p1, q+q1) via block transfer *)
(* M1[2q1, q1] = B' gives the multiplicative kernel *)
(* Goal: explicit recurrence and verify at level 2 *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
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

(* ====================================================== *)
(* PART 1: Explicit ballot recurrence for sqrt(5) level 1 *)
(* ====================================================== *)
Print["***************************************************"];
Print["* BALLOT RECURRENCE: level 1                      *"];
Print["***************************************************"];
Print[""];

alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
Bp = B[p0 + p1, q0 + q1]; (* 273 *)

M1 = blockTransferActual[q1 + 1, alpha, 11, 20];
lastRow = M1[[2 q1 + 1]]; (* row 2q1 = row 8 *)

Print["M1 last row: ", lastRow];
Print["M1[2q1, q1] = ", lastRow[[q1 + 1]], " = B' = B(", p0 + p1, ",", q0 + q1, ") = ", Bp];
Print[""];

(* The recurrence: B(p+p1, q+q1) = Sum_s M1[2q1, s] * v_s(p) *)
(* Since v_{q1} = v_{q1-1} = B(p,q), the last TWO terms combine: *)
(* = Sum_{s=0}^{q1-2} M1[2q1,s]*v_s + M1[2q1,q1-1]*B(p,q) + M1[2q1,q1]*B(p,q) *)
(* = Sum_{s=0}^{q1-2} M1[2q1,s]*v_s + (M1[2q1,q1-1] + M1[2q1,q1])*B(p,q) *)

combined = lastRow[[q1]] + lastRow[[q1 + 1]]; (* M[2q1, q1-1] + M[2q1, q1] *)
Print["Combined last two: M1[8,3] + M1[8,4] = ", lastRow[[q1]], " + ", lastRow[[q1 + 1]], " = ", combined];
Print[""];

(* Explicit recurrence: *)
Print["RECURRENCE:"];
Print["B(p+9, q+4) = ", lastRow[[1]], "*1 + ", lastRow[[2]], "*v1(p) + ",
  lastRow[[3]], "*v2(p) + ", combined, "*B(p,q)"];
Print["where v_j(p) = (p-2j)/p * C(p+j-1, j)"];
Print[""];

(* Verify *)
Print["Verification:"];
Do[
  p = p0 + k p1; q = q0 + k q1;
  v = Table[pathsRat[p, q, j], {j, 0, q1}];
  predicted = lastRow . v;
  actual = B[p + p1, q + q1];
  Print["  k=", k, ": B(", p + p1, ",", q + q1, ") = ", actual,
    " predicted = ", predicted, " match = ", predicted === actual],
  {k, 1, 5}];
Print[""];

(* === Separate Toeplitz and correction contributions === *)
T1lastRow = Table[Binomial[p1 - 1 + 2 q1 - s, 2 q1 - s], {s, 0, q1}];
D1lastRow = T1lastRow - lastRow;
Print["Toeplitz last row: ", T1lastRow];
Print["Correction last row: ", D1lastRow];
Print[""];

(* B(p+p1, q+q1) = T_part - D_part *)
(* T_part = Sum T1[2q1,s] * v_s(p) = v_{2q1}^lin(p+p1) = C(p+p1+2q1-1, 2q1)*(p+p1-2w*2q1)/(p+p1)... *)
(* Actually T_part is just the Toeplitz prediction *)
Print["Decomposition:"];
Do[
  p = p0 + k p1; q = q0 + k q1;
  v = Table[pathsRat[p, q, j], {j, 0, q1}];
  tPart = T1lastRow . v;
  dPart = D1lastRow . v;
  actual = B[p + p1, q + q1];
  Print["  k=", k, ": Toeplitz=", tPart, " Correction=", dPart,
    " B=Toeplitz-Correction=", tPart - dPart, " actual=", actual],
  {k, 1, 4}];
Print[""];

(* ====================================================== *)
(* PART 2: Does the SAME structure hold at level 2?       *)
(* ====================================================== *)
Print["***************************************************"];
Print["* BALLOT RECURRENCE: level 2                      *"];
Print["***************************************************"];
Print[""];

(* Level-2 block transfer maps v(47) -> v(85) *)
(* The LAST ROW of M2 should give B(next) from v(prev) *)
(* And M2[last, last] should be B(p1+p2, q1+q2) *)

M2 = blockTransferActual[q1 + q2 + 1, alpha, 47, 85];
{nr2, nc2} = Dimensions[M2];
lastRow2 = M2[[nr2]];

Print["M2 dims: ", {nr2, nc2}];
Print["M2 last row length: ", Length[lastRow2]];
Print[""];

(* M2[last, last] = M2[q1+2q2, q1+q2] should be B(p1+p2, q1+q2)? *)
(* Wait: dims are 39 x 22. Last row is row 38 (index 2q1+2q2). *)
(* Last col is col 21 (index q1+q2). *)
lastEntry2 = lastRow2[[nc2]];
Bp2 = B[p1 + p2, q1 + q2]; (* B(47, 21) *)
Print["M2[last, last] = ", lastEntry2];
Print["B(p1+p2, q1+q2) = B(47, 21) = ", Bp2];
Print["Match: ", lastEntry2 === Bp2];
Print[""];

(* Verify recurrence: M2_last . v(47) = B(85, 38) *)
v47 = Table[pathsRat[47, 21, j], {j, 0, 21}];
predicted2 = lastRow2 . v47;
actual2 = B[85, 38];
Print["M2_last . v(47) = ", predicted2];
Print["B(85, 38) = ", actual2];
Print["Match: ", predicted2 === actual2];
Print[""];

(* === Does the bottom-right entry pattern generalize? === *)
Print["***************************************************"];
Print["* BOTTOM-RIGHT = BALLOT at ALL levels?            *"];
Print["***************************************************"];
Print[""];

(* At level 1: M1[2q1, q1] = B(p0+p1, q0+q1) *)
(* At level 2: M2[last, last] = B(p1+p2, q1+q2)? *)
(* This would mean: the bottom-right of the transfer is always *)
(* the ballot number of the FIRST semi-convergent at that level *)

(* For level 2: first semi-convergent between p1 and p2 is *)
(* (p1+p2)/(q1+q2) = 47/21 *)
(* So B(47, 21) should be M2[last, last] *)

Print["Level 1: M1[2q1, q1] = ", M1[[2 q1 + 1, q1 + 1]],
  " = B(p0+p1, q0+q1) = B(", p0 + p1, ",", q0 + q1, ") = ", B[p0 + p1, q0 + q1],
  " MATCH: ", M1[[2 q1 + 1, q1 + 1]] === B[p0 + p1, q0 + q1]];

Print["Level 2: M2[last, last] = ", lastEntry2,
  " = B(p1+p2, q1+q2) = B(", p1 + p2, ",", q1 + q2, ") = ", Bp2,
  " MATCH: ", lastEntry2 === Bp2];
Print[""];

(* === Verify on Pi === *)
Print["Pi level 1:"];
alphaPi = Pi; wPi = 3;
p0Pi = 3; q0Pi = 1; p1Pi = 22; q1Pi = 7;
M1Pi = blockTransferActual[q1Pi + 1, alphaPi, 25, 47];
Print["M1[2q1, q1] = ", M1Pi[[2 q1Pi + 1, q1Pi + 1]],
  " = B(", p0Pi + p1Pi, ",", q0Pi + q1Pi, ") = ", B[p0Pi + p1Pi, q0Pi + q1Pi],
  " MATCH: ", M1Pi[[2 q1Pi + 1, q1Pi + 1]] === B[p0Pi + p1Pi, q0Pi + q1Pi]];
Print[""];

(* Pi level 2 *)
p2Pi = 333; q2Pi = 106;
Print["Pi level 2 (computing M2 for Pi, dim ", q1Pi + q2Pi + 1, "x", q1Pi + q2Pi + 1, "):"];
M2Pi = blockTransferActual[q1Pi + q2Pi + 1, alphaPi, 355, 688];
{nr2Pi, nc2Pi} = Dimensions[M2Pi];
lastEntry2Pi = M2Pi[[nr2Pi, nc2Pi]];
Bp2Pi = B[p1Pi + p2Pi, q1Pi + q2Pi];
Print["M2[last, last] = ", lastEntry2Pi];
Print["B(p1+p2, q1+q2) = B(", p1Pi + p2Pi, ",", q1Pi + q2Pi, ") = ", Bp2Pi];
Print["Match: ", lastEntry2Pi === Bp2Pi];
Print[""];

(* ====================================================== *)
(* PART 3: The FULL ballot recurrence structure           *)
(* ====================================================== *)
Print["***************************************************"];
Print["* BALLOT RECURRENCE STRUCTURE                     *"];
Print["***************************************************"];
Print[""];

(* At level k, the recurrence is: *)
(* B(p+p_k, q+q_k) = Sum_s M_k[last, s] * v_s(p) *)
(* *)
(* The last entry M_k[last, last] = B'_k = B(p_{k-1}+p_k, q_{k-1}+q_k) *)
(* And v_{last}(p) = B(p, q) *)
(* So the last term is B'_k * B(p, q) *)
(* *)
(* This gives: *)
(* B(p+p_k, q+q_k) = [lower terms] + B'_k * B(p, q) *)

Print["UNIVERSAL BALLOT RECURRENCE:"];
Print["B(p + p_k, q + q_k) = Sum_{s=0}^{q-1} M_k[last, s]*v_s(p) + B'_k * B(p, q)"];
Print["where B'_k = B(p_{k-1}+p_k, q_{k-1}+q_k)"];
Print[""];

(* === What are the "lower terms"? === *)
(* For s <= q1: v_s(p) = (p-ws)/p * C(p+s-1, s) = uniform formula *)
(* So the lower terms involve uniform state vector * M_k entries *)
(* These M_k entries are Toeplitz - correction *)

(* === Key: the penultimate entry === *)
(* v_{q-1} = v_q = B(p,q), so M_k[last, q-1] also multiplies B(p,q) *)
(* Combined: (M_k[last, q-1] + M_k[last, q]) * B(p,q) *)
penult1 = M1[[2 q1 + 1, q1]]; (* M1[8, 3] *)
Print["Level 1: M1[last, q1-1] + M1[last, q1] = ", penult1, " + ", Bp, " = ", penult1 + Bp];
Print["  = ", penult1 + Bp, " = ", Factored /. Factored -> Factor[penult1 + Bp]];
Print[""];

(* 882 + 273 = 1155 = 3*5*7*11 = B(11,5) * ? *)
Print["  1155 / B' = ", (penult1 + Bp) / Bp];
Print["  1155 = 3*5*7*11 = ", FactorInteger[1155]];
Print[""];

(* === For sqrt(5), the recurrence with v_{q1-1}=v_{q1} combined: === *)
(* B(p+9, q+4) = 11139 + 5319*v1 + 2313*v2 + 1155*B(p,q) *)
(* = 11139 + 5319*(p-2)/p*C(p,1) + 2313*(p-4)/p*C(p+1,2) + 1155*B(p,q) *)
Print["Simplified recurrence (combining last two):"];
Print["B(p+9, q+4) = 11139 + 5319*v1(p) + 2313*v2(p) + 1155*B(p,q)"];
Print[""];

(* Verify *)
Do[
  p = p0 + k p1; q = q0 + k q1;
  v1 = vLin[p, ww, 1]; v2 = vLin[p, ww, 2];
  bpq = B[p, q];
  predicted = 11139 + 5319 v1 + 2313 v2 + 1155 bpq;
  actual = B[p + p1, q + q1];
  Print["  k=", k, ": predicted=", predicted, " actual=", actual, " match=", predicted === actual],
  {k, 1, 6}];
Print[""];

(* === Can the COEFFICIENTS be expressed via ballot/binomial? === *)
Print["Coefficients: {11139, 5319, 2313, 1155}"];
Print["  11139 = ", FactorInteger[11139]];
Print["  5319 = ", FactorInteger[5319]];
Print["  2313 = ", FactorInteger[2313]];
Print["  1155 = ", FactorInteger[1155]];
Print[""];

(* These are M1[8, 0..2] and (M1[8,3]+M1[8,4]) *)
(* M1[8,s] = T[8,s] - Delta[8,s] *)
(* T[8,s] = C(16-s, 8-s) = {12870, 6435, 3003, 1287, 495} *)
(* Delta[8,s] = {1731, 1116, 690, 405, 222} *)

(* Try: 11139 / B' = 11139/273 = 40.8... not integer *)
(* Try: 11139 / p1 = 11139/9 = 1237.67... not integer *)
(* 11139 = 3 * 7 * 531 = 3*7*3*177 = 9*1237.67... hmm, 3*3713 = 11139 *)
(* 11139 = 3 * 3713 = 3 * 3713. And 3713 is prime? 3713/7 = 530.4 no *)
(* 3713 = 7*530+3 = no. 3713/11 = 337.5 no. 3713/13 = 285.6 no. 3713/17 = 218.4 no. *)
(* 3713/19 = 195.4 no. 3713/23 = 161.4 no. 3713/29 = 128.0 yes! 29*128 = 3712 no. *)
(* 3713/31 = 119.8 no. 3713/37 = 100.4 no. 3713/41 = 90.6 no. sqrt(3713) ~ 60.9 *)
(* 3713/43 = 86.3 no. 3713/47 = 79.0 yes! 47*79 = 3713. Yes! *)
(* So 11139 = 3 * 47 * 79 *)

Print["11139 = 3 * 47 * 79"];
Print["  47 = p1+p2 = ", p1 + p2, "? No, p1+p2=47. YES!"];
Print["  79 = ? 79 is prime"];
Print["  3 = w+1"];
Print["  So 11139 = (w+1) * (p1+p2) * 79 ?"];
Print["  But 79 = ?"];
Print[""];

(* Actually let me just compute: *)
Print["11139 = 3 * 47 * 79"];
Print["p1+p2 = ", p1 + p2]; (* 47 *)
Print["So 11139/(w+1)/(p1+p2) = ", 11139/3/47]; (* 79 *)
Print["79 = p2+p1+... ? p2=38, p1=9, p0=2. 38+9+2 = 49. No."];
Print["79 = 2*p2+3 = 2*38+3 = 79. Hmm."];
Print["Or: C(12,3)/3 = 220/3... no"];
Print[""];

(* === Actually, the more natural decomposition is: === *)
(* M1[last, s] = C(p1+q1-1-s, 2q1-s) - Delta[last, s] *)
(* where Delta comes from Result 7. *)
(* The FULL last row is T - Delta. *)
(* Can we express the ballot recurrence as: *)
(* B(next) = [Toeplitz transform of v] - [correction transform of v] *)

Print["=== Toeplitz ballot recurrence ==="];
Print["B(next) = T_last . v(p) - Delta_last . v(p)"];
Print[""];
Print["T_last . v(p) = Sum_s C(", p1 + q1 - 1, "-s, ", 2 q1, "-s) * v_s(p)"];
Print["= v_{2q1}^{lin}(p+p1) by Vandermonde convolution"];
Print["= (p+p1-2w*2q1)/(p+p1) * C(p+p1+2q1-1, 2q1)"];
Print[""];

Do[
  p = p0 + k p1; q = q0 + k q1;
  toeVal = vLin[p + p1, ww, 2 q1];
  bVal = B[p + p1, q + q1];
  corrVal = toeVal - bVal;
  Print["k=", k, ": T_transform=", toeVal, " B(next)=", bVal, " correction=", corrVal,
    " corr/B'=", corrVal/Bp],
  {k, 1, 5}];
Print[""];

(* === THE CORRECTION IS (k-1)*B' TIMES SOMETHING? === *)
(* Wait: correction = T_transform - B(next) = v_last^lin - B *)
(* From the last-row identity: v_last^lin = k * B (at k-th semi-convergent) *)
(* Wait no: at position p+p1 = p0+(k+1)p1, v_{2q1}^lin(p+p1) = ... *)
(* Actually 2q1 is NOT the last entry at position p+p1. The last entry *)
(* is at height q+q1 = q0+(k+1)q1. And 2q1 = 2*(q0+kq1)... no. *)

(* Hmm, let me reconsider. The block transfer maps v at height q to *)
(* v at height q+q1. Row 2q1 of M1 maps to OUTPUT height 2q1 (0-indexed). *)
(* The output has indices 0,...,2q1. And 2q1 = 8. *)
(* At position p+p1 = p0+(k+1)p1, the max height is q+q1 = q0+(k+1)q1. *)
(* For k=1: output height range 0..8, max height = 1+2*4 = 9. *)
(* So 2q1 = 8 is NOT the last height! The last height is q+q1 = 9. *)

(* Wait, I'm confused. Let me reclarify dimensions. *)
(* M1 is 9x5: maps dim 5 -> dim 9. *)
(* Input: heights 0..4 (q1 entries). Output: heights 0..8 (2q1+1 entries). *)
(* At k=1: v(11) has heights 0..4 (5 entries). *)
(* After M1: v(20) has heights 0..8 (9 entries). *)
(* But v(20) should have heights 0..9 (10 entries, since q=9 at k=2). *)
(* OH WAIT: 9 entries, not 10. Because q at position 20 is 9, *)
(* and v has entries 0..q = 0..9 which is 10 entries. *)

(* There's a discrepancy: M1 produces 9 entries (0..8) but v(20) has 10 (0..9). *)
(* The MISSING entry v_9 is obtained separately: v_9 = v_8 (last-two-equal). *)
(* So the block transfer only gives heights 0..2q1, and the LAST *)
(* height (= q_next) is obtained by copying: v_{q_next} = v_{q_next-1}. *)

Print["=== DIMENSION CLARIFICATION ==="];
Print["M1 maps dim ", q1 + 1, " -> dim ", 2 q1 + 1, " (heights 0..", 2 q1, ")"];
Print["But v(20) has ", q0 + 2 q1 + 1, " entries (heights 0..", q0 + 2 q1, ")"];
Print["Missing height ", q0 + 2 q1, " = v_{q_next} = v_{q_next-1} (last-two-equal)"];
Print[""];

(* So: v_{2q1}(p+p1) = M1[2q1, :] . v(p) = the PENULTIMATE entry *)
(* And v_{2q1+1}(p+p1) = v_{2q1}(p+p1) (copy) = the LAST entry = B(next) *)
(* WAIT: 2q1 = 8 and q_next = q0+(k+1)q1 = 1+2*4 = 9. So v_8 = v_9. *)
(* And v_9 = B(20, 9). So v_8(20) = B(20, 9) too! *)

Print["v_8(20) = ", pathsRat[20, 9, 8], " = v_9(20) = ", pathsRat[20, 9, 9],
  " = B(20,9) = ", B[20, 9]];
Print[""];

(* So M1[2q1, :] . v(p) gives the PENULTIMATE = LAST entry = B(next)! *)
(* The ballot recurrence is EXACT: *)
Print["EXACT BALLOT RECURRENCE (CONFIRMED):"];
Print["B(p+p1, q+q1) = M1[2q1, :] . v(p)"];
Print["= Sum_{s=0}^{q1-2} M1[2q1,s]*v_s(p) + (M1[2q1,q1-1]+M1[2q1,q1])*B(p,q)"];
Print[""];
Print["For sqrt(5): B(p+9, q+4) = 11139 + 5319*v1(p) + 2313*v2(p) + 1155*B(p,q)"];
Print["where v_j(p) = (p-2j)/p * C(p+j-1,j)"];
Print[""];

(* === LEVEL 2: does M2[last,:].v(47) = B(85,38)? === *)
Print["Level 2 ballot recurrence:"];
predicted2check = lastRow2 . v47;
Print["M2[last,:] . v(47) = ", predicted2check, " = B(85,38) = ", B[85, 38],
  " match = ", predicted2check === B[85, 38]];
Print[""];

(* Bottom-right entry *)
Print["M2[last, last] = ", lastEntry2, " = B(47,21) = ", Bp2, " match = ", lastEntry2 === Bp2];
Print[""];

(* Combined last two *)
penult2 = lastRow2[[nc2 - 1]];
Print["M2[last, q-2] = ", lastRow2[[nc2 - 1]]];
Print["M2[last, q-1] = ", lastRow2[[nc2]]];
Print["Combined: ", penult2 + lastEntry2];
Print[""];

(* === THE UNIVERSAL PATTERN === *)
Print["***************************************************"];
Print["* UNIVERSAL BALLOT RECURRENCE THEOREM             *"];
Print["***************************************************"];
Print[""];
Print["At CF level k, the block transfer M_k satisfies:"];
Print[""];
Print["  M_k[last, last] = B(p_{k-1}+p_k, q_{k-1}+q_k)"];
Print[""];
Print["and the ballot recurrence is:"];
Print[""];
Print["  B(p+p_k, q+q_k) = Sum_{s} M_k[last,s] * v_s(p)"];
Print["                   = [lower state terms] + B'_k * B(p, q)"];
Print[""];
Print["Verified:"];
Print["  sqrt(5) level 1: B' = B(11,5) = 273"];
Print["  sqrt(5) level 2: B' = B(47,21) = ", Bp2];
Print["  Pi level 1:      B' = B(25,8) = ", B[25, 8]];
