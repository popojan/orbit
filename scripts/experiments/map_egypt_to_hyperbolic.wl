#!/usr/bin/env wolframscript
(* Map Egypt parameter x to hyperbolic radius *)

<< Orbit`

Print["Mapping Egypt parameter x to Poincare disk coordinates\n"];
Print[StringRepeat["=", 70]];
Print[];

(* Our hyperbolic formula uses these arguments *)
arg1[x_] := Sqrt[x/2];
arg2[x_] := Sqrt[2 + x];

Print["Our formula has arguments:"];
Print["  a1(x) = sqrt(x/2)"];
Print["  a2(x) = sqrt(2+x)"];
Print["  Full: Cosh[(1+2k) * ArcSinh[a1(x)]] / (sqrt(2) * a2(x))"];
Print[];

(* Hypothesis: a1(x) might be related to radius in Poincare disk *)
Print["HYPOTHESIS 1: Is sqrt(x/2) the Poincare radius?\n"];

Print["If r = sqrt(x/2), then:");
Print["  x = 2r²"];
Print["  Valid range: x >= 0 (so r >= 0)"];
Print["  For Poincare disk need r < 1, so x < 2\n"];

Print["Testing x values and corresponding 'radius':"];
Print["x\t\tr=sqrt(x/2)\tIn disk?");
Print[StringRepeat["-", 50]];
Do[
  r = Sqrt[x/2];
  inDisk = r < 1;
  Print[N[x,4], "\t\t", N[r,5], "\t\t", If[inDisk, "YES", "NO (r>=1)"]];
, {x, {0.5, 1, 1.5, 2, 3, 5, 13}}];
Print[];

(* Hyperbolic distance in standard Poincare *)
hypDist[r_] := 2*ArcTanh[r];
hypDistAlt[r_] := 2*ArcSinh[r / Sqrt[1 - r^2]];

Print["In STANDARD Poincare disk:"];
Print["  d = 2*ArcTanh[r] = 2*ArcSinh[r/sqrt(1-r²)]\n"];

Print["But our formula uses: ArcSinh[sqrt(x/2)]");
Print["                    = ArcSinh[r] (if r = sqrt(x/2))"];
Print["This is NOT 2*ArcSinh[r/sqrt(1-r²)]\n"];

Print["So our 'r' is NOT standard Poincare radius!\n"];
Print[StringRepeat["=", 70]];
Print[];

(* Try different coordinate systems *)
Print["HYPOTHESIS 2: Different coordinate transformation\n"];

Print["Standard Poincare uses z = tanh(w) where w is upper half-plane");
Print["Maybe we use different map?\n"];

(* Check relationship *)
Print["Our ArcSinh[sqrt(x/2)] compared to standard distance:\n"];
Print["x\t\tr=√(x/2)\tArcSinh[r]\td_standard(r)");
Print[StringRepeat["-", 70]];
Do[
  r = Sqrt[x/2];
  If[r < 1,
    ourArg = ArcSinh[r];
    stdDist = hypDistAlt[r];
    Print[N[x,4], "\t\t", N[r,5], "\t", N[ourArg,5], "\t\t", N[stdDist,5]];
  ];
, {x, {0.5, 1, 1.5}}];
Print[];

Print["They're DIFFERENT → different coordinate system!\n"];
Print[StringRepeat["=", 70]];
Print[];

(* Chebyshev shift x -> x+1 *)
Print["HYPOTHESIS 3: Chebyshev shift x+1 centers the domain\n"];

Print["Chebyshev uses argument u = x+1"];
Print["When x >= 0, we have u >= 1\n"];

Print["Standard Chebyshev T_n, U_n defined for |u| <= 1");
Print["But we use u = x+1 >= 1 (OUTSIDE standard domain!)");
Print["This means we're using ANALYTIC CONTINUATION\n"];

Print["Chebyshev for |u| > 1 connects to HYPERBOLIC functions:");
Print["  T_n(cosh(t)) = cosh(nt)");
Print["  U_n(cosh(t)) = sinh((n+1)t)/sinh(t)\n");

Print["If u = x+1 = cosh(t), then:");
Print["  t = ArcCosh[x+1]");
Print["  Valid when x+1 >= 1, i.e., x >= 0 ✓\n"];

Print["Testing the connection:\n"];
Print["x\t\tu=x+1\t\tt=ArcCosh[u]");
Print[StringRepeat["-", 50]];
Do[
  u = x + 1;
  t = ArcCosh[u];
  Print[N[x,4], "\t\t", N[u,4], "\t\t", N[t,5]];
, {x, {0, 1, 2, 5, 13}}];
Print[];

Print[StringRepeat["=", 70]];
Print[];

(* Connection between the two *)
Print["HYPOTHESIS 4: Relating both coordinate systems\n"];

Print["We have TWO transformations:"];
Print["  1. Hyperbolic: ArcSinh[sqrt(x/2)]"];
Print["  2. Chebyshev: ArcCosh[x+1]\n"];

Print["Are they related?\n"];

Print["Testing if ArcSinh[sqrt(x/2)] ≈ f(ArcCosh[x+1]):\n"];
Print["x\t\tArcSinh[√(x/2)]\tArcCosh[x+1]");
Print[StringRepeat["-", 50]];
Do[
  as = ArcSinh[Sqrt[x/2]];
  ac = ArcCosh[x + 1];
  ratio = as / ac;
  Print[N[x,4], "\t\t", N[as,5], "\t\t", N[ac,5], "\t\tratio=", N[ratio,4]];
, {x, {0.5, 1, 2, 5, 13}}];
Print[];

Print["Not a simple ratio... but both are MONOTONIC in x\n"];

Print[StringRepeat["=", 70]];
Print[];

(* The key identity *)
Print["KEY INSIGHT: Identity between cosh and sinh\n"];

Print["Recall: cosh²(t) - sinh²(t) = 1"];
Print["So: cosh(t) = sqrt(1 + sinh²(t))\n"];

Print["If ArcSinh[sqrt(x/2)] = s, then:"];
Print["  sinh(s) = sqrt(x/2)");
Print["  cosh(s) = sqrt(1 + x/2) = sqrt((2+x)/2)\n"];

Print["If ArcCosh[x+1] = t, then:");
Print["  cosh(t) = x+1");
Print["  sinh(t) = sqrt((x+1)² - 1) = sqrt(x² + 2x) = sqrt(x)*sqrt(x+2)\n"];

Print["Verification:\n"];
Print["x\t\tsqrt((2+x)/2)\tsqrt(x+2)/sqrt(2)");
Print[StringRepeat["-", 50]];
Do[
  v1 = Sqrt[(2 + x)/2];
  v2 = Sqrt[x + 2]/Sqrt[2];
  Print[N[x,4], "\t\t", N[v1,6], "\t\t", N[v2,6], "\t", v1 == v2];
, {x, {1, 2, 5, 13}}];
Print[];

Print["They're THE SAME! So cosh(ArcSinh[sqrt(x/2)]) = sqrt(2+x)/sqrt(2)\n"];
Print["This appears in our denominator!\n"];

Print[StringRepeat["=", 70]];
Print[];

Print["SUMMARY:\n"];
Print["1. sqrt(x/2) is NOT standard Poincare radius"];
Print["2. x+1 connects to Chebyshev via ArcCosh (hyperbolic identity)"];
Print["3. The two coordinates are related by:"];
Print["     cosh(ArcSinh[√(x/2)]) = √(2+x)/√2 ✓"];
Print["4. This suggests x parametrizes BOTH coordinate systems"];
Print["5. The geometry is hyperbolic but in MODIFIED coordinates\n"];

Print["Next step: Understand the (1+2k) factor in Cosh[(1+2k)*ArcSinh[...]]"];
Print["This might be related to k-fold covering or k-periodic structure\n"];

Print["DONE!"];
