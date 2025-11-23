#!/usr/bin/env wolframscript
(* Algebraic proof that w = z/(z-1) maps Re(z)=1/2 to |w|=1 *)

Print["=== ALGEBRAIC PROOF ===\n"];
Print["Given: z = 1/2 + t*I where t ∈ ℝ"];
Print["Transformation: w = z/(z-1)\n"];

(* Define z symbolically *)
z = 1/2 + t*I;
Print["z = ", z];
Print[];

(* Compute w *)
w = z/(z - 1);
Print["w = z/(z-1) = ", w];
Print[];

(* Simplify *)
wExpanded = Simplify[w, Assumptions -> Element[t, Reals]];
Print["Simplified: w = ", wExpanded];
Print[];

(* Separate into real and imaginary parts *)
wRe = ComplexExpand[Re[w], TargetFunctions -> {Re, Im}];
wIm = ComplexExpand[Im[w], TargetFunctions -> {Re, Im}];
Print["Re(w) = ", Simplify[wRe, Assumptions -> Element[t, Reals]]];
Print["Im(w) = ", Simplify[wIm, Assumptions -> Element[t, Reals]]];
Print[];

(* Compute |w|² *)
Print["Computing |w|²:"];
absWSquared = Simplify[
  ComplexExpand[Abs[w]^2, TargetFunctions -> {Re, Im}],
  Assumptions -> Element[t, Reals]
];
Print["|w|² = ", absWSquared];
Print[];

(* Alternative: direct calculation *)
Print["Alternative calculation:"];
numerator = z;
denominator = z - 1;

Print["z = ", numerator];
Print["z - 1 = ", denominator];
Print[];

numAbs2 = Simplify[
  ComplexExpand[Abs[numerator]^2, TargetFunctions -> {Re, Im}],
  Assumptions -> Element[t, Reals]
];

denAbs2 = Simplify[
  ComplexExpand[Abs[denominator]^2, TargetFunctions -> {Re, Im}],
  Assumptions -> Element[t, Reals]
];

Print["|z|² = |1/2 + t*I|² = ", numAbs2];
Print["|z-1|² = |-1/2 + t*I|² = ", denAbs2];
Print[];

ratio = Simplify[numAbs2/denAbs2];
Print["|w|² = |z|²/|z-1|² = ", ratio];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* General formula proof *)
Print["GENERAL FORMULA: w = (z - 1/2 + r)/(z - 1/2 - r)\n"];

Print["For z = 1/2 + t*I:\n"];

wGeneral = (z - 1/2 + r)/(z - 1/2 - r);
Print["w = (1/2 + t*I - 1/2 + r)/(1/2 + t*I - 1/2 - r)"];
Print["  = (r + t*I)/(-r + t*I)"];
Print[];

numGen = r + t*I;
denGen = -r + t*I;

numGenAbs2 = Simplify[
  ComplexExpand[Abs[numGen]^2, TargetFunctions -> {Re, Im}],
  Assumptions -> Element[{t, r}, Reals]
];

denGenAbs2 = Simplify[
  ComplexExpand[Abs[denGen]^2, TargetFunctions -> {Re, Im}],
  Assumptions -> Element[{t, r}, Reals]
];

Print["|numerator|² = |r + t*I|² = ", numGenAbs2];
Print["|denominator|² = |-r + t*I|² = ", denGenAbs2];
Print[];

ratioGen = Simplify[numGenAbs2/denGenAbs2];
Print["|w|² = ", ratioGen];
Print[];

Print["CONCLUSION: |w| = 1 for all t, r ∈ ℝ (r ≠ 0) ✓"];
Print[];
Print[StringRepeat["=", 60]];
Print[];

(* Summary *)
Print["SUMMARY:\n"];
Print["✓ w = z/(z-1) maps Re(z) = 1/2 to |w| = 1"];
Print["✓ General form w = (z - a)/(z - b) works when a, b symmetric"];
Print["  around Re(z) = 1/2, i.e., a = 1/2 - r, b = 1/2 + r"];
Print["✓ Infinitely many such transformations (parametrized by r ≠ 0)"];
Print["✓ Different r values give different rotations on unit circle"];
