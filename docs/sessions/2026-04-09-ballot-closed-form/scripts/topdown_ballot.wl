(* TOP-DOWN: Express corrections via ballot numbers *)
(* At convergent p2/q2, corrections encode FULL CF structure *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

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

ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* === Corrections at convergent p2 = 38 === *)
Print["===== CORRECTIONS AT CONVERGENT p2=38, q2=17 ====="];
Print["CF of 38/17 = [2; 4, 4]"];
Print[""];

v38 = Table[pathsRat[p2, q2, j], {j, 0, q2}];
vlin38 = Table[vLin[p2, ww, j], {j, 0, q2}];
delta38 = v38 - vlin38;

Print["Corrections delta_j(38):"];
Do[If[delta38[[j + 1]] =!= 0,
  Print["  j=", j, ": delta=", delta38[[j + 1]]]],
  {j, 0, q2}];
Print[""];

(* === Verify last-row identity === *)
Print["Last row: v_17(38) = ", v38[[18]], " = B(38,17) = ", B[38, 17]];
Print["v_17^lin(38) = ", vlin38[[18]]];
Print["Correction = ", delta38[[18]], " = -(a2-1)*B(38,17) = ", -(4 - 1) B[38, 17]];
Print["Match: ", delta38[[18]] === -(4 - 1) B[38, 17]];
Print[""];

(* === Key ballot numbers === *)
Print["Key ballot numbers:"];
Print["  B(p0+p1, q0+q1) = B(11, 5) = ", B[11, 5]];
Print["  B(p0+2p1, q0+2q1) = B(20, 9) = ", B[20, 9]];
Print["  B(p0+3p1, q0+3q1) = B(29, 13) = ", B[29, 13]];
Print["  B(p2, q2) = B(38, 17) = ", B[38, 17]];
Print["  B(p1, q1) = B(9, 4) = ", B[9, 4]];
Print[""];

(* === Express corrections as ratios of B(11,5) === *)
Print["Corrections / B(11,5) = ", B[11, 5], ":"];
Do[
  d = delta38[[j + 1]];
  If[d =!= 0,
    ratio = d / B[11, 5];
    Print["  j=", j, ": delta/B' = ", ratio,
      If[IntegerQ[ratio], " (integer!)", " (non-integer)"]]],
  {j, 0, q2}];
Print[""];

(* === Try: delta_j as ballot numbers at shifted positions === *)
(* Hypothesis: delta_j(p2) = -Sum_k c_k * B(p_shifted, q_shifted) *)
Print["=== Trying ballot decomposition ==="];
Print[""];

(* First, the SIMPLE corrections (j = q1+1,...,q1+q1): *)
(* These should be given by our Result 8 formula evaluated at p2 *)
Print["Result 8 prediction at p2=38 (shifted positions p2-wm):"];
A2 = q1 + q2 - 1; (* 20 *)
Do[
  d = j - q1 - 1; (* correction depth *)
  If[d < 0 || d >= q1, Continue[]];
  formula = Sum[
    vLin[p2 - ww m, ww, d - m + 1] *
    Binomial[A2 + m (ww + 1), m ww - 1], (* s=0 column *)
    {m, 1, d + 1}];
  (* Multiply by (p2 - ww(d+1)) to get the ballot-factored form *)
  factor = p2 - ww (d + 1);
  phiVal = If[factor != 0, formula / factor, "undef"];
  Print["  j=", j, " d=", d, ": formula=", formula,
    " actual=", -delta38[[j + 1]], " match=", formula === -delta38[[j + 1]]],
  {j, q1 + 1, 2 q1 + 1}];
Print[""];

(* === PARALLEL BOUNDARIES === *)
(* Key idea: paths below Floor[qx/p] at height j *)
(* = paths below Floor[(q-k)x/p] at height j-k (shifted boundary) *)
(* *)
(* So delta_j(p) = paths_under_staircase(j) - paths_under_line(j) *)
(* The "staircase" differs from the "line" at specific heights *)
(* The FIRST difference occurs at height q1+1, where the Sturmian *)
(* word creates the anomalous stair *)

Print["=== PARALLEL BOUNDARY ANALYSIS ==="];
Print["Paths below Floor[q*x/p] for various q (parallel boundaries):"];
Print["p=38, original q=17:");
Do[
  q = 17 - k;
  If[q <= 0, Break[]];
  v = Table[pathsRat[38, q, j], {j, 0, q}];
  vl = Table[vLin[38, ww, j], {j, 0, q}];
  dlt = v - vl;
  first = FirstPosition[dlt, x_ /; x =!= 0];
  Print["  q=", q, " (shift k=", k, "): first_corr at j=",
    If[first === Missing["NotFound"], "none", first[[1]] - 1],
    " last=", Last[v], "=B(38,", q, ")=", B[38, q],
    " match=", Last[v] === B[38, q]],
  {k, 0, 6}];
Print[""];

