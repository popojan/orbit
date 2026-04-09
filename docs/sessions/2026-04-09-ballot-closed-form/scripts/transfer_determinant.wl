(* TRANSFER MATRIX STRUCTURE: what property of M_k encodes det = +-1? *)
(* The CF matrix [[p_k, p_{k-1}], [q_k, q_{k-1}]] has det = (-1)^{k+1} *)
(* M_k is a rectangular matrix (more rows than columns). *)
(* Key question: what SQUARE sub-structure of M_k carries the +-1? *)

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

alpha = Sqrt[5];
ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* === Level-1 block transfer M1 (9x5 matrix) === *)
Print["===== LEVEL-1 BLOCK TRANSFER STRUCTURE ====="];
M1 = blockTransferActual[q1 + 1, alpha, 11, 20];
Print["M1 dims: ", Dimensions[M1]];
Print["M1 ="];
Do[Print["  ", M1[[j + 1]]], {j, 0, 2 q1}];
Print[""];

(* M1 maps R^5 -> R^9. The first 5 rows form a 5x5 square submatrix. *)
M1top = M1[[1 ;; q1 + 1]]; (* rows 0..q1, cols 0..q1 *)
Print["Top square (5x5): det = ", Det[M1top]];
Print[""];

(* The LAST q1+1 rows (5x5): rows q1..2q1 *)
M1bot = M1[[q1 + 1 ;; 2 q1 + 1]];
Print["Bottom square (5x5): det = ", Det[M1bot]];
Print[""];

(* Various square submatrices *)
Print["Determinants of various 5x5 submatrices:"];
Do[
  sub = M1[[rows + 1 ;; rows + q1 + 1]];
  Print["  rows ", rows, "..", rows + q1, ": det = ", Det[sub]],
  {rows, 0, q1}];
Print[""];

(* === Look at the Toeplitz part T1 and correction Delta1 === *)
T1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 2 q1}, {s, 0, q1}];
D1 = T1 - M1;

T1top = T1[[1 ;; q1 + 1]];
Print["Toeplitz top 5x5 det = ", Det[T1top]];
Print[""];

