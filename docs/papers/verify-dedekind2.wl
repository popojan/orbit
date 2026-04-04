#!/usr/bin/env wolframscript

Print["Manual verification of sqrt(7/11)"]
Print["="*60]

(* Calculate 7/11 first *)
fraction = 7/11;
Print["7/11 = ", N[fraction, 20]]

(* Then take square root *)
sqrtFraction = Sqrt[fraction];
Print["sqrt(7/11) = ", N[sqrtFraction, 20]]

(* Verify by squaring *)
Print["(sqrt(7/11))^2 = ", N[sqrtFraction^2, 20]]
Print["Should equal 7/11 = ", N[fraction, 20]]

Print["\nNow the pyramid ratios:"]
val1 = N[280/351, 20];
val2 = N[351/440, 20];
sqrtVal = N[Sqrt[7/11], 20];

Print["280/351 = ", val1]
Print["351/440 = ", val2]
Print["sqrt(7/11) = ", sqrtVal]

Print["\nDirect comparison:"]
Print["280/351 < 351/440? ", 280/351 < 351/440]
Print["280/351 < sqrt(7/11)? ", 280/351 < Sqrt[7/11]]
Print["351/440 < sqrt(7/11)? ", 351/440 < Sqrt[7/11]]

Print["\nWhat's the correct order?"]
values = {280/351, 351/440, Sqrt[7/11]};
names = {"280/351", "351/440", "sqrt(7/11)"};
sorted = Sort[Transpose[{values, names}]];
Do[Print[i, ". ", sorted[[i,2]], " = ", N[sorted[[i,1]], 15]], {i, 1, 3}]
