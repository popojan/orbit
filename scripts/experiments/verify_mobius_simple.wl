#!/usr/bin/env wolframscript
(* Clean verification of Möbius transformations *)

Print["=== MÖBIUS TRANSFORMATIONS: Re(z)=1/2 → |w|=1 ===\n"];

(* Test transformation 1: w = z/(z-1) *)
Print["TRANSFORMATION 1: w = z/(z-1)\n"];

testCases = {
  {0, 1/2},
  {1, 1/2 + I},
  {2, 1/2 + 2*I},
  {-1, 1/2 - I},
  {5, 1/2 + 5*I}
};

Do[
  {t, z} = testCases[[i]];
  w = z/(z - 1);
  Print["z = 1/2 + (", t, ")I"];
  Print["  w = ", w // Simplify];
  Print["  |w| = ", Abs[w] // Simplify];
  Print["  |w| - 1 = ", Chop[Abs[w] - 1, 10^-10]];
  Print[];
, {i, Length[testCases]}];

Print[StringRepeat["=", 60]];
Print[];

(* Test general formula *)
Print["GENERAL FORMULA: w = (z - 1/2 + r)/(z - 1/2 - r)\n"];

Print["Example with z = 1/2 + I, different r values:\n"];

testR = {1/4, 1/2, 1, 2};
z = 1/2 + I;

Do[
  w = (z - 1/2 + r)/(z - 1/2 - r);
  Print["r = ", r];
  Print["  w = ", w // Simplify];
  Print["  |w| = ", Abs[w] // Simplify];
  Print["  |w| - 1 = ", Chop[Abs[w] - 1, 10^-10]];
  Print[];
, {r, testR}];

Print[StringRepeat["=", 60]];
Print[];

(* Inverse check *)
Print["INVERSE TRANSFORMATION: z = w/(w-1)\n"];
Print["For points on unit circle |w|=1:\n"];

angles = {0, Pi/6, Pi/4, Pi/3, Pi/2, 2*Pi/3, Pi};

Do[
  w = Exp[I*theta];
  z = w/(w - 1);
  Print["θ = ", theta/Pi // N, "π"];
  Print["  w = ", w // N];
  If[Abs[Im[z]] < 10^-10,
    Print["  z = ", Re[z] // N, " (real)"],
    Print["  z = ", z // N]
  ];
  Print["  Re(z) = ", Re[z] // N];
  Print[];
, {theta, angles}];

Print[StringRepeat["=", 60]];
Print[];

(* Algebraic verification *)
Print["ALGEBRAIC VERIFICATION:\n"];
Print["For z = 1/2 + t*I and w = z/(z-1):\n"];

z = 1/2 + t*I;
w = z/(z - 1);
wSimplified = Simplify[w, Assumptions -> t ∈ Reals];
Print["w = ", wSimplified];
Print[];

absWSquared = Simplify[Abs[w]^2, Assumptions -> t ∈ Reals];
Print["|w|² = ", absWSquared];
Print[];

(* Manual calculation *)
num = Numerator[wSimplified];
den = Denominator[wSimplified];
Print["Numerator: ", num];
Print["Denominator: ", den];
Print[];

Print["Check |numerator|² / |denominator|²:"];
numAbs2 = Simplify[ComplexExpand[Abs[num]^2], Assumptions -> t ∈ Reals];
denAbs2 = Simplify[ComplexExpand[Abs[den]^2], Assumptions -> t ∈ Reals];
Print["|num|² = ", numAbs2];
Print["|den|² = ", denAbs2];
Print["|num|² / |den|² = ", Simplify[numAbs2/denAbs2]];
Print[];

Print["CONCLUSION: |w| = 1 for all t ∈ ℝ ✓"];
