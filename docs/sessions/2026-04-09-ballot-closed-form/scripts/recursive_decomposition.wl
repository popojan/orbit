(* Test recursive decomposition of v_j under rational staircases *)
(* Key idea: for CF [a0; a1, a2], does *)
(*   v_j([a0;a1,a2]) = vLinear(p,a0,j) - v_{j-a1-1}([a0;a1+1]) * factor? *)
(* Or more generally: some telescoping over CF levels? *)

pathsRational[p_, q_, j_] := Module[{S, dp},
  If[j == 0, Return[1]];
  If[j < 0, Return[0]];
  S = Table[Min[Floor[q x/p], j], {x, 1, p}];
  If[j > S[[p]], Return[0]];
  dp = Table[0, {p}, {j + 1}];
  Do[Do[
    If[y <= S[[x]],
      dp[[x, y + 1]] =
        If[x == 1 && y == 0, 1, 0] +
        If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
        If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[j, S[[x]]]}], {x, 1, p}];
  dp[[p, j + 1]]
]

vLinear[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]
Ballot[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

(* === Full state vector for rational staircase === *)
fullStateRational[p_, q_] := Table[pathsRational[p, q, j], {j, 0, q}]

(* === Decomposition test for GoldenRatio-type CFs === *)
(* GR convergents: 1/1, 2/1, 3/2, 5/3, 8/5, 13/8, 21/13 *)
(* These have CF [1;1,1,...] *)
Print["=== GoldenRatio: recursive decomposition ==="];
Print[""];

(* For p/q = [1; 1, n]: *)
(* n=1: 3/2, n=2: 5/3, n=3: 8/5, n=4: 13/8, n=5: 21/13 *)
Do[
  p = Numerator[FromContinuedFraction[{1, 1, n}]];
  q = Denominator[FromContinuedFraction[{1, 1, n}]];
  Print["--- [1; 1, ", n, "] = ", p, "/", q, " ---"];

  vFull = fullStateRational[p, q];
  Print["  Full state: ", vFull];

  (* Linear formula *)
  vLin = Table[vLinear[p, 1, j], {j, 0, q}];
  Print["  Linear:     ", vLin];

  (* Correction *)
  corr = vFull - vLin;
  Print["  Correction: ", corr];

  (* The "inner" convergent [1; 2] = 3/2 *)
  (* Hypothesis: correction is related to paths under 3/2 staircase *)
  pInner = 3; qInner = 2;
  vInner = fullStateRational[pInner, qInner];
  Print["  v([1;2]) = ", vInner, " = state for 3/2"];
  Print["  B(3,2) = ", Ballot[3, 2]];
  Print[""],
  {n, 1, 6}];

(* === Explicit test of decomposition for 5/3 = [1; 1, 2] === *)
Print["=== Detailed: 5/3 = [1; 1, 2] ==="];
p = 5; q = 3;
vFull = fullStateRational[5, 3];
Print["v_j(5,3): ", vFull]; (* {1, 4, 9, 9} for j=0,1,2,3 *)

(* vLinear: (5-j)/5 * C(4+j, j) *)
vLin = Table[vLinear[5, 1, j], {j, 0, 3}];
Print["vLin:     ", vLin];
Print["diff:     ", vFull - vLin]; (* {0, 0, -2, ...} *)

(* At j=2: diff = -2 = -B(3,2). *)
(* At j=3: diff = ? *)
(* vFull[3] = 9 (last entry = B(5,3)). vLin[3] = (5-3)/5 * C(7,3) = 2/5 * 35 = 14. *)
(* diff[3] = 9 - 14 = -5. *)
Print[""];

(* Is -5 = -B(3,2) * something? B(3,2) = 2. -5/2 not integer. *)
(* Is -5 = -B(3,3)? B(3,3) = C(5,3)/3 = 10/3 not integer. *)
(* Is -5 = ? *)
(* B(5,3) = 9, vLin(5,1,3) = 14, diff = -5 *)
(* Note: B(3,2) = 2. And -5 = -2*3 + 1? *)

(* Let me try: v_j(5,3) = vLinear(5,1,j) - vLinear(3,1,j-2) for j>=2 *)
Print["Hypothesis: v_j(5,3) = vLin(5,j) - vLin(3,j-2)"];
Do[
  lhs = pathsRational[5, 3, j];
  rhs = vLinear[5, 1, j] - If[j >= 2, vLinear[3, 1, j - 2], 0];
  Print["  j=", j, ": actual=", lhs, " formula=", rhs,
    If[lhs === rhs, " MATCH", " DIFFER"]],
  {j, 0, 3}];
Print[""];

(* === Test same hypothesis for 8/5 = [1; 1, 3] === *)
Print["=== 8/5 = [1; 1, 3] ==="];
Print["Hypothesis: v_j(8,5) = vLin(8,j) - vLin(3,j-2)"];
Do[
  lhs = pathsRational[8, 5, j];
  rhs = vLinear[8, 1, j] - If[j >= 2, vLinear[3, 1, j - 2], 0];
  Print["  j=", j, ": actual=", lhs, " formula=", rhs,
    If[lhs === rhs, " MATCH", " DIFFER"]],
  {j, 0, 5}];
Print[""];

(* === 13/8 = [1; 1, 1, 1, 1] or [1; 1, 4] === *)
Print["=== 13/8 = [1; 1, 4] as direct 2-level ==="];
Print["Hypothesis: v_j(13,8) = vLin(13,j) - vLin(3,j-2)"];
Do[
  lhs = pathsRational[13, 8, j];
  rhs = vLinear[13, 1, j] - If[j >= 2, vLinear[3, 1, j - 2], 0];
  Print["  j=", j, ": actual=", lhs, " formula=", rhs,
    If[lhs === rhs, " MATCH", " DIFFER"]],
  {j, 0, 8}];
Print[""];

(* Hmm, let me also try 3-level: *)
(* 13/8 = [1; 1, 1, 1, 1] has convergents 1/1, 2/1, 3/2, 5/3, 8/5, 13/8 *)
(* Level 0: linear for j=0,1 *)
(* Level 1: correction from [1;2]=3/2 for j=2,3 *)
(* Level 2: correction from [1;1,2]=5/3 for j=4,5,... *)
Print["=== 13/8: multi-level hypothesis ==="];
Print["v_j(13,8) = vLin(13,j) - vLin(3,j-2) + vLin(5,j-4)?"];
Do[
  lhs = pathsRational[13, 8, j];
  rhs = vLinear[13, 1, j];
  If[j >= 2, rhs -= vLinear[3, 1, j - 2]];
  If[j >= 4, rhs += vLinear[5, 1, j - 4]]; (* alternating sign? *)
  Print["  j=", j, ": actual=", lhs, " formula=", rhs,
    If[lhs === rhs, " MATCH", " DIFFER"]],
  {j, 0, 8}];
Print[""];

(* Try alternating signs with convergent numerators *)
(* Convergents of GR: p_k = 1, 2, 3, 5, 8, 13, ... *)
(* v_j(13,8) = Σ_k (-1)^k * vLinear(p_k, 1, j - (q_0+q_1+...+q_k)) ??? *)
Print["=== 13/8: inclusion-exclusion over convergents ==="];
convP = {1, 2, 3, 5, 8, 13};
convQ = {1, 1, 2, 3, 5, 8};
cumQ = Accumulate[convQ]; (* partial sums of q's *)
(* j-shifts: at each convergent k, the shift is sum of previous q's *)
(* shift_k = q_0 + q_1 + ... + q_{k-1} *)
shifts = Prepend[Most[cumQ], 0];
Print["Convergents: ", Thread[{convP, convQ}]];
Print["Cumulative q: ", cumQ];
Print["Shifts: ", shifts];
Print[""];

Print["v_j(13,8) = Σ (-1)^k * vLinear(p_k, 1, j - shift_k)"];
Do[
  lhs = pathsRational[13, 8, j];
  rhs = 0;
  Do[
    shift = shifts[[k + 1]];
    If[j >= shift && j - shift >= 0 && convP[[k + 1]] - 1*(j - shift) > 0,
      rhs += (-1)^k * vLinear[convP[[k + 1]], 1, j - shift]],
    {k, 0, 5}];
  Print["  j=", j, ": actual=", lhs, " formula=", rhs,
    If[lhs === rhs, " MATCH", " DIFFER"]],
  {j, 0, 8}];
Print[""];

(* === Try for Pi: [3; 7, ...] convergents 3/1, 22/7, 25/8 === *)
Print["=== 47/15 = [3; 7, 2]: inclusion-exclusion over convergents ==="];
(* Convergents of 47/15: 3/1, 22/7, 47/15 *)
(* Also 25/8 = first semi-convergent *)
(* Use convergent denominators as shifts *)
convPPi = {3, 22, 25, 47};
convQPi = {1, 7, 8, 15};
shiftsPi = {0, 1, 8, 15}; (* cumulative: 0, q0, q0+q1, q0+q1+q2... *)
(* Actually shifts should be: 0, q0+1, q0+q1+2, ... *)
(* Let me try: shift for level k is just the q of the k-th convergent *)

(* Simplest hypothesis: alternating sum of vLinear at convergent p's *)
Print["v_j(47,15) = vLin(47,j) - vLin(25,j-8) + vLin(3, j-16)?"];
Do[
  lhs = pathsRational[47, 15, j];
  rhs = vLinear[47, 3, j];
  If[j >= 8, rhs -= vLinear[25, 3, j - 8]];
  (* If[j >= 16, rhs += vLinear[3, 3, j - 16]]; *)  (* 3 is too small for j-16 *)
  Print["  j=", j, ": actual=", lhs, " rhs=", rhs,
    If[lhs === rhs, " MATCH",
      "  diff=" <> ToString[lhs - rhs]]],
  {j, 0, 14}];
Print[""];

(* Try different shift for the second term *)
Print["v_j(47,15) = vLin(47,j) - vLin(25, j - q1 - 1)?  (shift = 8)"];
Do[
  lhs = pathsRational[47, 15, j];
  rhs = vLinear[47, 3, j];
  If[j >= 8, rhs -= vLinear[25, 3, j - 8]];
  Print["  j=", j, ": actual=", lhs, " rhs=", rhs,
    If[lhs === rhs, " MATCH", "  diff=" <> ToString[lhs - rhs]]],
  {j, 0, 14}];
Print[""];

(* The diffs above should reveal the SECOND correction term *)
Print["=== Second-level corrections for 47/15 ==="];
Do[
  lhs = pathsRational[47, 15, j];
  rhs = vLinear[47, 3, j] - If[j >= 8, vLinear[25, 3, j - 8], 0];
  diff2 = lhs - rhs;
  If[diff2 =!= 0,
    Print["  j=", j, ": diff2 = ", diff2]],
  {j, 0, 14}];
Print[""];

(* === What about the formula for 69/22 = [3; 7, 3]? === *)
Print["=== 69/22: same structure ==="];
Print["v_j(69,22) = vLin(69,j) - vLin(25, j-8) - ???"];
Do[
  lhs = pathsRational[69, 22, j];
  rhs = vLinear[69, 3, j] - If[j >= 8, vLinear[25, 3, j - 8], 0];
  diff2 = lhs - rhs;
  If[diff2 =!= 0,
    Print["  j=", j, ": diff2 = ", diff2]],
  {j, 0, Min[21, 16]}];
Print[""];

(* Compare second-level corrections for 47/15 and 69/22 *)
Print["=== Second-level corrections: 47/15 vs 69/22 ==="];
Do[
  lhs47 = pathsRational[47, 15, j];
  rhs47 = vLinear[47, 3, j] - If[j >= 8, vLinear[25, 3, j - 8], 0];
  d47 = lhs47 - rhs47;

  lhs69 = pathsRational[69, 22, j];
  rhs69 = vLinear[69, 3, j] - If[j >= 8, vLinear[25, 3, j - 8], 0];
  d69 = lhs69 - rhs69;

  If[d47 =!= 0 || d69 =!= 0,
    Print["  j=", j, ": d(47)=", d47, " d(69)=", d69,
      If[d47 === d69, " SAME!", ""]]],
  {j, 8, 14}];
