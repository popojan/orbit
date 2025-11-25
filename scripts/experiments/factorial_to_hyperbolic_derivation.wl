#!/usr/bin/env wolframscript
(* Algebraic derivation: Factorial → Hyperbolic *)

Print["=== FACTORIAL → HYPERBOLIC ALGEBRAIC DERIVATION ===\n"];

(* Original factorial form *)
factorialTerm[x_, k_, i_] := 2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);

Print["Step 1: Rewrite using Pochhammer symbols"];
Print["============================================\n"];

Print["Original term:"];
Print["  2^(i-1) · x^i · (k+i)! / ((k-i)! · (2i)!)\n"];

Print["Pochhammer representation:"];
Print["  (k+i)!/(k-i)! = (k-i+1)(k-i+2)...(k+i)"];
Print["                = Pochhammer[k-i+1, 2i]\n"];

(* Verify Pochhammer *)
Print["Verification for k=3, i=2:"];
kval = 3; ival = 2;
factorial = Factorial[kval+ival]/Factorial[kval-ival];
pochhammer = Pochhammer[kval-ival+1, 2*ival];
Print["  Factorial form: ", factorial];
Print["  Pochhammer form: ", pochhammer];
Print["  Match? ", factorial == pochhammer];
Print[];

Print["Step 2: Identify series structure"];
Print["===================================\n"];

Print["Full sum:"];
Print["  D(x,k) = 1 + Σ[i=1 to k] 2^(i-1) · x^i · Pochhammer[k-i+1, 2i] / (2i)!\n"];

Print["Let's examine the structure:"];
Print["  - Powers of 2: 2^(i-1)"];
Print["  - Powers of x: x^i"];
Print["  - Rising factorial: Pochhammer[k-i+1, 2i]"];
Print["  - Falling factorial in denominator: (2i)!\n"];

Print["Step 3: Try to recognize as hypergeometric series"];
Print["==================================================\n"];

Print["Standard HypergeometricPFQ form:"];
Print["  pFq[{a1,...,ap}, {b1,...,bq}, z] = Σ[n=0 to ∞] (Pochhammer[a1,n]·...·Pochhammer[ap,n])/(Pochhammer[b1,n]·...·Pochhammer[bq,n]) · z^n/n!\n"];

Print["Our sum structure:"];
Print["  Σ[i=1 to k] 2^(i-1) · x^i · Pochhammer[k-i+1, 2i] / (2i)!\n"];

Print["Issues to resolve:"];
Print["  1. Index starts at i=1, not i=0"];
Print["  2. Pochhammer argument is k-i+1 (depends on i negatively)");
Print["  3. Pochhammer length is 2i (not i)");
Print["  4. Denominator is (2i)!, not i!"];
Print["  5. Power is 2^(i-1) · x^i, not just x^i\n"];

Print["Step 4: Change of variables"];
Print["============================\n"];

Print["Let j = i (keep same for now), examine term structure:\n"];

Do[
  term = factorialTerm[x, 3, i];
  Print["i=", i, ": ", term // Expand];
, {i, 1, 3}];
Print[];

Print["Step 5: Numerically verify Mathematica's result"];
Print["=================================================\n"];

Print["Mathematica claims:"];
Print["  Sum[terms] = -1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]]/(√2·√(2+x))\n"];

Print["Let's verify for k=3, x=2:"];
kval = 3; xval = 2;
factorialSum = 1 + Sum[factorialTerm[xval, kval, i], {i, 1, kval}];
hyperbolicForm = 1/2 + Cosh[(1+2*kval)*ArcSinh[Sqrt[xval/2]]]/(Sqrt[2]*Sqrt[2+xval]);

Print["  Factorial sum: ", N[factorialSum, 20]];
Print["  Hyperbolic form: ", N[hyperbolicForm, 20]];
Print["  Difference: ", N[factorialSum - hyperbolicForm, 20]];
Print[];

Print["Step 6: Symbolic Sum evaluation"];
Print["=================================\n"];

Print["Let Mathematica evaluate the sum symbolically:"];
kval = 3;
symbolicSum = 1 + Sum[factorialTerm[x, kval, i], {i, 1, kval}];
Print["  Result for k=3: ", symbolicSum // Simplify];
Print[];

hypForm = 1/2 + Cosh[7*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);
Print["  Hyperbolic form: ", hypForm];
Print["  Difference: ", (symbolicSum - hypForm) // FullSimplify];
Print[];

Print["Step 7: Analyze Mathematica's transformation"];
Print["=============================================\n"];

Print["Computing sum for general k (symbolic):"];
(* This will take time *)
Print["  (This uses Mathematica's internal HypergeometricPFQ transformation)\n"];

sumResult = 1 + Sum[factorialTerm[x, k, i], {i, 1, k}];
Print["  Mathematica result: ", sumResult];
Print[];

Print["Step 8: Next steps for hand derivation"];
Print["========================================\n"];

Print["To derive algebraically, we need to:"];
Print["  1. Rewrite sum in standard hypergeometric form"];
Print["  2. Use known transformation formulas for hypergeometric functions"];
Print["  3. Connect to hyperbolic functions via known identities\n"];

Print["Known connection (from literature):"];
Print["  Certain hypergeometric series with specific parameters"];
Print["  can be expressed as Cosh[n·ArcSinh[z]]\n"];

Print["We need to identify which hypergeometric function this is,"];
Print["and find the transformation formula in mathematical literature."];