(* === The RATIO: last two entries of state vector === *)
(* At convergent/semi-convergent: v_{q-1} = v_q (last two equal after rise) *)
(* Actually, that's only true right after a rise. At general positions, *)
(* v_{q-1} and v_q differ. *)

Print["===== STATE VECTOR RATIOS ====="];
Do[
  p = p0 + k p1; q = q0 + k q1;
  v = Table[pathsRat[p, q, j], {j, 0, q}];
  Print["k=", k, " p=", p, ": v_{q-1}/v_q = ",
    v[[q]] / v[[q + 1]], " = ", N[v[[q]] / v[[q + 1]], 6],
    "  v_q = B(", p, ",", q, ") = ", v[[q + 1]]],
  {k, 1, 5}] /. pathsRat -> (Module[{S, dp},
    S = Table[Min[Floor[#2 x/#1], #3], {x, 1, #1}];
    If[#3 > S[[#1]], 0,
      dp = Table[0, {#1}, {#3 + 1}];
      Do[Do[If[y <= S[[x]],
        dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
          If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
          If[y > 0, dp[[x, y]], 0]],
        {y, 0, Min[#3, S[[x]]]}], {x, 1, #1}];
      dp[[#1, #3 + 1]]]] &);

(* That substitution is ugly. Let me just compute directly. *)
Print[""];

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

Print["===== STATE VECTOR STRUCTURE ====="];
Do[
  p = p0 + k p1; q = q0 + k q1;
  vq = pathsRat[p, q, q];
  vqm1 = pathsRat[p, q, q - 1];
  Print["k=", k, " p/q=", p, "/", q, ": v_q=", vq,
    " v_{q-1}=", vqm1, " equal?=", vq === vqm1,
    " ratio=", If[vq =!= 0, N[vqm1/vq, 6], "undef"]],
  {k, 1, 4}];
Print[""];

(* === KEY: the 2x2 "projection" of the block transfer === *)
(* Consider only the LAST TWO entries of the state vector *)
(* v_{q-1}(next) and v_q(next) as functions of v(prev) *)
(* This gives a 2 x (q+1) matrix. But restricted to the *)
(* last two entries of v(prev), it's a 2x2 matrix. *)
Print["===== 2x2 PROJECTION OF BLOCK TRANSFER ====="];
Print["Last 2 rows of M1 (the rows that produce v_{q-1} and v_q):"];
Print["  row q1:   ", M1[[q1 + 1]]];  (* produces v_{q1}(next) *)
Print["  row 2q1:  ", M1[[2 q1 + 1]]]; (* produces v_{2q1}(next) *)
Print[""];

(* The last two entries of v(prev) are v_{q1-1} and v_{q1}. *)
(* These are the (q1)th and (q1+1)th columns. *)
(* The 2x2 submatrix M1[{q1, 2q1}, {q1-1, q1}]: *)
sub22 = {{M1[[q1 + 1, q1]], M1[[q1 + 1, q1 + 1]]},
         {M1[[2 q1 + 1, q1]], M1[[2 q1 + 1, q1 + 1]]}};
Print["2x2 submatrix M1[{q1,2q1}, {q1-1,q1}]:"];
Print["  ", sub22];
Print["  det = ", Det[sub22]];
Print[""];

(* === More systematic: all 2x2 minors from last two rows === *)
Print["All 2x2 minors from rows q1 and 2q1 of M1:"];
Do[
  minor = {{M1[[q1 + 1, c1 + 1]], M1[[q1 + 1, c2 + 1]]},
           {M1[[2 q1 + 1, c1 + 1]], M1[[2 q1 + 1, c2 + 1]]}};
  d = Det[minor];
  If[d =!= 0, Print["  cols {", c1, ",", c2, "}: det = ", d]],
  {c1, 0, q1 - 1}, {c2, c1 + 1, q1}];
Print[""];

(* === What about CONSECUTIVE state vectors? === *)
(* The CF determinant: p_k*q_{k-1} - p_{k-1}*q_k = (-1)^{k+1} *)
(* In terms of ballot: B(p,q)*p * q' - B(p',q')*p' * q = ??? *)
Print["===== CF DETERMINANT vs BALLOT ====="];
Print["p1*q0 - p0*q1 = ", p1 q0 - p0 q1, " (should be (-1)^1 = -1 for k=1... ")];
Print["Actually: p1*q0 - p0*q1 = 9*1 - 2*4 = 1. And (-1)^{0+1} = -1... ");
Print["Convention: p_k q_{k-1} - p_{k-1} q_k = (-1)^{k+1}"];
Print["k=1: p1*q0 - p0*q1 = ", p1 q0 - p0 q1];
Print["k=2: p2*q1 - p1*q2 = ", p2 q1 - p1 q2];
Print[""];

(* === The ballot number relation === *)
(* B(p,q) = C(p+q-1,q)/p *)
(* At consecutive convergents: *)
(* B(p1, q1) * B(p2, q2) vs B(p1+p2, q1+q2) ? *)
B[n_, k_] := Binomial[n + k - 1, k]/n;

Print["Ballot numbers at convergents:"];
Print["  B(p1,q1) = B(9,4) = ", B[9, 4]];
Print["  B(p2,q2) = B(38,17) = ", B[38, 17]];
Print["  B(p0,q0) = B(2,1) = ", B[2, 1]];
Print["  B(p0+p1, q0+q1) = B(11,5) = ", B[11, 5]];
Print[""];

(* === Cross-ratios of ballot numbers === *)
Print["Cross-ratios:"];
Print["  B(p2,q2) / B(p1,q1) = ", B[38, 17] / B[9, 4]];
Print["  B(p0+p1,q0+q1) / B(p1,q1) = ", B[11, 5] / B[9, 4]];
Print["  B(p2,q2) / B(p0+p1,q0+q1) = ", B[38, 17] / B[11, 5]];
Print[""];

(* === The +-1 as a LATTICE PATH property === *)
(* p1*q0 - p0*q1 = 1. What does this mean for lattice paths? *)
(* p1 = 9, q0 = 1, p0 = 2, q1 = 4 *)
(* The point (p1, q1) = (9, 4) and (p0, q0) = (2, 1) *)
(* are on the same line through origin (slope 1/alpha ~ q/p) *)
(* The determinant measures the AREA of the parallelogram *)
(* spanned by (p0, q0) and (p1, q1). Area = 1 means *)
(* they form a BASIS of the integer lattice Z^2. *)
(* This is the UNIMODULARITY condition. *)

Print["Unimodularity: (p0,q0)=(2,1) and (p1,q1)=(9,4) span Z^2"];
Print["  det = p1*q0 - p0*q1 = ", p1 q0 - p0 q1];
Print["  This means: every (a,b) in Z^2 is a*p0+b*p1, a*q0+b*q1"];
Print["  for unique integers a, b."];
Print[""];

(* === The block transfer in the unimodular basis === *)
(* Express M1 in the basis where columns correspond to *)
(* (p0, q0) and (p1, q1) directions *)
(* The state vector v at p0+k*p1 has entries that depend on k linearly *)
(* (for j <= q1) or polynomially (for j > q1) *)

(* Instead of the standard basis, use the "convergent basis": *)
(* v_j(p0+k*p1) = uniform(k) + correction(k) *)
(* The block transfer in k-space: v(k+1) = M_k * v(k) *)

Print["===== BLOCK TRANSFER IN k-SPACE ====="];
(* State vectors at k=1,...,5 *)
states = Table[
  Module[{p = p0 + k p1, q = q0 + k q1},
    Table[pathsRat[p, q, j], {j, 0, q}]],
  {k, 1, 5}];

(* Check: is v(k+1) = M1 . v(k) for the formula M1? *)
(* We know M1 maps v at one semi-convergent to the next *)
(* But the dimensions change: v(k) has q0+k*q1+1 entries *)
(* So M1 has growing dimensions *)

(* The FIXED part: entries j=0..q1 *)
(* These satisfy v_j(p0+(k+1)p1) = Sum_s M[j,s] v_s(p0+k*p1) *)
(* where M[j,s] = C(p1-1+j-s, j-s) for j <= q1+1 (Toeplitz, no correction) *)

(* For j=q1 (= 4), the formula gives: *)
(* v_4(next) = Sum_{s=0}^{4} C(8+4-s, 4-s) * v_s(prev) *)
(* = C(12,8)*v0 + C(11,7)*v1 + C(10,6)*v2 + C(9,5)*v3 + C(8,4)*v4 *)

Print["Verifying Toeplitz transfer for j=0..q1:"];
Do[
  p = p0 + k p1; q = q0 + k q1;
  pN = p + p1; qN = q + q1;
  vPrev = Table[pathsRat[p, q, j], {j, 0, q1}];
  Do[
    predicted = Sum[Binomial[p1 - 1 + j - s, j - s] vPrev[[s + 1]], {s, 0, q1}];
    actual = pathsRat[pN, qN, j];
    If[predicted =!= actual,
      Print["  k=", k, " j=", j, ": MISMATCH"]],
    {j, 0, q1}];
  Print["  k=", k, ": Toeplitz exact for j=0..q1"],
  {k, 1, 4}];
Print[""];

(* === KEY EXPERIMENT: the "reduced" 2x2 transfer === *)
(* For fixed j, v_j(p0+k*p1) is a known function of k *)
(* For j <= q1: v_j = (p-wj)/p * C(p+j-1, j) = polynomial in k *)
(* For j = q (last): v_q = B(p, q) *)
(* *)
(* The RATIO v_q(k+1)/v_q(k) = B(p+p1, q+q1)/B(p, q) *)
(* = C(p+p1+q+q1-1, q+q1) * p / (C(p+q-1, q) * (p+p1)) *)

Print["===== RATIO B(p+p1, q+q1) / B(p, q) ====="];
Do[
  p = p0 + k p1; q = q0 + k q1;
  pN = p + p1; qN = q + q1;
  ratio = B[pN, qN] / B[p, q];
  Print["k=", k, ": B(", pN, ",", qN, ")/B(", p, ",", q, ") = ",
    ratio, " = ", N[ratio, 10]],
  {k, 1, 5}];
Print[""];

(* === Check: does this ratio satisfy a RECURRENCE? === *)
Print["Ratio growth:"];
ratios = Table[
  Module[{p = p0 + k p1, q = q0 + k q1},
    B[p + p1, q + q1] / B[p, q]],
  {k, 1, 6}];
Print["Ratios: ", ratios];
Print["Ratio of ratios: ", ratios[[2 ;;]] / ratios[[;; -2]]];
