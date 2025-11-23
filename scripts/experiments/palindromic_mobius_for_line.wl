#!/usr/bin/env wolframscript
(* Find palindromic Möbius that maps a line to unit circle *)

Print["=== PALINDROMIC MÖBIUS FOR LINE-TO-CIRCLE ===\n"];

Print["GOAL: Find (a,b) such that f(z) = (az+b)/(bz+a)"];
Print["      maps some line L to unit circle |w| = 1\n"];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   PART 1: Which curves map to unit circle?
   ================================================================ *)

Print["PART 1: For f(z) = (az+b)/(bz+a), when is |f(z)| = 1?\n"];

Print["Condition: |f(z)| = 1"];
Print["  ⟺ |az + b| = |bz + a|"];
Print["  ⟺ (az + b)(a*z* + b*) = (bz + a)(b*z* + a*)"];
Print[];

Print["Expanding (assuming real coefficients for now):"];
Print["  |a|²|z|² + ab*z* + a*bz + |b|² = |b|²|z|² + ba*z* + b*az + |a|²"];
Print[];

Print["Simplifying:"];
Print["  (|a|² - |b|²)|z|² = |a|² - |b|²"];
Print[];

Print["Case 1: |a| ≠ |b|"];
Print["  ⟹ |z|² = 1  (unit circle!)"];
Print[];

Print["Case 2: |a| = |b|"];
Print["  ⟹ 0 = 0  (always true)"];
Print["  BUT: need to check original equation more carefully"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   PART 2: Case |a| = |b|
   ================================================================ *)

Print["PART 2: SPECIAL CASE |a| = |b|\n"];

Print["Let a = r·e^(iα), b = r·e^(iβ) where r = |a| = |b|"];
Print[];

Print["Then f(z) = r(ze^(iα) + e^(iβ))/(r(ze^(iβ) + e^(iα)))"];
Print["          = (ze^(iα) + e^(iβ))/(ze^(iβ) + e^(iα))"];
Print[];

Print["For |f(z)| = 1, need:"];
Print["  |ze^(iα) + e^(iβ)| = |ze^(iβ) + e^(iα)|"];
Print[];

Print["Divide by e^(iβ):"];
Print["  |ze^(i(α-β)) + 1| = |z + e^(i(α-β))|"];
Print[];

Print["Let φ = α - β. Then:"];
Print["  |ze^(iφ) + 1| = |z + e^(iφ)|"];
Print[];

Print["This is satisfied when z is on the perpendicular bisector"];
Print["of the segment from -e^(-iφ) to -1"];
Print[];

(* Example: a = 1, b = i (so φ = π/2) *)
Print["Example: a = 1, b = i"];
Print["  φ = arg(1) - arg(i) = 0 - π/2 = -π/2"];
Print["  Need: |ze^(-iπ/2) + 1| = |z + e^(-iπ/2)|"];
Print["        |z(-i) + 1| = |z + (-i)|"];
Print["        |-iz + 1| = |z - i|"];
Print[];

(* Test this *)
a1 = 1;
b1 = I;
f1[z_] := (a1*z + b1)/(b1*z + a1);

Print["Testing which points have |f(z)| = 1:"];
Print[];

testGrid = Flatten[Table[
  x + I*y,
  {x, -2, 2, 0.5},
  {y, -2, 2, 0.5}
], 1];

