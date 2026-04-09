(* Investigate off-by-one: is it accumulated? Can we fix it? *)

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

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

(* State vector at 25/8 *)
v25 = Table[pathsRat[25, 8, j], {j, 0, 8}];
Print["v(25,8) = ", v25];
Print[""];

(* === Test: residuals are correction + v_{j-8}(25) === *)
Print["=== Verifying residual = correction + v_{j-8}(25) ==="];
Do[
  pp = 47;
  actual = pathsRat[47, 15, j];
  lin = vLin[47, 3, j];
  corr = actual - lin;
  twoLevel = lin - vLin[25, 3, j - 8];
  residual = actual - twoLevel;
  v25entry = v25[[j - 8 + 1]]; (* v_{j-8}(25) *)
  Print["j=", j, ": corr=", corr, " v_{j-8}(25)=", v25entry,
    " corr+v=", corr + v25entry, " residual=", residual,
    If[corr + v25entry === residual, " OK", " FAIL"]],
  {j, 8, 14}];
Print[""];

(* === Key test: does the residual at j=8 propagate through convolution? === *)
(* The recurrence is v_j^{(k+1)} = Sum C(j-s+2, 2) * v_s^{(k)} *)
(* If we have error eps at j=8 in step k, what error propagates to step k+1? *)
Print["=== Error propagation through convolution kernel ==="];
Print["Kernel: C(j-s+w-1, w-1) with w=3"];
Print[""];

(* If error of -1 at position j=8, propagation to j=8,9,...,14: *)
Print["Propagated error from -1 at j=8 through ONE stair+rise step:"];
Do[
  prop = -Binomial[j - 8 + 2, 2];
  Print["  j=", j, ": propagated error = ", prop],
  {j, 8, 14}];
Print[""];

(* === Residuals for multiple p values === *)
Print["=== Residuals (after subtracting vLin(25, j-8)) for p=47, 69, 91 ==="];
Do[
  Do[
    actual = pathsRat[pp, qq, j];
    twoLevel = vLin[pp, 3, j] - vLin[25, 3, j - 8];
    residual = actual - twoLevel;
    If[residual =!= 0,
      Print["  p=", pp, " j=", j, ": residual=", residual]],
    {j, 8, Min[14, qq]}],
  {pp, qq} , {{47, 15}, {69, 22}, {91, 29}}];
Print[""];

(* === Are the residuals polynomial in p? Same structure as original corrections? === *)
Print["=== Residuals as polynomial in p ==="];
positions = {{47, 15}, {69, 22}, {91, 29}, {113, 36}, {135, 43}};
Do[
  pts = {};
  Do[
    {pp, qq} = pq;
    actual = pathsRat[pp, qq, j];
    twoLevel = vLin[pp, 3, j] - vLin[25, 3, j - 8];
    residual = actual - twoLevel;
    AppendTo[pts, {pp, residual}],
    {pq, positions}];
  poly = InterpolatingPolynomial[pts, t] // Expand;
  deg = Exponent[poly, t];
  lead = Coefficient[poly, t, deg];
  Print["j=", j, ": deg=", deg, " lead=", lead, " poly=", Factor[poly]],
  {j, 8, 13}];
Print[""];

(* === Now the BIG question: can we iterate the decomposition? === *)
(* Level 0: vLin(p, 3, j) — exact for j=0..7 *)
(* Level 1: subtract vLin(25, 3, j-8) — residual constant (-420731) at j=8 *)
(* Level 2: subtract 420731 * vLin(??, 3, j-??) — reduce residual further? *)

(* First: is -420731 = -B(some_p, some_q)? *)
Print["=== Is 420731 a ballot number? ==="];
Do[
  b = Binomial[420731 + qq - 1, qq] / 420731;
  If[IntegerQ[b],
    Print["420731 could be B(420731, ", qq, ") = ", b]],
  {qq, 1, 20}];
Print[""];

(* 420731 = B(25,8) - 1 = 420732 - 1 *)
(* Try: is the residual sequence {-420731, ...} a state vector of a sub-problem? *)
Print["=== Residual sequence vs known state vectors ==="];
residuals47 = Table[
  pathsRat[47, 15, j] - (vLin[47, 3, j] - vLin[25, 3, j - 8]),
  {j, 8, 14}];
Print["Residuals for p=47: ", residuals47];
Print["Negated: ", -residuals47];
Print[""];

(* Compare with state vector of pathsRat(22, 7, j) *)
v22 = Table[pathsRat[22, 7, j], {j, 0, 7}];
Print["v(22,7) = ", v22];
Print[""];

(* Is -residuals47 related to v(22,7)? *)
(* residuals47 = {-420731, -11356146, -158554489, ...} *)
(* v(22,7) = {1, 19, 184, 1196, 5750, 20930, 53820, 53820} *)
(* Ratios? *)
ratios = MapThread[If[#2 =!= 0, #1/#2, "inf"] &, {-residuals47, v22}];
Print["(-residuals) / v(22): ", ratios];
Print[""];

(* === Try: v_j = vLin(p,j) - vLin(25, j-8) + vLin(22, j-8) - vLin(p, j)? NO *)
(* === Try: telescoping with ALL convergent state vectors === *)
(* v_j(47,15) = Σ (-1)^k * v_j(p_k, q_k) somehow? *)

(* For 47/15 = [3;7,2], convergents: 3/1, 22/7, 47/15 *)
(* Semi-conv: 25/8 *)
Print["=== Alternating convergent sum test ==="];
Print["v_j(47) =? v_j(47,lin) - v_{j-?}(25) + v_{j-??}(22) - v_{j-???}(3)"];
Print[""];

(* What if: v_j(p,q) = Sum over convergents/semi-conv with proper signs? *)
(* Let's just try every reasonable combination *)

(* Approach: v_j(47,15) = pathsRat(47,15,j) *)
(* Try: = vLin(47,3,j) - pathsRat(25,8,j-8) *)
(* But pathsRat(25,8,j-8) = vLin(25,3,j-8) for j-8 <= 8 *)
(* The issue: at j=8, pathsRat(25,8,0) = 1, but we need correction = -420732 *)

(* What if the subtracted term uses a DIFFERENT target height? *)
(* pathsRat(25, 8, 8) = 420732 = B(25,8) — this is the ballot number *)
(* What if we subtract pathsRat(25, 8, something_fixed) at every j? *)

(* Try: v_j(47,15) = vLin(47,3,j) - B(25,8) * f(j) where f is simple *)
Print["=== Testing v_j = vLin(47,j) - B(25,8) * f(j) ==="];
b25 = 420732;
Do[
  actual = pathsRat[47, 15, j];
  lin = vLin[47, 3, j];
  fj = (lin - actual) / b25;
  Print["  j=", j, " f(j)=", fj, If[IntegerQ[fj], " (integer)", ""]],
  {j, 8, 14}];
Print[""];

(* Try for p=69 *)
Print["=== Same for p=69 ==="];
Do[
  actual = pathsRat[69, 22, j];
  lin = vLin[69, 3, j];
  fj = (lin - actual) / b25;
  Print["  j=", j, " f(j)=", fj, If[IntegerQ[fj], " (integer)", ""]],
  {j, 8, 16}];
