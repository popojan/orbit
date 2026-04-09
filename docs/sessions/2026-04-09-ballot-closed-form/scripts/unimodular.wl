(* UNIMODULARITY: det(M_top) = 1 and the CF determinant connection *)

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

B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* === CF determinant === *)
Print["===== CF DETERMINANT ====="];
Print["p1*q0 - p0*q1 = ", p1 q0 - p0 q1, " (should be 1)"];
Print["p2*q1 - p1*q2 = ", p2 q1 - p1 q2, " (should be -1)"];
Print[""];

(* === Block transfer M1 determinant structure === *)
M1 = blockTransferActual[q1 + 1, alpha, 11, 20];
Print["===== M1 (9x5) DETERMINANT STRUCTURE ====="];

(* The top (q1+1) x (q1+1) square is pure Toeplitz *)
Print["det(top 5x5) = ", Det[M1[[1 ;; 5]]]];

(* What about maximal minors? (5x5 from a 9x5 matrix) *)
(* There are C(9,5) = 126 such minors *)
Print["All maximal (5x5) minors of M1:"];
minors = {};
Do[
  rows = Subsets[Range[9], {5}][[i]];
  d = Det[M1[[rows]]];
  If[d =!= 0, AppendTo[minors, {rows, d}]],
  {i, 1, Binomial[9, 5]}];
Print["  Nonzero minors: ", Length[minors], " / ", Binomial[9, 5]];
Print["  Values: ", Union[Last /@ minors]];
Print["  GCD of all nonzero minors: ", GCD @@ (Last /@ minors)];
Print[""];

(* Show a few *)
Do[Print["  rows ", minors[[i, 1]], ": det = ", minors[[i, 2]]],
  {i, 1, Min[10, Length[minors]]}];
Print[""];

(* === v_{q-1} = v_q identity === *)
Print["===== v_{q-1} = v_q IDENTITY ====="];
Do[
  p = p0 + k p1; q = q0 + k q1;
  vLast = pathsRat[p, q, q];
  vPenult = pathsRat[p, q, q - 1];
  Print["k=", k, " p/q=", p, "/", q, ": v_{q-1}=v_q=", vLast,
    " = B(", p, ",", q, ")? ", vLast === B[p, q]],
  {k, 1, 5}];
Print[""];

(* === This means: M1 has a SPECIAL structure in its last column === *)
(* The last two rows of M1 when applied to v(prev) give the SAME value *)
(* Row q1 and row 2q1 of M1, dotted with v(prev), are equal *)
(* This means: row_{2q1} - row_{q1} is in the null space of v(prev) *)
Print["===== ROW RELATIONS IN M1 ====="];
Print["Row q1 (=4):  ", M1[[q1 + 1]]];
Print["Row 2q1 (=8): ", M1[[2 q1 + 1]]];
Print["Row 2q1 - row q1: ", M1[[2 q1 + 1]] - M1[[q1 + 1]]];
Print[""];

(* This difference should be orthogonal to all v(prev) at semi-convergents *)
diff = M1[[2 q1 + 1]] - M1[[q1 + 1]];
Do[
  p = p0 + k p1; q = q0 + k q1;
  v = Table[pathsRat[p, q, j], {j, 0, q1}];
  dot = diff . v;
  Print["  k=", k, ": diff . v(", p, ") = ", dot],
  {k, 1, 5}];
Print[""];

