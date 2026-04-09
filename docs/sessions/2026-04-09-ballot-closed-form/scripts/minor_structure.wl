(* MAXIMAL MINORS OF M1: systematic analysis *)
(* M1 is 9x5. Its 5x5 minors encode the full information of M1. *)
(* If ALL minors have a ballot/binomial structure, we have the formula. *)

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

B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];

(* === sqrt(5) level 1 === *)
alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4;

M1 = blockTransferActual[q1 + 1, alpha, 11, 20];
Print["M1 (9x5):"];
Do[Print["  row ", j, ": ", M1[[j + 1]]], {j, 0, 2 q1}];
Print[""];

(* Toeplitz part *)
T1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 2 q1}, {s, 0, q1}];
D1 = T1 - M1;

(* === ALL 5x5 minors === *)
(* There are C(9,5) = 126 maximal minors *)
(* Index by the 5 ROW indices chosen (0-based) *)
Print["===== ALL MAXIMAL MINORS ====="];
Print["(rows are 0-indexed)"];
Print[""];

allMinors = {};
rowSets = Subsets[Range[0, 2 q1], {q1 + 1}];
Do[
  rows = rs;
  sub = M1[[rows + 1]];
  d = Det[sub];
  AppendTo[allMinors, {rows, d}],
  {rs, rowSets}];

