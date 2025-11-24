#!/usr/bin/env wolframscript
(* Trace HOW Mathematica proves they're equal *)

Print["=== Tracing Mathematica's Proof Steps ===\n"];

hypForm[x_, k_] := 1/2 + Cosh[(1+2*k)*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);

chebForm[x_, k_] := ChebyshevT[Ceiling[k/2], x+1] *
  (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Strategy 1: Use TrigToExp to convert Cosh to exponentials"];
Print["==========================================================\n"];

k = 3;
hypExpr = hypForm[x, k];
Print["Original hyperbolic: ", hypExpr];
Print[];

converted = hypExpr // TrigToExp // FullSimplify;
Print["After TrigToExp + FullSimplify: "];
Print[converted];
Print[];

Print["Strategy 2: Try direct Chebyshev expansion"];
Print["===========================================\n"];

(* Known: Cosh[n*θ] can be expressed with Chebyshev T_n(cosh θ) *)
(* But we have Cosh[n*arcsinh(z)] which is different *)

Print["Key insight: Cosh[n*arcsinh(z)] has a polynomial form!"];
Print["Let's derive it:\n"];

Print["If θ = arcsinh(z), then sinh(θ) = z, cosh(θ) = √(1+z²)"];
Print["And cosh(nθ) = T_n(cosh θ) = T_n(√(1+z²))\n"];

Print["For our case: z = √(x/2)"];
Print["So: cosh(θ) = √(1 + x/2) = √((2+x)/2)");
Print["Thus: Cosh[(1+2k)*arcsinh(√(x/2))] = T_{1+2k}(√((2+x)/2))\n"];

(* Verify this *)
k = 3;
n = 1 + 2*k; (* n = 7 *)
z = Sqrt[x/2];
coshTheta = Sqrt[1 + z^2];

directT = ChebyshevT[n, coshTheta] // FullSimplify;
Print["T_7(√((2+x)/2)): ", directT];
Print[];

originalCosh = Cosh[n*ArcSinh[z]] // FullSimplify;
Print["Cosh[7*arcsinh(√(x/2))]: ", originalCosh];
Print[];

Print["Are they equal? ", FullSimplify[directT - originalCosh] == 0];
Print[];

Print["Strategy 3: Complete the hyperbolic form"];
Print["=========================================\n"];

(* Full hyperbolic form *)
hypComplete = 1/2 + ChebyshevT[n, Sqrt[(2+x)/2]]/(Sqrt[2]*Sqrt[2+x]);
Print["Hyperbolic as T_n: ", hypComplete // FullSimplify];
Print[];

(* Chebyshev form *)
chebComplete = chebForm[x, 3];
Print["Chebyshev form: ", chebComplete // Expand];
Print[];

Print["Difference: ", FullSimplify[hypComplete - chebComplete]];
Print[];

Print["Strategy 4: Try variable substitution"];
Print["======================================\n"];

Print["Let's try substituting y = √((2+x)/2) into T_7(y)"];
Print["Then express result in terms of x.\n"];

y = Sqrt[(2+x)/2];
tOfY = ChebyshevT[7, y];
Print["T_7(y) where y = √((2+x)/2):"];
Print[tOfY];
Print[];

(* Now expand and substitute back *)
expanded = tOfY // PowerExpand // FullSimplify;
Print["Expanded: ", expanded];
Print[];

(* Multiply by 1/(√2·√(2+x)) and add 1/2 *)
withDenom = 1/2 + expanded/(Sqrt[2]*Sqrt[2+x]) // FullSimplify;
Print["Full form: 1/2 + T_7(y)/(√2·√(2+x)): "];
Print[withDenom // Expand];
Print[];

Print["Compare to Chebyshev form: ", chebForm[x, 3] // Expand];
Print[];

Print["Match? ", FullSimplify[withDenom - chebForm[x, 3]] == 0];
Print[];

Print["=== Key Question ==="];
Print["How does T_n(√((2+x)/2)) relate to our Chebyshev form with (x+1)?"];
Print[];