(* === Actually, v_{q-1} = v_q is because of the RISE at the last step === *)
(* After a rise at height q-1 -> q, the new entry v_q = v_{q-1} (copied) *)
(* So this is structural, not coincidental. *)
(* In matrix terms: the last row of blockTransfer equals the second-to-last *)
(* NO: that's not right, the matrix is from the block transfer perspective *)

(* === Let's verify for Pi too === *)
Print["===== Pi: v_{q-1} = v_q? ====="];
alphaPi = Pi; wPi = 3;
p0Pi = 3; q0Pi = 1; p1Pi = 22; q1Pi = 7;
Do[
  p = p0Pi + k p1Pi; q = q0Pi + k q1Pi;
  vLast = pathsRat[p, q, q];
  vPenult = pathsRat[p, q, q - 1];
  Print["k=", k, " p/q=", p, "/", q, ": v_{q-1}=v_q? ", vLast === vPenult],
  {k, 1, 4}];
Print[""];

(* === BALLOT NUMBER RECURRENCE === *)
(* B(p+p1, q+q1) as function of B(p,q) *)
(* The block transfer gives: v_q(p+p1) = Sum_s M[2q1, s] v_s(p) *)
(* = Sum_s M[2q1, s] v_s(p) *)
(* And v_q(p+p1) = B(p+p1, q+q1) *)

Print["===== BALLOT RECURRENCE FROM BLOCK TRANSFER ====="];
Print["B(p+p1, q+q1) = last row of M1 . v(p)"];
Print["Last row of M1: ", M1[[2 q1 + 1]]];
Print[""];

(* This gives: B(p+p1, q+q1) = Sum_s M1[2q1, s] * v_s(p) *)
(* For the first q1+1 entries, v_s = uniform formula *)
(* For s > q1: v_s includes corrections *)
(* Since M1 is 9x5 and input has 5 entries (s=0..4), ALL entries are uniform *)

Do[
  p = p0 + k p1; q = q0 + k q1;
  v = Table[pathsRat[p, q, j], {j, 0, q1}];
  predicted = M1[[2 q1 + 1]] . v;
  actual = B[p + p1, q + q1];
  Print["k=", k, ": M1_last . v(", p, ") = ", predicted, " = B(", p + p1, ",", q + q1, ") = ", actual, " match=", predicted === actual],
  {k, 1, 4}];
Print[""];

(* === THE RECURRENCE: explicit === *)
(* B(p+9, q+4) = 11139*v0 + 5319*v1 + 2313*v2 + 882*v3 + 273*v4 *)
(* where v_j = v_j(p, q) = pathsRat[p, q, j] *)
(* For j <= q1=4: v_j = (p-2j)/p * C(p+j-1, j) *)
Print["BALLOT RECURRENCE (explicit for sqrt(5)):"];
Print["B(p+9, q+4) = 11139 + 5319*(p-2)/p*C(p,1) + 2313*(p-4)/p*C(p+1,2)"];
Print["             + 882*(p-6)/p*C(p+2,3) + 273*(p-8)/p*C(p+3,4)"];
Print["where p = p0 + k*p1, q = q0 + k*q1"];
Print[""];

(* Verify explicitly *)
Do[
  p = p0 + k p1; q = q0 + k q1;
  formula = 11139 + 5319 vLin[p, ww, 1] + 2313 vLin[p, ww, 2] +
    882 vLin[p, ww, 3] + 273 vLin[p, ww, 4];
  actual = B[p + p1, q + q1];
  Print["k=", k, ": formula=", formula, " actual=", actual, " match=", formula === actual],
  {k, 1, 5}];
Print[""];

(* === 273 = B(11,5) = B(p0+p1, q0+q1) in the last coefficient! === *)
Print["Note: coefficient 273 = B(11,5) = B(p0+p1, q0+q1)"];
Print["And 11139 = M1[8,0] = total paths from (1,0) to (9,8) below staircase"];
Print[""];

(* === Can we express ALL M1 last-row entries via ballot numbers? === *)
Print["M1 last row: ", M1[[2 q1 + 1]]];
Print["  11139 = ?"];
Print["  5319 = ?"];
Print["  2313 = ?"];
Print["  882 = ?"];
Print["  273 = B(11,5)"];

(* 273 = B(11,5) *)
(* 882 = ? C(9,3)*3 = 84*3 = 252 no. 882 = 2*441 = 2*21^2 *)
(* Or: 882 = v_3(9)? v_3(9) = (9-6)/9 * C(11,3) = 3/9 * 165 = 55 no *)
(* 882 = C(9,2)*C(4,1) + ... ? *)
(* Actually: these are entries of the block transfer matrix. *)
(* From Toeplitz: M1[8,s] = C(8+8-s, 8-s) - Delta[8,s] *)
(* T[8,0] = C(16,8) = 12870 *)
(* So Delta[8,0] = 12870 - 11139 = 1731 *)
Print[""];
Print["Toeplitz T[8,s]: ", Table[Binomial[p1 - 1 + 2 q1 - s, 2 q1 - s], {s, 0, q1}]];
Print["Delta[8,s] = T - M: ", Table[Binomial[p1 - 1 + 2 q1 - s, 2 q1 - s], {s, 0, q1}] - M1[[2 q1 + 1]]];
Print["From Result 7: Delta[8,s] should be the d=2 correction row"];
