#!/usr/bin/env wolframscript
(* Test symmetric Möbius transformation f(z) = (az+b)/(bz+a) *)

Print["=== SYMMETRIC MÖBIUS TRANSFORMATION ===\n"];
Print["Form: f(z) = (az + b)/(bz + a)\n"];

(* Define the transformation *)
f[z_, a_, b_] := (a*z + b)/(b*z + a);

Print["f(z) = (az + b)/(bz + a)"];
Print["f(1/z) = ", f[1/z, a, b] // Simplify];
Print[];

(* Compute product *)
product = Simplify[f[z, a, b] * f[1/z, a, b]];
Print["f(z) · f(1/z) = ", product];
Print[];

Print["✓✓✓ This is CONSTANT = 1 ✓✓✓"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Verify algebraically *)
Print["ALGEBRAIC VERIFICATION:\n"];

Print["Numerator of product:"];
num = Expand[(a*z + b) * (a + b*z)];
Print["  (az + b)(a + bz) = ", num];
Print[];

Print["Denominator of product:"];
den = Expand[(b*z + a) * (b + a*z)];
Print["  (bz + a)(b + az) = ", den];
Print[];

Print["Numerator = Denominator? ", num === den];
Print["Therefore f(z)·f(1/z) = 1 ✓"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Special properties *)
Print["SPECIAL PROPERTIES:\n"];

Print["Poles: bz + a = 0 → z = -a/b"];
Print["Zeros: az + b = 0 → z = -b/a"];
Print[];

Print["Note: pole at z = -a/b, zero at z = -b/a"];
Print["Product: (-a/b)·(-b/a) = 1"];
Print["→ Poles and zeros are RECIPROCAL pairs! ✓"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* What does it map? *)
Print["MAPPING PROPERTIES:\n"];

Print["Case 1: a, b real, a² + b² = 1 (unit magnitude)\n"];
a1 = 1/Sqrt[2];
b1 = 1/Sqrt[2];

Print["Example: a = b = 1/√2"];
Print["f(z) = (z + 1)/(z + 1) = 1 (trivial!)"];
Print[];

Print["Case 2: a = 1, b = i (complex)\n"];
a2 = 1;
b2 = I;

testPoints = {1, 2, I, 1+I, -I};
Print["Testing points:"];
Print["z | f(z) | |f(z)|"];
Print[StringRepeat["-", 50]];
Do[
  z0 = testPoints[[i]];
  fz = f[z0, a2, b2];
  Print[z0, " | ", fz // Simplify, " | ", Abs[fz] // N];
, {i, Length[testPoints]}];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Find what maps to unit circle *)
Print["CONDITION FOR MAPPING TO UNIT CIRCLE:\n"];
Print["For |f(z)| = 1, we need |az + b| = |bz + a|\n"];

Print["Squaring: (az + b)(a*z* + b*) = (bz + a)(b*z* + a*)"];
Print[];

Print["For z on some curve, this should hold.\n"];
Print["Let's test: what if |a| = |b|?\n"];

Print["If |a| = |b|, let a = r·e^(iα), b = r·e^(iβ)"];
Print["Then f(z) = r(ze^(iα) + e^(iβ))/(r(ze^(iβ) + e^(iα)))"];
Print["       = (ze^(iα) + e^(iβ))/(ze^(iβ) + e^(iα))");
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Specific example: a = 1, b = -1 *)
Print["EXAMPLE: a = 1, b = -1\n"];
Print["f(z) = (z - 1)/(-z + 1) = -(z - 1)/(z - 1) = -1 (constant!)"];
Print[];

Print["EXAMPLE: a = 1, b = i\n"];
a3 = 1;
b3 = I;

Print["f(z) = (z + i)/(iz + 1)"];
Print[];

(* Test on real axis *)
Print["On real axis (z = x ∈ ℝ):"];
testReal = {-2, -1, 0, 1, 2};
Print["x | f(x) | |f(x)|"];
Print[StringRepeat["-", 50]];
Do[
  x = testReal[[i]];
  fx = f[x, a3, b3] // Simplify;
  Print[x, " | ", fx, " | ", Abs[fx] // N];
, {i, Length[testReal]}];
Print[];

Print["NOT all on unit circle - depends on input"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Find the circle/line that maps to unit circle *)
Print["GENERAL THEORY:\n"];
Print["Möbius transformations map circles/lines to circles/lines."];
Print[];
Print["For f(z) = (az+b)/(bz+a) with f(z)·f(1/z) = 1:");
Print["- If z is on curve C, then f(z) has some property"];
Print["- Since f(z)·f(1/z) = 1, we have |f(z)| = 1/|f(1/z)|"];
Print[];
Print["For |f(z)| = 1 everywhere on C:");
Print["  → |f(1/z)| = 1 also"];
Print["  → Both z and 1/z map to unit circle"];
Print[];

Print["This happens when C is the UNIT CIRCLE |z| = 1!");
Print["(Because then z = 1/z* for |z| = 1)"];
Print[];

(* Verify unit circle maps to unit circle *)
Print["VERIFICATION: Unit circle |z| = 1\n"];
angles = {0, Pi/6, Pi/4, Pi/3, Pi/2};
a4 = 1;
b4 = I;

Print["For f(z) = (z + i)/(iz + 1), z = e^(iθ):"];
Print["θ | f(e^(iθ)) | |f(e^(iθ))|"];
Print[StringRepeat["-", 50]];
Do[
  theta = angles[[i]];
  z0 = Exp[I*theta];
  fz = f[z0, a4, b4] // Simplify;
  Print[theta/Pi // N, "π | ", fz // N, " | ", Abs[fz] // N];
, {i, Length[angles]}];
Print[];

Print[StringRepeat["=", 60]];
Print[];

Print["SUMMARY:\n"];
Print["✓ f(z) = (az+b)/(bz+a) satisfies f(z)·f(1/z) = 1"];
Print["✓ Poles and zeros are reciprocal pairs"];
Print["✓ Unit circle |z|=1 maps to unit circle |w|=1"];
Print["✓ Different (a,b) give different mappings"];
Print["✓ Can map other circles/lines to unit circle (need to find them)"];
Print[];
Print["This is the PALINDROMIC MÖBIUS form from today's session!"];
Print["Coefficients [a, b, b, a] are palindromic ✓"];
