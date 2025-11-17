#!/usr/bin/env wolframscript
(*
Modular Analysis for Egypt.wl k=EVEN Pattern
Starting with n=13 case study
*)

Print["=" * 70];
Print["MODULAR ANALYSIS: n=13 CASE STUDY"];
Print["=" * 70];
Print[];

(* Pell solution for n=13 *)
n = 13;
x = 649;
y = 180;

Print["Pell equation: x² - n·y² = 1"];
Print["n = ", n];
Print["x = ", x];
Print["y = ", y];
Print["Verify: x² - n·y² = ", x^2 - n*y^2];
Print[];

(* Modular reductions *)
Print["=" * 70];
Print["MODULAR REDUCTIONS (mod ", n, ")"];
Print["=" * 70];
Print[];

xMod = Mod[x, n];
yMod = Mod[y, n];

Print["x ≡ ", xMod, " (mod ", n, ")"];
Print["y ≡ ", yMod, " (mod ", n, ")"];
Print[];

Print["Key values:"];
Print["  x - 1 ≡ ", Mod[x - 1, n], " (mod ", n, ")"];
Print["  x + 1 ≡ ", Mod[x + 1, n], " (mod ", n, ")"];
Print["  2 + x ≡ ", Mod[2 + x, n], " (mod ", n, ")"];
Print[];

Print["Check divisibility:"];
Print["  n | (x-1)? ", Divisible[x - 1, n]];
Print["  n | (x+1)? ", Divisible[x + 1, n]];
Print["  n | (2+x)? ", Divisible[2 + x, n]];
Print[];

(* Special observation *)
If[Mod[x + 1, n] == 0,
  Print["⚠ SPECIAL CASE: n | (x+1)"];
  Print["  This means x ≡ -1 (mod n)"];
  Print[];
];

(* R modulo n *)
R = x + y*Sqrt[n];
Print["R = x + y√n (symbolic)"];
Print["For mod n analysis, need integer approximation or algebraic approach"];
Print[];

(* Analyze (x-1)/y structure *)
Print["=" * 70];
Print["COMPONENT ANALYSIS"];
Print["=" * 70];
Print[];

Print["Component 1: (x-1)/y"];
Print["  Numerator (x-1) = ", x - 1];
Print["  Denominator y = ", y];
Print["  Rational value = ", (x - 1)/y];
Print["  Mod ", n, ": (x-1) ≡ ", Mod[x - 1, n], ", y ≡ ", Mod[y, n]];
Print[];

(* For modular arithmetic with fractions, need to check if gcd(y,n)=1 *)
Print["GCD(y, n) = ", GCD[y, n]];
If[GCD[y, n] == 1,
  yInv = PowerMod[y, -1, n];
  Print["y has inverse mod ", n, ": y⁻¹ ≡ ", yInv, " (mod ", n, ")"];
  Print["(x-1)/y ≡ ", Mod[(x - 1) * yInv, n], " (mod ", n, ")"];
  Print[];
,
  Print["⚠ y and n are NOT coprime - modular inverse doesn't exist"];
  Print[];
];

(* Pair sum numerator *)
Print["=" * 70];
Print["PAIR SUM CONSTANT NUMERATOR"];
Print["=" * 70];
Print[];

Print["Numerator of pair sum = 2 + x = ", 2 + x];
Print["Mod ", n, ": (2+x) ≡ ", Mod[2 + x, n], " (mod ", n, ")"];
Print[];

If[Mod[2 + x, n] == 1,
  Print["✓ (2+x) ≡ 1 (mod ", n, ")"];
  Print["  This is interesting - almost invisible mod n!"];
];

Print[];

(* Connection to R-formulation *)
Print["=" * 70];
Print["R-FORMULATION CONNECTION"];
Print["=" * 70];
Print[];

Print["From R = x + y√n:"];
Print["  (x-1)/y = √n · (R-1)/(R+1)"];
Print[];
Print["With x ≡ -1 (mod ", n, "):"];
Print["  R ≡ -1 + y√n (mod ", n, ")"];
Print["  R - 1 ≡ -2 + y√n (mod ", n, ")"];
Print["  R + 1 ≡ 0 + y√n (mod ", n, ")"];
Print[];
Print["So R + 1 contains factor √n in leading term!");
Print[];

(* Check x² ≡ 1 (mod n) *)
Print["=" * 70];
Print["PELL EQUATION CONSEQUENCES"];
Print["=" * 70];
Print[];

Print["From x² - ny² = 1:"];
Print["  x² ≡ 1 (mod n)"];
Print["Verify: x² ≡ ", Mod[x^2, n], " (mod ", n, ")"];
Print[];

If[Mod[x, n] == n - 1,
  Print["Since x ≡ -1 (mod ", n, "):"];
  Print["  x² ≡ (-1)² = 1 (mod ", n, ") ✓"];
  Print[];
  Print["This means x is a square root of 1 modulo ", n];
  Print["The two square roots of 1 mod ", n, " are: ±1"];
  Print["We have x ≡ -1, so x is the NON-TRIVIAL square root"];
];

Print[];
Print["=" * 70];
