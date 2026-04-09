(* GR exact correction polynomials — fixed variable scoping *)

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

(* GR Fibonacci positions *)
fibP = {5, 8, 13, 21, 34, 55, 89, 144};
fibQ = {3, 5, 8, 13, 21, 34, 55, 89};

(* Collect {position, correction} for each j *)
maxJ = 8;
corrTab = Table[
  Table[
    Module[{pp = fibP[[i]], qq = fibQ[[i]], vj, lin},
      If[j > qq, Nothing,
        vj = pathsRat[pp, qq, j];
        lin = vLin[pp, 1, j];
        {pp, vj - lin}]],
    {i, 1, Length[fibP]}] // Flatten[#, 0] &,
  {j, 0, maxJ}];

Print["=== GR correction data ==="];
Do[
  pts = corrTab[[j + 1]];
  If[Length[pts] > 0 && !AllTrue[pts, #[[2]] == 0 &],
    Print["j=", j, ": ", pts]],
  {j, 0, maxJ}];
Print[""];

(* Fit polynomials using symbol t *)
Print["=== Exact polynomials in variable t ==="];
Do[
  pts = Select[corrTab[[j + 1]], #[[2]] =!= 0 &];
  If[Length[pts] < 1, Continue[]];

  poly = InterpolatingPolynomial[pts, t] // Expand;
  factored = Factor[poly];
  deg = Exponent[poly, t];

  Print["j=", j, ": degree ", deg];
  Print["  corr(t) = ", factored];

  (* Verify on all data points *)
  allPts = corrTab[[j + 1]];
  ok = AllTrue[allPts, (poly /. t -> #[[1]]) === #[[2]] &];
  If[!ok, Print["  WARNING: not all points match!"]];
  Print[""],
  {j, 2, maxJ}];

(* === Test: corr_j = -2 * C(t+c, j-2) for various c === *)
Print["=== Testing corr_j = alpha * C(t + beta, j - 2) ==="];
Do[
  pts = Select[corrTab[[j + 1]], #[[2]] =!= 0 &];
  If[Length[pts] < 2, Continue[]];
  d = j - 2;
  found = False;
  Do[
    alpha = pts[[1, 2]] / Binomial[pts[[1, 1]] + beta, d];
    If[!IntegerQ[alpha] && !Head[alpha] === Rational, Continue[]];
    ok = AllTrue[pts, #[[2]] === alpha * Binomial[#[[1]] + beta, d] &];
    If[ok,
      Print["j=", j, ": corr = ", alpha, " * C(t", If[beta >= 0, "+", ""],
        beta, ", ", d, ")"];
      found = True; Break[]],
    {beta, -20, 20}];
  If[!found, Print["j=", j, ": no single C(t+beta, d) form found"]],
  {j, 2, maxJ}];
Print[""];

(* === Alternative: try corr_j = alpha * C(t+beta, d) + gamma * C(t+delta, d-1) + ... *)
(* i.e., express in the basis {C(t+c, 0), C(t+c, 1), ...} for some fixed c *)
Print["=== Expressing in C(t-3, k) basis (c = -3 = -p1-q1 = -2-1) ==="];
Do[
  pts = Select[corrTab[[j + 1]], #[[2]] =!= 0 &];
  If[Length[pts] < 1, Continue[]];
  poly = InterpolatingPolynomial[pts, t] // Expand;
  deg = Exponent[poly, t];

  (* Convert to C(t-3, k) basis *)
  c = -3;
  coeffs = {};
  remainder = poly;
  Do[
    (* Extract coefficient of C(t+c, k) = (t+c)(t+c-1)...(t+c-k+1)/k! *)
    binPoly = Binomial[t + c, k] // FunctionExpand // Expand;
    coeff = Coefficient[remainder, t, k] * k! / Coefficient[binPoly, t, k] // Simplify;
    (* Actually, just use: coeff for degree k is remainder's leading / binomial's leading *)
    If[k > deg, AppendTo[coeffs, 0]; Continue[]];
    lead = Coefficient[remainder, t, k];
    binLead = 1/k!; (* leading coefficient of C(t+c, k) is 1/k! *)
    coeff = lead / binLead;
    remainder = Expand[remainder - coeff * Binomial[t + c, k]];
    AppendTo[coeffs, coeff],
    {k, deg, 0, -1}];
  coeffs = Reverse[coeffs];

  (* Verify *)
  reconstructed = Sum[coeffs[[k + 1]] * Binomial[t + c, k], {k, 0, deg}] // Expand;
  If[reconstructed === poly,
    Print["j=", j, ": coeffs in C(t-3, k): ", coeffs],
    Print["j=", j, ": MISMATCH! coeffs=", coeffs]],
  {j, 2, maxJ}];
Print[""];

(* === Try another basis: C(t-2, k) where 2 = p1 for GR === *)
Print["=== Expressing in C(t-2, k) basis (shift by p1=2) ==="];
Do[
  pts = Select[corrTab[[j + 1]], #[[2]] =!= 0 &];
  If[Length[pts] < 1, Continue[]];
  poly = InterpolatingPolynomial[pts, t] // Expand;
  deg = Exponent[poly, t];

  c = -2;
  coeffs = {};
  remainder = poly;
  Do[
    If[k > deg, AppendTo[coeffs, 0]; Continue[]];
    lead = Coefficient[remainder, t, k];
    coeff = lead * k!;
    remainder = Expand[remainder - coeff * Binomial[t + c, k]];
    AppendTo[coeffs, coeff],
    {k, deg, 0, -1}];
  coeffs = Reverse[coeffs];
  reconstructed = Sum[coeffs[[k + 1]] * Binomial[t + c, k], {k, 0, deg}] // Expand;
  If[reconstructed === poly,
    Print["j=", j, ": coeffs in C(t-2, k): ", coeffs],
    Print["j=", j, ": MISMATCH"]],
  {j, 2, maxJ}];