validPoints = Select[testGrid, Abs[f1[#]] > 0.99 && Abs[f1[#]] < 1.01 &];

Print["Found ", Length[validPoints], " points with |f(z)| ≈ 1"];
Print["Sample points:"];
Print[Take[validPoints, Min[10, Length[validPoints]]]];
Print[];

(* Check if they form a line *)
If[Length[validPoints] >= 2,
  p1 = validPoints[[1]];
  p2 = validPoints[[2]];
  direction = p2 - p1;
  Print["Direction between first two: ", direction // N];
  Print[];
];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   PART 3: Find LINE that maps to circle
   ================================================================ *)

Print["PART 3: SYSTEMATIC SEARCH\n"];

Print["For palindromic f(z) = (az+b)/(bz+a) with a,b real:"];
Print[];

Print["Test: a = 1, b = 1"];
a2 = 1;
b2 = 1;
f2[z_] := (a2*z + b2)/(b2*z + a2);

Print["f(z) = (z + 1)/(z + 1) = 1 (trivial!)"];
Print[];

Print["Test: a = 1, b = 0"];
a3 = 1;
b3 = 0;
f3[z_] := (a3*z + b3)/(b3*z + a3);

Print["f(z) = z/1 = z"];
Print["This maps |z| = 1 to |w| = 1"];
Print["(Unit circle to itself)"];
Print[];

Print["Test: a = 2, b = 1"];
a4 = 2;
b4 = 1;
f4[z_] := (a4*z + b4)/(b4*z + a4);

Print["f(z) = (2z + 1)/(z + 2)"];
Print["Since |a| = 2 ≠ 1 = |b|:");
Print["Maps |z| = 1 to |w| = 1 (by our formula)"];
Print[];

(* Verify *)
testAngles = {0, Pi/6, Pi/4, Pi/3, Pi/2};
Print["Verification on unit circle |z| = 1:"];
Print["θ\t|f(e^(iθ))|"];
Print[StringRepeat["-", 30]];
Do[
  z = Exp[I*testAngles[[i]]];
  absF = Abs[f4[z]] // N;
  Print[testAngles[[i]]/Pi // N, "π\t", absF];
, {i, Length[testAngles]}];
Print[];

Print["Confirmed: Unit circle maps to unit circle"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   PART 4: CRITICAL QUESTION
   ================================================================ *)

Print["PART 4: CAN WE MAP A LINE?\n"];

Print["Question: For palindromic f(z) = (az+b)/(bz+a),"];
Print["          can we choose (a,b) so a LINE maps to |w| = 1?"];
Print[];

Print["From Part 1: |f(z)| = 1 requires"];
Print["  - Either |z| = 1 (when |a| ≠ |b|)"];
Print["  - Or some other curve (when |a| = |b|)"];
Print[];

Print["For |a| ≠ |b|: INPUT must be unit circle (not a line)"];
Print[];

Print["For |a| = |b|: Let's investigate..."];
Print[];

(* General analysis *)
Print["If |a| = |b| and we want |f(z)| = 1 for all z on line L,"];
Print["then we need |az + b| = |bz + a| for all z on L"];
Print[];

Print["Write a = re^(iα), b = re^(iβ) with r > 0"];
Print["Then: |ze^(iα) + e^(iβ)| = |ze^(iβ) + e^(iα)|"];
Print[];

Print["For z = z0 + tv (parametric line):"];
Print["|(z0 + tv)e^(iα) + e^(iβ)| = |(z0 + tv)e^(iβ) + e^(iα)|"];
Print[];

Print["This must hold for ALL t ∈ ℝ"];
Print[];

Print["Geometric interpretation:");
Print["The line L must be equidistant from points -e^(iβ-iα) and -e^(iα-iβ)"];
Print["⟹ L is the perpendicular bisector of these two points"];
Print[];

Print["Perpendicular bisector is a LINE! ✓"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   SUMMARY
   ================================================================ *)

Print["SUMMARY\n"];

Print["For palindromic f(z) = (az+b)/(bz+a):"];
Print[];

Print["CASE 1: |a| ≠ |b|"];
Print["  ✓ Unit circle |z| = 1 maps to |w| = 1"];
Print["  ✗ No line maps to unit circle"];
Print[];

Print["CASE 2: |a| = |b|"];
Print["  ✓ Perpendicular bisector line maps to |w| = 1"];
Print["  ✓ This is a LINE (not unit circle)"];
Print[];

Print["ANSWER TO YOUR QUESTION:"];
Print["  YES - palindromic Möbius CAN map a line to circle!"];
Print["  Condition: |a| = |b|"];
Print["  The line is determined by the phases of a and b"];
Print[];

Print["FOR ZETA FUNCTION:"];
Print["  Could shift ζ so nuls are on THIS specific line"];
Print["  Then apply palindromic transformation"];
Print["  Trade functional equation symmetry for reciprocal equation"];
Print[];

Print["NEXT STEP: Find which line for given (a,b)"];
