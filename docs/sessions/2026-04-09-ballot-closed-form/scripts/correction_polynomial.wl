(* Test if corrections for j > q1 are polynomial in p *)
(* Hypothesis: correction at j = q1 + k has degree k in p *)

Needs["Orbit`"];

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLinear[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]

stateVectors[alpha_, xMax_] := Module[
  {v = {1}, m = 0, prevS = 0, curS, results = <||>},
  results[1] = {0, {1}};
  Do[curS = Floor[x/alpha];
    If[curS == prevS, v = Lmat[m] . v,
      v = Lmat[m + 1] . Append[v, 0]; m++];
    prevS = curS; results[x] = {m, v}, {x, 2, xMax}];
  results
]

(* === Pi: compute corrections at many level-2 positions === *)
Print["=== Pi: Polynomial structure of corrections ==="];
Print[""];
data = stateVectors[Pi, 350];

(* Level-2 semi-convergent numerators for Pi: 25, 47, 69, ..., 311, 333 *)
level2Pos = Table[3 + 22 j, {j, 1, 15}]; (* 25,47,...,333 *)

w = 3; q1 = 7;

(* Collect corrections for each j, across positions *)
Print["j | degree | leading coeff | fits polynomial?"];
Print["----|--------|---------------|---"];
Do[
  (* Collect (p, correction) pairs where j is in range *)
  pairs = {};
  Do[
    If[KeyExistsQ[data, p],
      {m, v} = data[p];
      If[j < Length[v],
        corr = v[[j + 1]] - vLinear[p, w, j];
        AppendTo[pairs, {p, corr}]]],
    {p, level2Pos}];

  If[Length[pairs] < 3, Continue[]];

  (* Try to fit polynomial of increasing degree *)
  pts = pairs;
  n = Length[pts];
  fitted = False;
  Do[
    If[deg >= n, Break[]];
    (* Fit degree-deg polynomial through first deg+1 points *)
    poly = InterpolatingPolynomial[Take[pts, deg + 1], x];
    poly = Expand[poly];
    (* Check if it predicts remaining points *)
    allOK = True;
    Do[
      predicted = poly /. x -> pts[[i, 1]];
      If[predicted =!= pts[[i, 2]], allOK = False; Break[]],
      {i, deg + 2, n}];
    If[allOK,
      lead = Coefficient[poly, x, deg];
      Print["j=", j, " | deg ", deg, " | lead=", lead,
        " | YES (", n, " points)"];
      fitted = True; Break[]],
    {deg, 0, Min[8, n - 2]}];

  If[!fitted, Print["j=", j, " | >8 | --- | NO FIT"]],
  {j, q1, q1 + 12}];

Print[""];

(* === Extract the polynomial coefficients explicitly === *)
Print["=== Explicit polynomial fits for Pi corrections ==="];
Print[""];
Do[
  pairs = {};
  Do[
    If[KeyExistsQ[data, p],
      {m, v} = data[p];
      If[j < Length[v],
        corr = v[[j + 1]] - vLinear[p, w, j];
        AppendTo[pairs, {p, corr}]]],
    {p, level2Pos}];
  If[Length[pairs] < 2, Continue[]];

  poly = InterpolatingPolynomial[pairs, p];
  poly = Expand[poly];
  Print["j=", j, ": corr(p) = ", poly];

  (* Show the factored form if possible *)
  factored = Factor[poly];
  If[factored =!= poly, Print["  Factored: ", factored]],
  {j, q1 + 1, q1 + 5}];

Print[""];

(* === Same analysis for Sqrt[5] === *)
Print["=== Sqrt[5]: Polynomial structure ==="];
data5 = stateVectors[Sqrt[5], 200];
w5 = 2; q1s5 = 4;
(* Level-2 semi-conv for Sqrt[5]: (2+9j)/(1+4j) for j=1,...,7 *)
(* Numerators: 11, 20, 29, 38, 47, 56, 65, 74, 83 *)
level2S5 = Table[2 + 9 j, {j, 1, 9}];

Print["j | degree | leading coeff"];
Do[
  pairs = {};
  Do[
    If[KeyExistsQ[data5, p],
      {m, v} = data5[p];
      If[j < Length[v],
        corr = v[[j + 1]] - vLinear[p, w5, j];
        AppendTo[pairs, {p, corr}]]],
    {p, level2S5}];
  If[Length[pairs] < 3, Continue[]];

  pts = pairs;
  n = Length[pts];
  fitted = False;
  Do[
    If[deg >= n, Break[]];
    poly = InterpolatingPolynomial[Take[pts, deg + 1], x];
    poly = Expand[poly];
    allOK = True;
    Do[
      predicted = poly /. x -> pts[[i, 1]];
      If[predicted =!= pts[[i, 2]], allOK = False; Break[]],
      {i, deg + 2, n}];
    If[allOK,
      lead = Coefficient[poly, x, deg];
      Print["j=", j, " | deg ", deg, " | lead=", lead];
      fitted = True; Break[]],
    {deg, 0, Min[8, n - 2]}];
  If[!fitted, Print["j=", j, " | >8 | NO FIT"]],
  {j, q1s5, q1s5 + 12}];

Print[""];

(* === GoldenRatio polynomial structure === *)
Print["=== GoldenRatio: Polynomial structure ==="];
dataGR = stateVectors[GoldenRatio, 200];
wGR = 1; q1GR = 1;
(* Convergent numerators: Fibonacci *)
levelGR = {5, 8, 13, 21, 34, 55, 89, 144};

Print["j | degree | leading coeff"];
Do[
  pairs = {};
  Do[
    If[KeyExistsQ[dataGR, p],
      {m, v} = dataGR[p];
      If[j < Length[v],
        corr = v[[j + 1]] - vLinear[p, wGR, j];
        AppendTo[pairs, {p, corr}]]],
    {p, levelGR}];
  If[Length[pairs] < 3, Continue[]];

  pts = pairs;
  n = Length[pts];
  fitted = False;
  Do[
    If[deg >= n, Break[]];
    poly = InterpolatingPolynomial[Take[pts, deg + 1], x];
    poly = Expand[poly];
    allOK = True;
    Do[
      predicted = poly /. x -> pts[[i, 1]];
      If[predicted =!= pts[[i, 2]], allOK = False; Break[]],
      {i, deg + 2, n}];
    If[allOK,
      lead = Coefficient[poly, x, deg];
      Print["j=", j, " | deg ", deg, " | lead=", lead];
      fitted = True; Break[]],
    {deg, 0, Min[8, n - 2]}];
  If[!fitted, Print["j=", j, " | >8 | NO FIT"]],
  {j, q1GR, q1GR + 10}];
