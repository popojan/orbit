#!/usr/bin/env wolframscript
(* Test if Möbius transformations satisfy f(z)·f(1/z) = C *)

Print["=== RECIPROCAL FUNCTIONAL EQUATION TEST ===\n"];
Print["Testing: f(z) · f(1/z) = C (constant)?\n"];

(* Test transformation w = z/(z-1) *)
Print["TRANSFORMATION: f(z) = z/(z-1)\n"];

f1[z_] := z/(z - 1);

(* Compute f(z) · f(1/z) *)
Print["f(z) = ", f1[z]];
Print["f(1/z) = ", f1[1/z] // Simplify];
Print[];

product1 = Simplify[f1[z] * f1[1/z]];
Print["f(z) · f(1/z) = ", product1];
Print[];

(* Check if it's constant *)
Print["Is this constant? ", FreeQ[product1, z]];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Test with specific values *)
Print["Numerical verification:\n"];
testZ = {1, 2, I, 1+I, 2+3*I, 1/2 + I, 1/2 + 5*I};

Print["z | f(z)·f(1/z)"];
Print[StringRepeat["-", 50]];
Do[
  z = testZ[[i]];
  prod = f1[z] * f1[1/z] // Simplify;
  Print[z, " | ", prod];
, {i, Length[testZ]}];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Test general formula *)
Print["GENERAL FORMULA: f(z) = (z - 1/2 + r)/(z - 1/2 - r)\n"];

fGeneral[z_, r_] := (z - 1/2 + r)/(z - 1/2 - r);

Print["f(z) = (z - 1/2 + r)/(z - 1/2 - r)"];
Print["f(1/z) = ", fGeneral[1/z, r] // Simplify];
Print[];

productGeneral = Simplify[fGeneral[z, r] * fGeneral[1/z, r]];
Print["f(z) · f(1/z) = ", productGeneral];
Print[];
Print["Is this constant? ", FreeQ[productGeneral, z]];
Print[];

(* Test with r = 1/2 *)
Print["For r = 1/2 (i.e., f(z) = z/(z-1)):\n"];
productR12 = Simplify[fGeneral[z, 1/2] * fGeneral[1/z, 1/2]];
Print["f(z) · f(1/z) = ", productR12];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* What WOULD satisfy reciprocal equation? *)
Print["QUESTION: What functions DO satisfy f(z)·f(1/z) = C?\n"];

Print["Known examples from today's session:"];
Print["1. f(z) = z^n → f(z)·f(1/z) = z^n · z^(-n) = 1"];
Print["2. Chebyshev: F_n(z) · F_n(1/z) = (-1)^n"];
Print["3. Palindromic rational functions"];
Print[];

(* Test simple power *)
Print["Testing f(z) = z:\n"];
f2[z_] := z;
product2 = Simplify[f2[z] * f2[1/z]];
Print["f(z) · f(1/z) = ", product2, " ✓"];
Print[];

(* Test z^2 *)
Print["Testing f(z) = z^2:\n"];
f3[z_] := z^2;
product3 = Simplify[f3[z] * f3[1/z]];
Print["f(z) · f(1/z) = ", product3, " ✓"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Can we modify Möbius to satisfy reciprocal equation? *)
Print["MODIFIED QUESTION: Can we construct g(w(z)) where w is Möbius?\n"];
Print["If w = z/(z-1) maps Re(z)=1/2 to |w|=1,"];
Print["then g(w) = w^n would give g(w(z))·g(w(1/z)) = w(z)^n · w(1/z)^n\n"];

w[z_] := z/(z - 1);
g[w_] := w^2;
composite[z_] := g[w[z]];

Print["Composite: h(z) = (z/(z-1))^2"];
productComposite = Simplify[composite[z] * composite[1/z]];
Print["h(z) · h(1/z) = ", productComposite];
Print["Is constant? ", FreeQ[productComposite, z]];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Special case: points on Re(z) = 1/2 *)
Print["SPECIAL CASE: Restricting to Re(z) = 1/2\n"];
Print["For z = 1/2 + t*I, compute 1/z:\n"];

z0 = 1/2 + t*I;
z0inv = Simplify[1/z0, Assumptions -> Element[t, Reals]];
Print["z = ", z0];
Print["1/z = ", z0inv];
Print[];

Print["Note: 1/z is NOT on the line Re(z) = 1/2"];
Print["Re(1/z) = ", Simplify[Re[z0inv], Assumptions -> Element[t, Reals]]];
Print["This equals 1/2 only when: ", Solve[Re[z0inv] == 1/2, t, Reals]];
Print[];

Print[StringRepeat["=", 60]];
Print[];

Print["CONCLUSION:\n"];
Print["✗ Möbius w = z/(z-1) does NOT satisfy w(z)·w(1/z) = C"];
Print["✗ General Möbius from our family does NOT satisfy it either"];
Print["✓ Simple powers z^n DO satisfy it"];
Print["✗ For points on Re(z)=1/2, the point 1/z is NOT on Re(z)=1/2"];
Print["  (except at isolated points)"];
Print[];
Print["The two properties are INDEPENDENT:"];
Print["  - Mapping Re(z)=1/2 to |w|=1 (Möbius does this)");
Print["  - Satisfying f(z)·f(1/z) = C (Möbius does NOT do this)"];
