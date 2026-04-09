(* Golden Ratio: find EXACT correction polynomials *)
(* GR = [1;1,1,...], w=1, q1=1 *)
(* Convergent positions: Fibonacci p = 2,3,5,8,13,21,34,55,89,144,233 *)
(* q = p - p_{prev}: 1,2,3,5,8,13,21,34,55,89,144 *)

pathsRational[p_, q_, j_] := Module[{S, dp},
  If[j == 0, Return[1]]; If[j < 0, Return[0]];
  S = Table[Min[Floor[q x/p], j], {x, 1, p}];
  If[j > S[[p]], Return[0]];
  dp = Table[0, {p}, {j + 1}];
  Do[Do[If[y <= S[[x]],
    dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
      If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
      If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[j, S[[x]]]}], {x, 1, p}];
  dp[[p, j + 1]]
]

vLinear[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]
Ballot[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

(* GR convergent positions *)
fibs = {2, 3, 5, 8, 13, 21, 34, 55, 89, 144};
fibQ = {1, 2, 3, 5, 8, 13, 21, 34, 55, 89};

(* Compute corrections at each position *)
Print["=== GR: Exact correction polynomials ==="];
Print[""];

(* Collect corrections indexed by j *)
maxJ = 8;
corrData = Table[{}, {maxJ + 1}]; (* corrData[[j+1]] = list of {p, corr_j} *)

Do[
  idx = i;
  p = fibs[[idx]]; q = fibQ[[idx]];
  Do[
    vj = pathsRational[p, q, j];
    lin = vLinear[p, 1, j];
    corr = vj - lin;
    AppendTo[corrData[[j + 1]], {p, corr}],
    {j, 0, Min[maxJ, q]}],
  {i, 1, Length[fibs]}];

(* Fit and display exact polynomials *)
Do[
  pts = corrData[[j + 1]];
  If[Length[pts] < 2, Continue[]];
  (* Remove zero-correction points *)
  nonzero = Select[pts, #[[2]] =!= 0 &];
  If[Length[nonzero] < 1, Print["j=", j, ": no correction"]; Continue[]];

  poly = InterpolatingPolynomial[pts, p];
  poly = Expand[poly];
  polyFactored = Factor[poly];

  Print["j=", j, ": corr(p) = ", polyFactored];

  (* Verify *)
  allOK = True;
  Do[If[poly /. p -> pt[[1]] =!= pt[[2]], allOK = False],
    {pt, pts}];
  If[!allOK, Print["  WARNING: polynomial doesn't match all points!"]];

  (* Check if it equals -B(3,2) * C(p-c, j-2) / (j-2)! for some c *)
  deg = Exponent[poly, p];
  If[deg >= 0,
    Print["  degree = ", deg, ", leading = ", Coefficient[poly, p, deg]]],
  {j, 0, maxJ}];

Print[""];

(* === Try to express in falling factorial basis C(p+a, d) === *)
Print["=== Corrections in binomial basis ==="];
Print[""];
Do[
  pts = corrData[[j + 1]];
  If[Length[pts] < 2 || AllTrue[pts, #[[2]] == 0 &], Continue[]];

  poly = InterpolatingPolynomial[pts, p] // Expand;
  deg = Exponent[poly, p];

  (* Express as sum of C(p+a, k) terms *)
  (* For degree d polynomial, try: corr = Σ c_k * C(p, k) *)
  If[deg <= 5,
    coeffsBinom = {};
    remainder = poly;
    Do[
      c = Coefficient[remainder, p, k] * k!;
      (* C(p, k) has leading term p^k/k! *)
      AppendTo[coeffsBinom, c];
      remainder = Expand[remainder - c/k! * Product[p - i, {i, 0, k - 1}]],
      {k, deg, 0, -1}];
    coeffsBinom = Reverse[coeffsBinom];
    Print["j=", j, ": corr = ", Sum[
      If[coeffsBinom[[k + 1]] =!= 0,
        ToString[coeffsBinom[[k + 1]]] <> "*C(p," <> ToString[k] <> ")", ""],
      {k, 0, deg}] // StringJoin];
    (* Verify *)
    reconstructed = Sum[coeffsBinom[[k + 1]] * Binomial[p, k], {k, 0, deg}] // Expand;
    If[reconstructed =!= poly,
      Print["  MISMATCH in binomial reconstruction!"],
      Print["  Verified."]];
    Print["  Coefficients in C(p,k) basis: ", coeffsBinom]],
  {j, 0, maxJ}];

Print[""];

(* === Now try shifted basis: corr = -2 * Σ a_k * C(p+1, k) === *)
(* or: corr = -B(3,2) * Σ a_k * C(p+c, k) for some universal c *)
Print["=== Try: corr_j = -2 * C(p+1, j-2) ? ==="];
Do[
  pts = corrData[[j + 1]];
  If[Length[pts] < 2 || AllTrue[pts, #[[2]] == 0 &], Continue[]];

  predicted = Table[{pt[[1]], -2 * Binomial[pt[[1]] + 1, j - 2]}, {pt, pts}];
  ok = AllTrue[MapThread[#1[[2]] === #2[[2]] &, {pts, predicted}], TrueQ];
  Print["j=", j, ": -2*C(p+1,", j - 2, ")? ", If[ok, "YES!", "no"]],
  {j, 2, 8}];
Print[""];

(* Try other shifts *)
Do[
  Print["--- Shift c=", c, " ---"];
  Do[
    pts = corrData[[j + 1]];
    If[Length[pts] < 2 || AllTrue[pts, #[[2]] == 0 &], Continue[]];
    predicted = Table[{pt[[1]], -2 * Binomial[pt[[1]] + c, j - 2]}, {pt, pts}];
    ok = AllTrue[MapThread[#1[[2]] === #2[[2]] &, {pts, predicted}], TrueQ];
    If[ok, Print["j=", j, ": -2*C(p+", c, ",", j - 2, ") MATCH!"]],
    {j, 2, 8}],
  {c, -3, 3}];
Print[""];

(* === Most general: corr_j = α * C(p+β, j-2) for some α, β === *)
Print["=== Testing corr_j = alpha * C(p + beta, j-2) ==="];
Do[
  pts = Select[corrData[[j + 1]], #[[2]] =!= 0 &];
  If[Length[pts] < 2, Continue[]];
  (* Use first two points to solve for alpha, beta *)
  {p1, c1} = pts[[1]];
  {p2, c2} = pts[[2]];
  d = j - 2;
  (* c1 = alpha * C(p1+beta, d), c2 = alpha * C(p2+beta, d) *)
  (* ratio c1/c2 = C(p1+beta, d) / C(p2+beta, d) *)
  ratio = c1/c2;
  (* Try integer beta from -5 to 5 *)
  Do[
    predRatio = Binomial[p1 + b, d] / Binomial[p2 + b, d];
    If[predRatio === ratio,
      alpha = c1 / Binomial[p1 + b, d];
      (* Verify remaining points *)
      ok = AllTrue[Drop[pts, 2],
        #[[2]] === alpha * Binomial[#[[1]] + b, d] &];
      If[ok,
        Print["j=", j, ": corr = ", alpha, " * C(p+", b, ", ", d, ")"]]],
    {b, -10, 10}],
  {j, 2, 8}];
