(* LEVEL-2 RESIDUAL ANALYSIS *)
(* The simple formula works for d=0..q1-1. What's the correction for d >= q1? *)
(* Hypothesis: coefficients should use v^{full}_j(p) instead of v_j(p) *)

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

alpha = Sqrt[5];
ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* Compute actual M2 *)
initDim2 = q1 + q2 + 1;
M2 = blockTransferActual[initDim2, alpha, 47, 85];
{nrows2, ncols2} = Dimensions[M2];
T2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, nrows2 - 1}, {s, 0, ncols2 - 1}];
D2 = T2 - M2;
a2k = ncols2 - 2; (* 20 *)

(* Simple formula *)
simpleFormula[d_, s_] := Sum[
  vLin[p2 - ww m, ww, d - m + 1] *
    Binomial[a2k + m (ww + 1) - s, m ww - 1],
  {m, 1, d + 1}]

(* === Compute residuals for d >= q1 === *)
Print["=== RESIDUAL ANALYSIS (d >= q1 = ", q1, ") ==="];
Print[""];

residuals = {};
Do[
  j = a2k + 2 + d;
  If[j + 1 > nrows2, Break[]];
  actual = D2[[j + 1]];
  formula = Table[simpleFormula[d, s], {s, 0, ncols2 - 1}];
  resid = actual - formula;
  AppendTo[residuals, {d, resid}];
  If[d >= q1 && d <= q1 + 4,
    Print["d=", d, ": residual[0..5] = ", resid[[1 ;; Min[6, ncols2]]]]],
  {d, 0, nrows2 - a2k - 3}];
Print[""];

