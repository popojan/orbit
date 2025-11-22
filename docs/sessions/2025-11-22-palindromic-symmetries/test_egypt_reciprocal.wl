#!/usr/bin/env wolframscript
(* Quick test: Does Egypt satisfy reciprocal equation? *)

Print["Testing Egypt reciprocal property...\n"];

(* Egypt factorial term from Orbit paclet *)
<< Orbit`

(* Test Egypt sum for k terms *)
egyptSum[x_, k_] := Sum[FactorialTerm[x, j], {j, 1, k}];

(* Test reciprocal equation: E(x) * E(1/x) = C ? *)
testReciprocal[x_, k_] := Module[{ex, e1x, product},
  ex = egyptSum[x, k];
  e1x = egyptSum[1/x, k];
  product = ex * e1x;
  {x, N[ex, 10], N[e1x, 10], N[product, 10]}
];

Print["Testing Egypt sum (k=5 terms) at various x:\n"];
Print["x\t\tE(x)\t\t\tE(1/x)\t\t\tE(x)*E(1/x)"];
Print[StringRepeat["-", 80]];

testValues = {2, 3, 5, 1/2, 1/3, 1/5};

results = Table[testReciprocal[x, 5], {x, testValues}];

Do[
  {x, ex, e1x, prod} = results[[i]];
  Print[N[x, 4], "\t\t", ex, "\t", e1x, "\t", prod];
, {i, 1, Length[testValues]}];

Print[];

(* Check if product is constant *)
products = results[[All, 4]];
minProd = Min[products];
maxProd = Max[products];
range = maxProd - minProd;

Print["Product statistics:"];
Print["  Min: ", N[minProd, 10]];
Print["  Max: ", N[maxProd, 10]];
Print["  Range: ", N[range, 10]];
Print["  Relative variation: ", N[100*range/Mean[products], 4], "%"];
Print[];

If[range < 10^-8,
  Print["✓ CONSTANT within numerical precision → Egypt HAS reciprocity"],
  Print["✗ NOT CONSTANT → Egypt DOES NOT have reciprocal equation"]
];
Print[];

(* Also test individual FactorialTerm *)
Print["Testing individual FactorialTerm[x, j]:\n"];
Print["j\tx\tF(x)\t\t\tF(1/x)\t\t\tF(x)*F(1/x)"];
Print[StringRepeat["-", 80]];

Do[
  Do[
    fx = FactorialTerm[x, j];
    f1x = FactorialTerm[1/x, j];
    prod = fx * f1x;
    Print[j, "\t", N[x,3], "\t", N[fx,8], "\t", N[f1x,8], "\t", N[prod,10]];
  , {x, {2, 1/2}}];
, {j, 1, 5}];

Print["\nDONE!"];
