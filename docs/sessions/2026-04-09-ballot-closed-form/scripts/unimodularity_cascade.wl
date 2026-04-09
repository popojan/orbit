(* Q3: UNIMODULARITY CASCADE *)
(* Does det(M_top) = 1 propagate from level 1 to level 2? *)
(*                                                          *)
(* Level 1: top (q1+1)x(q1+1) of M1 is pure Toeplitz,     *)
(*   lower-triangular with 1s on diagonal => det=1 trivially *)
(* Level 2: top block of M2 includes level-1 corrections    *)
(*   => det=1 would be NON-TRIVIAL                          *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat
]

(* Convergent-to-convergent transfer: from position pPrev to pCurr *)
(* Input dim = qPrev+1, output dim = qCurr+1 *)
convTransfer[alpha_, pPrev_, qPrev_, pCurr_] :=
  blockTransferActual[qPrev + 1, alpha, pPrev, pCurr]

(* ============================================================= *)
(*                       sqrt(5)                                  *)
(* ============================================================= *)
Print["################################################################"];
Print["#                    sqrt(5) = [2; 4,4,4,...]                  #"];
Print["################################################################"];
Print[""];

alpha5 = Sqrt[5]; w5 = 2;
(* Convergents *)
{p0, q0} = {2, 1};
{p1, q1} = {9, 4};
{p2, q2} = {38, 17};
{p3, q3} = {161, 72};

Print["CF determinants:"];
Print["  p1*q0 - p0*q1 = ", p1 q0 - p0 q1];
Print["  p2*q1 - p1*q2 = ", p2 q1 - p1 q2];
Print["  p3*q2 - p2*q3 = ", p3 q2 - p2 q3];
Print[""];

(* === 1. Convergent-to-convergent transfers === *)
Print["===== CONVERGENT-TO-CONVERGENT TRANSFERS ====="];

C1 = convTransfer[alpha5, p0, q0, p1]; (* 5x2 *)
C2 = convTransfer[alpha5, p1, q1, p2]; (* 18x5 *)
C3 = convTransfer[alpha5, p2, q2, p3]; (* 73x18 *)

Print["C1 dims (p0->p1): ", Dimensions[C1]];
Print["C2 dims (p1->p2): ", Dimensions[C2]];
Print["C3 dims (p2->p3): ", Dimensions[C3]];
Print[""];

(* Top square block determinants *)
Print["det(C1_top ", q0 + 1, "x", q0 + 1, ") = ", Det[C1[[1 ;; q0 + 1]]]];
Print["det(C2_top ", q1 + 1, "x", q1 + 1, ") = ", Det[C2[[1 ;; q1 + 1]]]];
Print["det(C3_top ", q2 + 1, "x", q2 + 1, ") = ", Det[C3[[1 ;; q2 + 1]]]];
Print[""];

(* === 2. Level-1 block transfer === *)
Print["===== LEVEL-1 BLOCK TRANSFER (semi-conv to semi-conv) ====="];
(* M1 maps from one level-1 semi-convergent to the next *)
(* Position p0+k*p1 -> p0+(k+1)*p1, dim q0+k*q1+1 -> q0+(k+1)*q1+1 *)
(* For the FIRST block (k=1->2): dim q0+q1+1=6 -> q0+2*q1+1=10 *)
(* But Result 7 shows M1 is dimension-independent, so use initial dim q1+1=5 *)

M1 = blockTransferActual[q1 + 1, alpha5, p0 + p1, p0 + 2 p1]; (* 9x5 *)
Print["M1 dims: ", Dimensions[M1]];
Print["det(M1_top 5x5) = ", Det[M1[[1 ;; q1 + 1]]]];
Print[""];

(* === 3. Level-2 block transfer === *)
Print["===== LEVEL-2 BLOCK TRANSFER ====="];
(* M2 maps between level-2 semi-convergents *)
(* First level-2 semi-conv: p1+p2 = 47, q1+q2 = 21 *)
(* Second: p1+2*p2 = 85, q1+2*q2 = 38 *)
(* Input dim = q1+q2+1 = 22, output should have q1+2*q2+1 = 39 entries *)