(* === The REAL top-down insight: corrections at SEMI-CONVERGENT positions === *)
Print["=== Corrections across semi-convergent positions ==="];
Print["For fixed j, delta_j(p) as function of p = p0+k*p1:"];
Print[""];

Do[
  Print["j=", j, ":"];
  vals = {};
  Do[
    p = p0 + k p1; q = q0 + k q1;
    If[j > q, Continue[]];
    vActual = pathsRat[p, q, j];
    vUnif = vLin[p, ww, j];
    d = vActual - vUnif;
    AppendTo[vals, {k, p, d}];
    Print["  k=", k, " p=", p, ": delta=", d],
    {k, 1, 5}];

  (* Fit polynomial in p *)
  If[Length[vals] >= 2 && vals[[1, 3]] =!= 0,
    pts = {#[[2]], #[[3]]} & /@ vals;
    deg = j - q1 - 1; (* expected degree *)
    If[deg >= 0 && deg + 1 <= Length[pts],
      poly = InterpolatingPolynomial[pts[[1 ;; deg + 1]], pp];
      poly = Expand[poly];
      Print["  Polynomial (deg ", deg, "): ", poly];
      (* Verify on remaining points *)
      Do[
        {kk, pp2, dd} = vals[[i]];
        pred = poly /. pp -> pp2;
        If[pred =!= dd, Print["  VERIFY k=", kk, ": MISMATCH ", pred, " vs ", dd]],
        {i, deg + 2, Length[vals]}]]],
  {j, q1 + 1, q1 + 5}];
Print[""];

(* === Can the polynomials be expressed via ballot numbers? === *)
Print["=== Polynomial coefficients in ballot basis ==="];
Print[""];

(* For j=q1+1=5: constant = -B(11,5) = -273 *)
Print["j=5 (d=0): constant = ", pathsRat[p0 + 2 p1, q0 + 2 q1, 5] - vLin[p0 + 2 p1, ww, 5]];
Print["  = -B(11,5) = ", -B[11, 5]];
Print[""];

(* For j=6 (d=1): linear a*p + b *)
(* From k=2 (p=20) and k=3 (p=29): *)
d6k2 = pathsRat[20, 9, 6] - vLin[20, ww, 6];
d6k3 = pathsRat[29, 13, 6] - vLin[29, ww, 6];
Print["j=6 (d=1): at p=20: ", d6k2, "  at p=29: ", d6k3];
(* Linear: a*20 + b = d6k2, a*29 + b = d6k3 *)
aCoeff = (d6k3 - d6k2)/9;
bCoeff = d6k2 - 20 aCoeff;
Print["  Linear fit: ", aCoeff, "*p + ", bCoeff];
Print["  Leading coeff: ", aCoeff, " = -B(11,5)/1! = ", -B[11, 5]];
Print["  Constant: ", bCoeff];
(* Is the constant related to ballot numbers? *)
Print["  bCoeff / B(11,5) = ", bCoeff / B[11, 5]];
Print["  bCoeff / B(9,4) = ", bCoeff / B[9, 4]];
Print[""];

(* For j=7 (d=2): quadratic *)
d7k2 = pathsRat[20, 9, 7] - vLin[20, ww, 7];
d7k3 = pathsRat[29, 13, 7] - vLin[29, ww, 7];
d7k4 = pathsRat[38, 17, 7] - vLin[38, ww, 7];
Print["j=7 (d=2): at p=20: ", d7k2, "  p=29: ", d7k3, "  p=38: ", d7k4];
poly7 = InterpolatingPolynomial[{{20, d7k2}, {29, d7k3}, {38, d7k4}}, pp];
poly7 = Expand[poly7];
Print["  Quadratic: ", poly7];
Print["  Leading: ", Coefficient[poly7, pp, 2], " = -B'/2! = ", -B[11, 5]/2];
Print[""];

(* === Systematic: polynomial coefficients for all j === *)
Print["=== ALL polynomial coefficients ==="];
Do[
  j = jj;
  d = j - q1 - 1;
  If[d < 0, Continue[]];
  pts = {};
  Do[
    p = p0 + k p1; q = q0 + k q1;
    If[j > q, Continue[]];
    vA = pathsRat[p, q, j]; vU = vLin[p, ww, j];
    AppendTo[pts, {p, vA - vU}],
    {k, 2, 6}];
  If[Length[pts] >= d + 1,
    poly = InterpolatingPolynomial[pts[[1 ;; d + 1]], pp];
    poly = Expand[poly];
    coeffs = Table[Coefficient[poly, pp, i], {i, d, 0, -1}];
    Print["j=", j, " d=", d, ": coeffs=", coeffs,
      "  leading/(-B'/d!)=", coeffs[[1]] / (-B[11, 5]/d!)];
    (* Verify *)
    Do[{p, dd} = pts[[i]]; pred = poly /. pp -> p;
      If[pred =!= dd, Print["  FAIL at p=", p]], {i, d + 2, Length[pts]}]],
  {jj, q1 + 1, q1 + 8}];
