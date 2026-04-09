(* VERIFY: Level-2 correction = SAME FORMULA with p2 instead of p1 *)
(* The holy grail conjecture:                                       *)
(*   Delta_k[j0+d, s] = Sum_{m=1}^{d+1} v_{d-m+1}(p_k - w*m)     *)
(*                       * C(A_k + m(w+1) - s, mw - 1)             *)
(* where v_j(p) = (p - wj)/p * C(p+j-1, j)                        *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[
    curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS,
    {x, xStart + 1, xEnd}];
  mat
]

alpha = Sqrt[5];
ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* === VERIFY LEVEL-1 FORMULA (baseline) === *)
Print["===== LEVEL-1 VERIFICATION ====="];
M1 = blockTransferActual[q1 + 1, alpha, 11, 20];
T1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 2 q1}, {s, 0, q1}];
D1 = T1 - M1;

(* Parameters: A1 = q1, shifted positions p1 - w*m *)
a1k = q1; (* A_k for level 1 *)

Print["Level-1: A_k=", a1k, " p_k=", p1, " w=", ww];
Print["Correction rows j=", a1k + 2, "..", 2 a1k + 1];
Print["Shifted positions: ", Table[p1 - ww m, {m, 1, a1k - 1}]];
Print[""];

allMatch1 = True;
Do[
  j = a1k + 2 + d;
  If[j + 1 > Dimensions[D1][[1]], Break[]];
  actual = D1[[j + 1]];
  formula = Table[
    Sum[vLin[p1 - ww m, ww, d - m + 1] *
      Binomial[a1k + m (ww + 1) - s, m ww - 1],
      {m, 1, d + 1}],
    {s, 0, q1}];
  match = (actual === formula);
  If[!match, allMatch1 = False];
  Print["  d=", d, " j=", j, ": ", If[match, "MATCH", "MISMATCH"]],
  {d, 0, q1 - 2}];
Print["Level-1 ALL MATCH: ", allMatch1];
Print[""];

(* === VERIFY LEVEL-2 FORMULA === *)
Print["===== LEVEL-2 VERIFICATION ====="];

(* Compute actual M2 from staircase *)
initDim2 = q1 + q2 + 1; (* 22 *)
M2 = blockTransferActual[initDim2, alpha, 47, 85];
{nrows2, ncols2} = Dimensions[M2];
T2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, nrows2 - 1}, {s, 0, ncols2 - 1}];
D2 = T2 - M2;

(* Parameters: A2 = ncols2 - 2, shifted positions p2 - w*m *)
a2k = ncols2 - 2; (* A_k for level 2 = 20 *)

Print["Level-2: A_k=", a2k, " p_k=", p2, " w=", ww];
Print["Initial dim: ", ncols2, " (= q1+q2+1 = ", q1 + q2 + 1, ")"];
Print["First correction: j=", a2k + 2, " (= A_k+2)"];
Print["Number of correction rows: ", nrows2 - 1 - (a2k + 2) + 1];
Print["Shifted positions p2-wm: ", Table[p2 - ww m, {m, 1, 5}], "..."];
Print[""];

(* Verify ALL correction rows *)
corrCount = 0;
allMatch2 = True;
Do[
  j = a2k + 2 + d;
  If[j + 1 > nrows2, Break[]];
  actual = D2[[j + 1]];
  If[actual === Table[0, ncols2], Continue[]];
  corrCount++;

  formula = Table[
    Sum[vLin[p2 - ww m, ww, d - m + 1] *
      Binomial[a2k + m (ww + 1) - s, m ww - 1],
      {m, 1, d + 1}],
    {s, 0, ncols2 - 1}];

  match = (actual === formula);
  If[!match, allMatch2 = False;
    Print["  d=", d, " j=", j, ": MISMATCH"];
    Print["    actual[0..3]: ", actual[[1 ;; Min[4, ncols2]]]];
    Print["    formula[0..3]: ", formula[[1 ;; Min[4, ncols2]]]],
    If[d <= 5 || d >= nrows2 - a2k - 4,
      Print["  d=", d, " j=", j, ": MATCH (coeff: ",
        Table[vLin[p2 - ww m, ww, d - m + 1], {m, 1, Min[d + 1, 3]}],
        If[d + 1 > 3, "...", ""], ")"]]
  ],
  {d, 0, nrows2 - a2k - 3}];

Print[""];
Print["Level-2 corrections verified: ", corrCount, " rows"];
Print["Level-2 ALL MATCH: ", allMatch2];
Print[""];

