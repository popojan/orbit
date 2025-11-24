#!/usr/bin/env wolframscript
(* Find algebraic bridge between Hyperbolic and Chebyshev forms *)

Print["=== Hyperbolic ↔ Chebyshev Algebraic Bridge ===\n"];

(* Hyperbolic form *)
hypForm[x_, k_] := 1/2 + Cosh[(1+2*k)*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);

(* Chebyshev form *)
chebForm[x_, k_] := ChebyshevT[Ceiling[k/2], x+1] *
  (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Known identity: T_n(cosh θ) = cosh(nθ)\n"];
Print["Key question: How does ArcSinh relate to arccosh?\n"];
Print["=================================================\n"];

Print["Step 1: Explore ArcSinh[√(x/2)] substitution"];
Print["=============================================\n"];

(* Known: arccosh(y) = arcsinh(√(y²-1)) *)
(* Also: arccosh(y) = ln(y + √(y²-1)) *)
(* And: arcsinh(z) = ln(z + √(z²+1)) *)

Print["For our hyperbolic form, let z = √(x/2), so:"];
Print["ArcSinh[√(x/2)] = arcsinh(z)\n"];

Print["Convert to arccosh: if sinh(θ) = z, then cosh(θ) = √(z²+1) = √(x/2 + 1)\n"];

Print["So: ArcSinh[√(x/2)] = arccosh(√(x/2 + 1))\n"];

Print["Step 2: Substitute into hyperbolic form"];
Print["========================================\n"];

Print["Cosh[(1+2k)*ArcSinh[√(x/2)]]"];
Print["= Cosh[(1+2k)*arccosh(√(x/2 + 1))]\n"];

Print["Using T_n(cosh θ) = cosh(nθ):"];
Print["= T_{1+2k}(√(x/2 + 1))  [if we set θ = arccosh(√(x/2+1))]\n"];

(* Let me verify this numerically *)
Print["Step 3: Numerical verification"];
Print["==============================\n"];

testVals = {{x -> 2, k -> 3}, {x -> 5, k -> 4}, {x -> 10, k -> 5}};

Do[
  {xVal, kVal} = {x, k} /. rule;

  (* Original hyperbolic *)
  hyp = hypForm[xVal, kVal];

  (* Try Chebyshev with our substitution *)
  (* Argument should be sqrt(x/2 + 1) *)
  arg = Sqrt[xVal/2 + 1];
  chebTest = 1/2 + ChebyshevT[1 + 2*kVal, arg]/(Sqrt[2]*Sqrt[2+xVal]);

  Print["x=", xVal, ", k=", kVal, ":"];
  Print["  Hyperbolic form:     ", N[hyp, 20]];
  Print["  Chebyshev T test:    ", N[chebTest, 20]];
  Print["  Match? ", Abs[hyp - chebTest] < 10^-10];
  Print[];
, {rule, testVals}];

Print["Step 4: Connect to Chebyshev U form"];
Print["====================================\n"];

Print["We have Chebyshev form with argument (x+1)."];
Print["Need to relate √(x/2+1) to (x+1).\n"];

Print["Let's check if there's a substitution:"];
Print["If argument to T is √(x/2+1), what substitution gives (x+1)?\n"];

(* Check relationship *)
Print["For x=2: √(2/2+1) = √2 ≈ 1.414, while (2+1) = 3"];
Print["For x=5: √(5/2+1) = √3.5 ≈ 1.871, while (5+1) = 6"];
Print["These don't match directly.\n"];

Print["Step 5: Check if there's a transformation"];
Print["=========================================\n"];

Print["Maybe we need T_n composition or U polynomial relation?\n"];

(* Try direct comparison *)
Print["Direct comparison for k=3, x=2:"];
k = 3; x = 2;
Print["Hyperbolic: ", hypForm[2, 3] // N];
Print["Chebyshev:  ", chebForm[2, 3] // N];
Print["Match? ", FullSimplify[hypForm[2, 3] - chebForm[2, 3]] == 0];
Print[];

Print["Step 6: Symbolic comparison"];
Print["===========================\n"];

Do[
  diff = FullSimplify[hypForm[x, kval] - chebForm[x, kval]];
  Print["k=", kval, ": Difference = ", diff];
, {kval, 1, 5}];

Print["\n=== Analysis Complete ==="];