initDim2 = q1 + q2 + 1; (* 22 *)
M2 = blockTransferActual[initDim2, alpha5, p1 + p2, p1 + 2 p2]; (* 39x22 *)
Print["M2 dims: ", Dimensions[M2]];
Print["det(M2_top 22x22) = ", Det[M2[[1 ;; initDim2]]]];
Print[""];

(* === 4. Composed transfers === *)
Print["===== COMPOSED CONVERGENT TRANSFERS ====="];
C21 = C2 . C1; (* 18x2 *)
C321 = C3 . C2 . C1; (* 73x2 *)

Print["C2.C1 dims: ", Dimensions[C21], " (p0->p2)"];
Print["C3.C2.C1 dims: ", Dimensions[C321], " (p0->p3)"];
Print[""];

(* The 2x2 "ballot minor" from composed transfer *)
(* At position p0 we have heights 0..q0, so input dim = 2 *)
(* At position p2, the last two entries v_{q2-1}, v_{q2} = B(p2, q2) *)
(* The 2x2 submatrix rows {q2-1, q2} of C21 should relate to CF det *)
Print["2x2 ballot submatrices of C2.C1:"];
sub_last = C21[[{q2, q2 + 1}]]; (* rows q2-1, q2, 0-indexed *)
Print["  rows {q2-1,q2} = {", q2 - 1, ",", q2, "}: ", sub_last];
Print["  det = ", Det[sub_last]];
Print[""];

(* More 2x2 minors of C21 *)
Print["All nonzero 2x2 minors of C21 (18x2):"];
Do[
  sub = C21[[{r1 + 1, r2 + 1}]];
  d = Det[sub];
  If[d =!= 0,
    Print["  rows {", r1, ",", r2, "}: det = ", d,
      If[Abs[d] === 1, " *** UNIMODULAR ***", ""]]],
  {r1, 0, q2 - 1}, {r2, r1 + 1, q2}];
Print[""];

(* GCD of all 2x2 minors *)
minors21 = {};
Do[
  d = Det[C21[[{r1 + 1, r2 + 1}]]];
  If[d =!= 0, AppendTo[minors21, d]],
  {r1, 0, q2 - 1}, {r2, r1 + 1, q2}];
Print["GCD of all 2x2 minors of C2.C1: ", GCD @@ minors21];
Print[""];

(* === 5. Maximal minors of C2 (18x5) === *)
Print["===== MAXIMAL MINORS OF C2 (p1->p2, 18x5) ====="];
minorsC2 = {};
rowSetsC2 = Subsets[Range[0, q2], {q1 + 1}];
Print["Number of 5x5 minors: ", Length[rowSetsC2]];

Do[
  sub = C2[[rows + 1]];
  d = Det[sub];
  If[d =!= 0, AppendTo[minorsC2, {rows, d}]],
  {rows, rowSetsC2}];

Print["Nonzero minors: ", Length[minorsC2], " / ", Length[rowSetsC2]];
Print["GCD of all nonzero minors: ", GCD @@ (Last /@ minorsC2)];
Print[""];