(* Sort by value *)
sorted = SortBy[allMinors, Abs[Last[#]] &];

(* Show ALL *)
Do[
  {rows, d} = sorted[[i]];
  If[d =!= 0,
    (* Try to factor *)
    f = FactorInteger[Abs[d]];
    Print["rows ", rows, ": det = ", d, " = ", f]],
  {i, 1, Length[sorted]}];
Print[""];

(* === Look for ballot numbers among the minors === *)
Print["===== BALLOT NUMBERS AMONG MINORS ====="];
knownBallots = Table[{n, k, B[n, k]}, {n, 1, 30}, {k, 1, n - 1}];
knownBallots = Select[Flatten[knownBallots, 1], IntegerQ[#[[3]]] &];
ballotSet = Association[# -> {#2, #3} & @@@ ({#[[3]], #[[1]], #[[2]]} & /@ knownBallots)];

Do[
  {rows, d} = allMinors[[i]];
  If[d =!= 0 && KeyExistsQ[ballotSet, Abs[d]],
    {n, k} = ballotSet[Abs[d]];
    Print["rows ", rows, ": det = ", d, " = ",
      If[d > 0, "", "-"], "B(", n, ",", k, ")"]],
  {i, 1, Length[allMinors]}];
Print[""];

(* === Minors involving the TOEPLITZ rows only (rows 0..5) === *)
Print["===== TOEPLITZ-ONLY MINORS ====="];
Do[
  rows = Subsets[Range[0, q1 + 1], {q1 + 1}][[i]];
  sub = M1[[rows + 1]];
  d = Det[sub];
  Print["rows ", rows, ": det = ", d],
  {i, 1, Binomial[q1 + 2, q1 + 1]}];
Print[""];

(* === Minors involving EXACTLY one correction row === *)
Print["===== MINORS WITH ONE CORRECTION ROW ====="];
Do[
  corrRow = cr;
  baseRows = Range[0, q1 - 1]; (* rows 0..3, always included *)
  rows = Append[baseRows, corrRow];
  sub = M1[[rows + 1]];
  d = Det[sub];
  Print["rows {0,1,2,3,", corrRow, "}: det = ", d,
    "  = M1[", corrRow, ", 4] = ", M1[[corrRow + 1, q1 + 1]],
    "  match? ", d === M1[[corrRow + 1, q1 + 1]]],
  {cr, q1, 2 q1}];
Print[""];

(* === The pattern: det{0,..,q1-1, j} = M1[j, q1] === *)
(* Because rows 0..q1-1 form identity (lower triangular with 1s on diagonal) *)
(* So the determinant is just the (j, q1) entry of M1 *)
Print["This is trivial: rows {0,..,q1-1} form an identity block."];
Print["So det = M1[j, q1] which is just the last column of M1."];
Print["Last column: ", M1[[All, q1 + 1]]];
Print[""];

(* === More interesting: minors with rows {0,..,q1-2, j1, j2} === *)
Print["===== MINORS WITH TWO NON-TRIVIAL ROWS ====="];
Print["rows {0,1,2, j1, j2}: det = ?"];
Do[
  rows = {0, 1, 2, j1, j2};
  sub = M1[[rows + 1]];
  d = Det[sub];
  If[d =!= 0,
    Print["  {0,1,2,", j1, ",", j2, "}: ", d]],
  {j1, 3, 2 q1 - 1}, {j2, j1 + 1, 2 q1}];
Print[""];

(* === THE DEEPER STRUCTURE: Pluecker relations === *)
(* The maximal minors of a matrix satisfy Pluecker relations *)
(* (quadratic identities). These might connect ballot numbers *)
(* at different positions. *)
Print["===== PLUECKER RELATIONS ====="];
(* For a 9x5 matrix, the Pluecker coordinate p_{I} = det(M[I, :]) *)
(* satisfies: for any sets I, J of size 5, and any index a in I: *)
(* sum_{b in J} (-1)^{pos} p_{I\a cup b} p_{J\b cup a} = 0 *)

(* Simple test: I = {0,1,2,3,4}, J = {0,1,2,3,8} *)
(* a = 4 (from I), swap with each b in J *)
pI = Det[M1[[{1, 2, 3, 4, 5}]]]; (* rows 0,1,2,3,4: det=1 *)
pJ = Det[M1[[{1, 2, 3, 4, 9}]]]; (* rows 0,1,2,3,8: det=273 *)

Print["p_{01234} = ", pI];
Print["p_{01238} = ", pJ];
Print[""];

(* Grassmann-Pluecker: p_I * p_J = ... *)
(* For rows {0,1,2,3,4} and {0,1,2,3,8}: *)
(* p_{01234} * p_{01238} - p_{01238} * p_{01234} = 0 (trivial) *)
(* Need DIFFERENT I, J *)

(* Let's check the relation for I={0,1,2,3,4}, J={4,5,6,7,8}: *)
I0 = {0, 1, 2, 3, 4};
J0 = {4, 5, 6, 7, 8};
pI0 = Det[M1[[I0 + 1]]];
pJ0 = Det[M1[[J0 + 1]]];
Print["p_{01234} = ", pI0, "  p_{45678} = ", pJ0];

(* Pluecker: swap element 4 from I with elements of J *)
(* p_{01234} p_{45678} = sum over b in J of p_{0123b} p_{(J\b)cup4} *)
(* = p_{01234}*p_{45678} + p_{01235}*p_{44678} + ... but 4 is already in J! *)
(* Let me use a cleaner formulation *)

(* === Actually, let's look at what the minor structure tells us === *)
(* The Compound matrix (exterior power) Lambda^5(M1) is a C(9,5) x 1 vector *)
(* (since M1 has 5 columns, Lambda^5 is the vector of maximal minors) *)

Print["===== KEY: M1[j, q1] = last column ====="];
lastCol = M1[[All, q1 + 1]];
Print["Last column of M1: ", lastCol];
Print[""];

(* The last column of M1 gives v_j when applied to e_{q1} = (0,0,0,0,1) *)
(* i.e., it maps the "highest input" to the full output *)
(* v_j = M1[j, q1] when input = e_{q1} *)

(* For the Toeplitz part: T1[j, q1] = C(p1-1+j-q1, j-q1) = C(4+j, j-4) *)
Print["Toeplitz last col: ", T1[[All, q1 + 1]]];
Print["Correction (T-M) last col: ", T1[[All, q1 + 1]] - lastCol];
Print[""];

(* === THE INSIGHT: M1 applied to B(p,q)*e_q produces B(p+p1, q+q1)*e_{q+q1} === *)
(* Not exactly, but the LAST ENTRY of M1 . v = B(next) *)
(* And v = B(p,q) * e_{q} + lower entries *)
(* The "lower entries" are determined by the uniform formula *)

(* === Compound matrix for Pi === *)
Print["===== Pi level-1 for comparison ====="];
alphaPi = Pi; wPi = 3;
p0Pi = 3; q0Pi = 1; p1Pi = 22; q1Pi = 7;

M1Pi = blockTransferActual[q1Pi + 1, alphaPi, 25, 47];
Print["M1_Pi dims: ", Dimensions[M1Pi]];
Print["det(top 8x8) = ", Det[M1Pi[[1 ;; q1Pi + 1]]]];

(* Last column *)
lastColPi = M1Pi[[All, q1Pi + 1]];
Print["M1_Pi last column entries at correction rows:"];
Do[Print["  j=", j, ": M1[j,q1]=", M1Pi[[j + 1, q1Pi + 1]],
    "  T[j,q1]=", Binomial[p1Pi - 1 + j - q1Pi, j - q1Pi],
    "  Delta=", Binomial[p1Pi - 1 + j - q1Pi, j - q1Pi] - M1Pi[[j + 1, q1Pi + 1]]],
  {j, q1Pi + 2, 2 q1Pi}];

(* Is the last entry always B(p0+p1, q0+q1)? *)
Print[""];
Print["M1[2q1, q1] for sqrt(5): ", M1[[2 q1 + 1, q1 + 1]], " = B(11,5) = ", B[11, 5]];
Print["M1[2q1, q1] for Pi:      ", M1Pi[[2 q1Pi + 1, q1Pi + 1]], " = B(25,8) = ", B[25, 8]];