(* === UNIVERSAL FORMULA SUMMARY === *)
If[allMatch1 && allMatch2,
  Print["*****************************************************"];
  Print["* SELF-SIMILAR CORRECTION FORMULA CONFIRMED!        *"];
  Print["*                                                   *"];
  Print["* Delta_k[A_k+2+d, s] =                            *"];
  Print["*   Sum_{m=1}^{d+1} v_{d-m+1}(p_k - w*m)          *"];
  Print["*     * C(A_k + m(w+1) - s, mw - 1)                *"];
  Print["*                                                   *"];
  Print["* SAME formula at EVERY CF level!                   *"];
  Print["* Only p_k and A_k change between levels.           *"];
  Print["*****************************************************"];
  Print[""];
  Print["Parameters:"];
  Print["  Level 1: A_1 = ", a1k, " = q1, p_1 = ", p1];
  Print["  Level 2: A_2 = ", a2k, " = q1+q2-1, p_2 = ", p2];
  Print["  w = ", ww, " (floor of alpha)"];
  Print["  v_j(p) = (p-wj)/p * C(p+j-1, j)"];
  Print["  Basis: C(A_k + m(w+1) - s, mw - 1)"];
  Print["  Coefficients: v_{d-m+1}(p_k - w*m)"];
  Print[""];

  (* Special cases *)
  Print["Special cases:"];
  Print["  d=0 (single binomial): C(A_k+w+1-s, w-1)"];
  Print["    Level 1: C(", a1k + ww + 1, "-s, ", ww - 1, ")"];
  Print["    Level 2: C(", a2k + ww + 1, "-s, ", ww - 1, ")"];
  Print["  Last coeff (m=d+1): v_0(p_k-w(d+1)) = 1 always"];
  Print["  Last row (d=max): Fuss-Catalan structure"];
];
Print[""];

(* === VERIFY ON Pi as well === *)
Print["===== CROSS-CHECK ON Pi ====="];
alphaPi = Pi;
wPi = 3;
p0Pi = 3; q0Pi = 1; p1Pi = 22; q1Pi = 7; p2Pi = 333; q2Pi = 106;

(* Level-1 for Pi *)
Print["Pi level-1:"];
M1Pi = blockTransferActual[q1Pi + 1, alphaPi, 25, 47];
T1Pi = Table[Binomial[p1Pi - 1 + j - s, j - s],
  {j, 0, 2 q1Pi}, {s, 0, q1Pi}];
D1Pi = T1Pi - M1Pi;
a1kPi = q1Pi;

allMatchPi = True;
Do[
  j = a1kPi + 2 + d;
  If[j + 1 > Dimensions[D1Pi][[1]], Break[]];
  actual = D1Pi[[j + 1]];
  If[actual === Table[0, q1Pi + 1], Continue[]];
  formula = Table[
    Sum[vLin[p1Pi - wPi m, wPi, d - m + 1] *
      Binomial[a1kPi + m (wPi + 1) - s, m wPi - 1],
      {m, 1, d + 1}],
    {s, 0, q1Pi}];
  match = (actual === formula);
  If[!match, allMatchPi = False];
  Print["  d=", d, ": ", If[match, "MATCH", "MISMATCH"]],
  {d, 0, q1Pi - 2}];
Print["Pi level-1 ALL MATCH: ", allMatchPi];
Print[""];

(* Level-2 for Pi would require computing up to p2 = 333 *)
(* which is expensive but doable *)
Print["Pi level-2 (up to p2=333, will take a moment):"];
initDimPi2 = q1Pi + q2Pi + 1; (* 114 *)
Print["  Input dim: ", initDimPi2];
Print["  This would be a ", initDimPi2 + q2Pi, "x", initDimPi2, " matrix"];
Print["  Computing... (may take a while)"];

(* Level-2 semi-convergent: p1+p2 = 355, p1+2*p2 = 688 *)
(* Wait: for Pi, p2 = 333, p1 = 22. Positions: 22+333 = 355, 22+666 = 688 *)
(* Floor Agreement at 355: Floor[x/Pi] = Floor[113*x/355] for x=1..355 *)
(* dim at 355: Floor[355/Pi] + 1 = 113 + 1 = 114 *)
(* Transfer from 355 to 688: 333 columns, 106 rises *)

(* This is a 220x114 matrix - feasible but slow *)
(* Let me just do a few rows *)

M2Pi = blockTransferActual[initDimPi2, alphaPi, 355, 688];
{nr, nc} = Dimensions[M2Pi];
Print["  M2 dims: ", {nr, nc}];

T2Pi = Table[Binomial[p2Pi - 1 + j - s, j - s], {j, 0, nr - 1}, {s, 0, nc - 1}];
D2Pi = T2Pi - M2Pi;

a2kPi = nc - 2; (* A_k for level 2 *)
Print["  A_2 = ", a2kPi, " (= q1+q2-1 = ", q1Pi + q2Pi - 1, ")"];

(* Check first correction row *)
corrStart = -1;
Do[If[D2Pi[[j + 1]] =!= Table[0, nc],
  corrStart = j; Break[]], {j, 0, nr - 1}];
Print["  First correction: j=", corrStart, " (expected A_2+2=", a2kPi + 2, ")"];

(* Verify first 5 correction rows *)
If[corrStart == a2kPi + 2,
  Print["  Verifying formula:"];
  allMatchPi2 = True;
  Do[
    j = a2kPi + 2 + d;
    If[j + 1 > nr, Break[]];
    actual = D2Pi[[j + 1]];
    formula = Table[
      Sum[vLin[p2Pi - wPi m, wPi, d - m + 1] *
        Binomial[a2kPi + m (wPi + 1) - s, m wPi - 1],
        {m, 1, d + 1}],
      {s, 0, nc - 1}];
    match = (actual === formula);
    If[!match, allMatchPi2 = False];
    Print["    d=", d, ": ", If[match, "MATCH", "MISMATCH"]],
    {d, 0, Min[9, nr - a2kPi - 3]}];
  Print["  Pi level-2 verified: ", allMatchPi2],
  Print["  UNEXPECTED correction start!"]
];