(* === KEY HYPOTHESIS: coefficients should use v^{full} instead of v_lin === *)
(* v^{full}_j(p) = v_j(p) for j <= q1                                     *)
(* v^{full}_j(p) = v_j(p) - level-1 correction for j > q1                 *)
(* The level-1 correction at height j = q1+1+d' is:                         *)
(*   delta1(j, p) = Sum_{m} ... with p1 parameters                         *)

(* For a specific rational p/q, v^{full}_j(p) = pathsRat[p, q, j] *)
(* The shifted positions are p2-wm, and their q-values are... *)
(* p2-wm = 36,34,32,30,28,... What are the corresponding q-values? *)
(* For semi-convergent of sqrt(5), p/q has q = (p-p0*?)/p1*? ... *)
(* Actually: these shifted positions might not be semi-convergents! *)

(* Let me try: use the EXACT DP value at shifted positions *)
Print["=== TESTING: v^{exact}_j(p) as coefficients ==="];
Print["Shifted positions and their q-values (from Floor[p/alpha]):"];
Do[
  pm = p2 - ww m;
  qm = Floor[pm/alpha];
  Print["  m=", m, ": p=", pm, " q=Floor[", pm, "/sqrt(5)]=", qm,
    " p/q=", pm, "/", qm, " = ", N[pm/qm, 5]],
  {m, 1, 8}];
Print[""];

(* Compute the EXACT state vector at each shifted position *)
(* v^{exact}_j(pm) = pathsRat[pm, qm, j] *)
Print["Testing exact coefficients:"];

(* For d=q1=4: formula uses c_{4,m} = v_{4-m+1}(p2-wm) for m=1..5 *)
(* Replace v_j(p) with pathsRat[p, Floor[p/alpha], j] *)
Do[
  j = a2k + 2 + d;
  If[j + 1 > nrows2 || d > q1 + 3, Break[]];
  actual = D2[[j + 1]];

  (* Compute with EXACT coefficients *)
  formulaExact = Table[
    Sum[Module[{pm = p2 - ww m, qm, coeff},
      qm = Floor[pm/alpha];
      coeff = pathsRat[pm, qm, d - m + 1];
      coeff * Binomial[a2k + m (ww + 1) - s, m ww - 1]],
      {m, 1, d + 1}],
    {s, 0, ncols2 - 1}];

  matchExact = (actual === formulaExact);
  Print["d=", d, ": exact coefficients ", If[matchExact, "MATCH", "MISMATCH"]];
  If[!matchExact && d <= q1 + 2,
    Print["  diff[0..3]: ", (actual - formulaExact)[[1 ;; Min[4, ncols2]]]]],
  {d, q1, q1 + 8}];
Print[""];

(* === Alternative: exact coefficients from level-1 corrected formula === *)
(* Instead of DP, use the ANALYTICAL level-1 corrected formula *)
(* v^{(1)}_j(p) = v_j(p) - Sum_{m1} ... (level-1 correction at position p) *)

Print["=== Testing level-1 corrected coefficients ==="];

(* Level-1 corrected state vector entry *)
(* For position p with CF tail determining the correction *)
(* At level 1: correction at j = q1+1+d' is *)
(*   delta = Sum_m v_{d'-m+1}(p1-wm) * C(...) where ... involves the state vector index *)
(* But this is the BLOCK TRANSFER correction, not the state vector correction *)

(* Actually, the state vector correction at a semi-convergent position p *)
(* comes from the block transfer corrections accumulated over multiple blocks *)
(* For the shifted positions p2-wm, these are NOT semi-convergent positions *)
(* so the correction structure is different *)

(* Let me try a different approach: express the residual as a linear combination *)
(* of the existing basis functions *)

Print["=== Decomposing residual into level-1 correction basis ==="];

(* The residual at d=q1 should be expressible as: *)
(* resid[s] = Sum_{m2} c'_{m2} * basis2_{m2}(s) *)
(* where basis2 are the SAME binomial basis functions C(a2k+m(w+1)-s, mw-1) *)

(* OR: the residual might use a DIFFERENT set of basis functions *)
(* related to the level-1 correction *)

(* Level-1 block transfer basis: C(a1+m(w+1)-s, mw-1) = C(4+3m-s, 2m-1) *)
(* But these have small arguments compared to level-2 *)

(* Let me just try: is the residual at d=q1 a single binomial? *)
Do[
  d = q1 + d2;
  If[d >= Length[residuals], Break[]];
  resid = residuals[[d + 1]][[2]];
  If[resid === Table[0, ncols2], Continue[]];

  (* Try C(A-s, B) fit *)
  found = False;
  Do[
    test = Table[Binomial[a - s, b], {s, 0, ncols2 - 1}];
    If[test === resid, Print["d=", d, " d2=", d2, ": resid = C(", a, "-s, ", b, ")"];
      found = True; Break[]],
    {b, 1, 30}, {a, b + ncols2 - 1, 100}];
  If[!found,
    (* Try scalar multiple *)
    Do[
      test = Table[Binomial[a - s, b], {s, 0, ncols2 - 1}];
      If[test[[1]] =!= 0,
        ratio = resid[[1]] / test[[1]];
        If[IntegerQ[ratio] && ratio test === resid,
          Print["d=", d, " d2=", d2, ": resid = ", ratio, " * C(", a, "-s, ", b, ")"];
          found = True; Break[]]],
      {b, 1, 30}, {a, b + ncols2 - 1, 100}]];
  If[!found,
    Print["d=", d, " d2=", d2, ": no simple binomial fit for residual"];
    (* Try the SAME basis decomposition for the residual *)
    (* Solve: resid = Sum c_m * C(a2k+m(w+1)-s, mw-1) *)
    nBasis = Min[d + 1, 6];
    basisMat = Table[Binomial[a2k + m (ww + 1) - s, m ww - 1],
      {s, 0, nBasis - 1}, {m, 1, nBasis}];
    rhs = resid[[1 ;; nBasis]];
    sol = Quiet[LinearSolve[basisMat, rhs]];
    If[Head[sol] =!= LinearSolve,
      pred = Sum[sol[[m]] Table[Binomial[a2k + m (ww + 1) - s, m ww - 1],
        {s, 0, ncols2 - 1}], {m, 1, nBasis}];
      If[pred === resid,
        Print["  SAME BASIS! Residual coeffs: ", sol],
        Print["  Same-basis fit failed"]]
    ]
  ],
  {d2, 0, Min[5, Length[residuals] - q1 - 1]}];
Print[""];

(* === Let's look at what v^{exact} vs v_lin gives === *)
Print["=== Comparing v_exact vs v_lin at shifted positions ==="];
Do[
  pm = p2 - ww m;
  qm = Floor[pm/alpha];
  Print["m=", m, " p=", pm, " q=", qm, ":"];
  Do[
    vex = pathsRat[pm, qm, j];
    vli = vLin[pm, ww, j];
    If[vex =!= vli,
      Print["  j=", j, ": v_exact=", vex, " v_lin=", vli, " diff=", vex - vli]],
    {j, 0, Min[q1 + 3, qm]}],
  {m, 1, Min[5, p2/(2 ww)]}];
