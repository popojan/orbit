#!/usr/bin/env wolframscript
(* Verify Dedekind cut inequalities *)

Print["Verifying Dedekind cut for sqrt(7/11)"]
Print["="*60]

val1 = 280/351;
val2 = 351/440;
sqrtVal = Sqrt[7/11];

Print["280/351 = ", N[val1, 20]]
Print["351/440 = ", N[val2, 20]]
Print["sqrt(7/11) = ", N[sqrtVal, 20]]

Print["\nOrdering:"]
Print["280/351 < 351/440? ", val1 < val2, " (", N[val1 - val2], ")"]
Print["351/440 < sqrt(7/11)? ", val2 < sqrtVal, " (", N[val2 - sqrtVal], ")"]
Print["280/351 < sqrt(7/11)? ", val1 < sqrtVal, " (", N[val1 - sqrtVal], ")"]

Print["\nCorrect ordering:"]
If[val1 < val2 < sqrtVal,
  Print["280/351 < 351/440 < sqrt(7/11) ✓"],
  Print["ERROR: Not in this order!"]
]

Print["\nSorted values:"]
sorted = Sort[{val1, val2, sqrtVal}];
Print["Smallest: ", N[sorted[[1]], 15]]
Print["Middle:   ", N[sorted[[2]], 15]]
Print["Largest:  ", N[sorted[[3]], 15]]
