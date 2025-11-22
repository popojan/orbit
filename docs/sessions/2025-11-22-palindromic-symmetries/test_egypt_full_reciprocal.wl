#!/usr/bin/env wolframscript
(* Test full Egypt function with sqrt factor *)

Print["Testing full Egypt[k, x] reciprocal property...\n"];

<< Orbit`

(* Test reciprocal equation: Egypt[k, x] * Egypt[k, 1/x] = C ? *)
testEgyptReciprocal[x_, k_] := Module[{ex, e1x, product},
  ex = Egypt[k, x];
  e1x = Egypt[k, 1/x];
  product = ex * e1x;
  {x, N[ex, 10], N[e1x, 10], N[product, 10]}
];

Print["Testing Egypt[5, x] with sqrt factor:\n"];
Print["x\t\tEgypt(x)\t\tEgypt(1/x)\t\tProduct"];
Print[StringRepeat["-", 80]];

testValues = {2, 3, 5, 1/2, 1/3, 1/5};

results = Table[testEgyptReciprocal[x, 5], {x, testValues}];

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
  Print["✓ CONSTANT → Egypt[k,x] HAS reciprocal property"],
  Print["✗ NOT CONSTANT → Egypt[k,x] DOES NOT have reciprocal property"]
];
Print[];

(* Analyze the sqrt factor effect *)
Print["Analysis: Effect of sqrt factor\n"];
Print["Egypt[k,x] = sqrt(x) * Sum[FactorialTerm[x,j]]"];
Print["Egypt[k,1/x] = sqrt(1/x) * Sum[FactorialTerm[1/x,j]]"];
Print["Product = sqrt(x) * sqrt(1/x) * Sum * Sum = 1 * Sum * Sum"];
Print[];
Print["So sqrt cancels, but sum product is still not constant (as shown above).\n"];

Print["DONE!"];
