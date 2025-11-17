#!/usr/bin/env wolframscript
(*
Modular Analysis for n=61 (touchstone case)
*)

Print["=" * 70];
Print["MODULAR ANALYSIS: n=61 (TOUCHSTONE)"];
Print["=" * 70];
Print[];

(* Find Pell solution for n=61 *)
n = 61;
sol = Solve[x^2 - n*y^2 == 1 && x > 0 && y > 0 && x < 10^10, {x, y}, Integers];
{x, y} = {x, y} /. sol[[1]];

Print["Pell equation: x^2 - n*y^2 = 1"];
Print["n = ", n];
Print["x = ", x];
Print["y = ", y];
Print["Verify: x^2 - n*y^2 = ", x^2 - n*y^2];
Print[];

(* Modular reductions *)
Print["=" * 70];
Print["MODULAR REDUCTIONS (mod ", n, ")"];
Print["=" * 70];
Print[];

xMod = Mod[x, n];
yMod = Mod[y, n];

Print["x == ", xMod, " (mod ", n, ")"];
Print["y == ", yMod, " (mod ", n, ")"];
Print[];

Print["Key values:"];
Print["  x - 1 == ", Mod[x - 1, n], " (mod ", n, ")"];
Print["  x + 1 == ", Mod[x + 1, n], " (mod ", n, ")"];
Print["  2 + x == ", Mod[2 + x, n], " (mod ", n, ")"];
Print[];

Print["Check divisibility:"];
Print["  n | (x-1)? ", Divisible[x - 1, n]];
Print["  n | (x+1)? ", Divisible[x + 1, n]];
Print["  n | (2+x)? ", Divisible[2 + x, n]];
Print[];

(* Special cases *)
Which[
  Mod[x - 1, n] == 0,
    Print["SPECIAL: n | (x-1), so x == 1 (mod n)"],
  Mod[x + 1, n] == 0,
    Print["SPECIAL: n | (x+1), so x == -1 (mod n)"],
  True,
    Print["GENERIC: n does not divide (x-1) or (x+1)"]
];
Print[];

(* Pell consequences *)
Print["=" * 70];
Print["PELL EQUATION CONSEQUENCES"];
Print["=" * 70];
Print[];

Print["From x^2 - ny^2 = 1:"];
Print["  x^2 == 1 (mod n)"];
Print["Verify: x^2 == ", Mod[x^2, n], " (mod ", n, ")"];
Print[];

(* Component analysis *)
Print["=" * 70];
Print["COMPONENT ANALYSIS"];
Print["=" * 70];
Print[];

Print["(x-1)/y structure:"];
If[GCD[y, n] == 1,
  yInv = PowerMod[y, -1, n];
  Print["  y^(-1) == ", yInv, " (mod ", n, ")"];
  Print["  (x-1)/y == ", Mod[(x - 1) * yInv, n], " (mod ", n, ")"];
,
  Print["  WARNING: gcd(y,n) = ", GCD[y, n], " != 1"];
];
Print[];

Print["Pair sum numerator (2+x):"];
Print["  2 + x = ", 2 + x];
Print["  (2+x) == ", Mod[2 + x, n], " (mod ", n, ")"];
If[Mod[2 + x, n] == 1,
  Print["  OBSERVATION: (2+x) == 1 (mod n) [like n=13]"];
];
Print[];

Print["=" * 70];
Print["COMPARISON WITH n=13"];
Print["=" * 70];
Print[];
Print["n=13: x == -1 (mod n), (2+x) == 1 (mod n)"];
Print["n=61: x == ", xMod, " (mod n), (2+x) == ", Mod[2 + x, n], " (mod n)"];
Print[];