(* Show the ones that are +-1 *)
uniMinorsC2 = Select[minorsC2, Abs[Last[#]] === 1 &];
Print["Unimodular (det=+-1) minors: ", Length[uniMinorsC2]];
Do[Print["  rows ", First[m], ": det = ", Last[m]],
  {m, uniMinorsC2}];
Print[""];

(* Top minor *)
Print["Top minor (rows 0..", q1, "): det = ", Det[C2[[1 ;; q1 + 1]]]];
(* Bottom minor *)
Print["Bottom minor (rows ", q2 - q1, "..", q2, "): det = ",
  Det[C2[[q2 - q1 + 1 ;; q2 + 1]]]];
(* Last two equal => row q2-1 and q2 are identical *)
Print["Row q2-1 = Row q2? ", C2[[q2]] === C2[[q2 + 1]]];
Print[""];

(* === 6. Maximal minors of M1 === *)
Print["===== MAXIMAL MINORS OF M1 (level-1 block, 9x5) ====="];
minorsM1 = {};
rowSetsM1 = Subsets[Range[0, 2 q1], {q1 + 1}];
Do[
  sub = M1[[rows + 1]];
  d = Det[sub];
  If[d =!= 0, AppendTo[minorsM1, {rows, d}]],
  {rows, rowSetsM1}];

Print["Nonzero minors: ", Length[minorsM1], " / ", Length[rowSetsM1]];
Print["GCD of all nonzero minors: ", GCD @@ (Last /@ minorsM1)];
uniMinorsM1 = Select[minorsM1, Abs[Last[#]] === 1 &];
Print["Unimodular (det=+-1) minors: ", Length[uniMinorsM1]];
Do[Print["  rows ", First[m], ": det = ", Last[m]], {m, uniMinorsM1}];
Print[""];

(* === 7. MAXIMAL MINORS of M2 (level-2 block, 39x22) === *)
(* C(39,22) = too many! Sample strategically. *)
Print["===== LEVEL-2 BLOCK TRANSFER: STRATEGIC MINORS ====="];

(* Top 22x22 *)
Print["det(M2_top 22x22) = ", Det[M2[[1 ;; 22]]]];

(* Bottom 22x22 *)
Print["det(M2_bottom 22x22) = ", Det[M2[[18 ;; 39]]]];

(* The "natural" minor: rows 0..20, plus row 21 (= initDim2-1) *)
(* This is the same as top 22x22 since initDim2 = 22 *)

(* Rows that span from Toeplitz region into correction region *)
(* Toeplitz rows: 0..21 (= A2+1 = q1+q2 = 21) *)
(* First correction row: 22 *)
(* Try replacing one Toeplitz row with a correction row *)
Print[""];
Print["Replacing one row of top 22x22 with correction rows:"];
baseRows = Range[0, 20]; (* rows 0..20, size 21 *)
Do[
  rows = Append[baseRows, corrRow];
  sub = M2[[Sort[rows] + 1]];
  d = Det[sub];
  Print["  rows {0..20, ", corrRow, "}: det = ", d],
  {corrRow, 21, Min[38, 30]}];
Print[""];

(* === 8. The KEY test: "convergent minor" of M2 === *)
(* At level 2, the input has entries j=0..21 (heights 0..q1+q2) *)
(* The output has entries j=0..38 (heights 0..q1+2*q2) *)
(* The "convergent structure" should select heights at convergent positions *)
(* i.e., heights 0, q1, q1+q2, q1+2*q2 (the CF convergent denominators) *)
Print["===== CONVERGENT-HEIGHT MINORS ====="];
Print["CF convergent denominators: q0=", q0, " q1=", q1, " q2=", q2];
Print["Heights at convergent positions in output: 0..", q1, ", ", q1 + q2, ", ", q1 + 2 q2];
Print[""];

(* The (q1+1)x(q1+1) submatrix of M2 at convergent heights *)
convHeightsOut = Range[0, q1]; (* rows 0..q1 in output *)
convHeightsIn = Range[0, q1]; (* cols 0..q1 in input *)
subConv = M2[[convHeightsOut + 1, convHeightsIn + 1]];
Print["M2 restricted to heights 0..q1 (both in/out):"];
Print["  det = ", Det[subConv]];
Print[""];

(* ============================================================= *)
(*                          Pi                                     *)
(* ============================================================= *)
Print[""];
Print["################################################################"];
Print["#                    Pi = [3; 7,15,1,...]                      #"];
Print["################################################################"];
Print[""];

alphaPi = Pi; wPi = 3;
{p0Pi, q0Pi} = {3, 1};
{p1Pi, q1Pi} = {22, 7};
{p2Pi, q2Pi} = {333, 106};

Print["CF determinants:"];
Print["  p1*q0 - p0*q1 = ", p1Pi q0Pi - p0Pi q1Pi];
Print["  p2*q1 - p1*q2 = ", p2Pi q1Pi - p1Pi q2Pi];
Print[""];

(* Convergent-to-convergent *)
C1Pi = convTransfer[alphaPi, p0Pi, q0Pi, p1Pi]; (* 8x2 *)
C2Pi = convTransfer[alphaPi, p1Pi, q1Pi, p2Pi]; (* 107x8 *)

Print["C1_Pi dims: ", Dimensions[C1Pi]];
Print["C2_Pi dims: ", Dimensions[C2Pi]];
Print["det(C1_Pi_top 2x2) = ", Det[C1Pi[[1 ;; q0Pi + 1]]]];
Print["det(C2_Pi_top 8x8) = ", Det[C2Pi[[1 ;; q1Pi + 1]]]];
Print[""];

(* 2x2 minors of C2.C1 for Pi *)
C21Pi = C2Pi . C1Pi; (* 107x2 *)
Print["C21_Pi dims: ", Dimensions[C21Pi]];

(* Last row minor *)
Print["2x2 minor at rows {q2-1, q2} = {", q2Pi - 1, ",", q2Pi, "}:"];
sub_lastPi = C21Pi[[{q2Pi, q2Pi + 1}]];
Print["  det = ", Det[sub_lastPi]];
Print[""];

(* GCD of ALL 2x2 minors *)
minors21Pi = {};
Do[
  d = Det[C21Pi[[{r1 + 1, r2 + 1}]]];
  If[d =!= 0, AppendTo[minors21Pi, d]],
  {r1, 0, q2Pi - 1}, {r2, r1 + 1, q2Pi}];
Print["GCD of all 2x2 minors of C21_Pi: ", GCD @@ minors21Pi];
Print[""];

(* Level-1 block transfer for Pi *)
M1Pi = blockTransferActual[q1Pi + 1, alphaPi, p0Pi + p1Pi, p0Pi + 2 p1Pi];
Print["M1_Pi dims: ", Dimensions[M1Pi]];
Print["det(M1_Pi_top 8x8) = ", Det[M1Pi[[1 ;; q1Pi + 1]]]];
Print[""];

(* Maximal minors of M1_Pi *)
minorsM1Pi = {};
rowSetsM1Pi = Subsets[Range[0, 2 q1Pi], {q1Pi + 1}];
Do[
  sub = M1Pi[[rows + 1]];
  d = Det[sub];
  If[d =!= 0, AppendTo[minorsM1Pi, {rows, d}]],
  {rows, rowSetsM1Pi}];
Print["M1_Pi nonzero minors: ", Length[minorsM1Pi], " / ", Length[rowSetsM1Pi]];
Print["GCD of all nonzero M1_Pi minors: ", GCD @@ (Last /@ minorsM1Pi)];
uniMinorsM1Pi = Select[minorsM1Pi, Abs[Last[#]] === 1 &];
Print["Unimodular minors: ", Length[uniMinorsM1Pi]];
Do[Print["  rows ", First[m], ": det = ", Last[m]], {m, uniMinorsM1Pi}];
Print[""];

(* Maximal minors of C2_Pi (107x8) - C(107,8) is huge! *)
(* Just check a few strategic ones *)
Print["===== C2_Pi STRATEGIC MINORS ====="];
Print["det(C2_Pi_top 8x8) = ", Det[C2Pi[[1 ;; q1Pi + 1]]]];
Print["det(C2_Pi rows {0..6, q2}) = ",
  Det[C2Pi[[Append[Range[1, q1Pi], q2Pi + 1]]]]];
Print["det(C2_Pi rows {0..6, q2-1}) = ",
  Det[C2Pi[[Append[Range[1, q1Pi], q2Pi]]]]];
Print[""];

(* Check rows {q2-7..q2} (bottom 8x8) *)
Print["det(C2_Pi bottom 8x8, rows ", q2Pi - q1Pi, "..", q2Pi, ") = ",
  Det[C2Pi[[q2Pi - q1Pi + 1 ;; q2Pi + 1]]]];

(* Row q2-1 = Row q2? *)
Print["Row q2-1 = Row q2? ", C2Pi[[q2Pi]] === C2Pi[[q2Pi + 1]]];
Print[""];

Print["===== DONE ====="];
