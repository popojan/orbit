#!/usr/bin/env wolframscript
(* Search for master hypergeometric function *)

Print["=== SEARCHING FOR MASTER HYPERGEOMETRIC FUNCTION ===\n"];

(* Strategy: Look at structure of all three formulations *)

Print["=== PART 1: CHEBYSHEV AS HYPERGEOMETRIC ===\n"];

(* Known representations *)
Print["Standard Chebyshev representations:"];
Print["T_n(x) = n * HypergeometricPFQ[{-n, n}, {1/2}, (1-x)/2]"];
Print["U_n(x) = (n+1) * HypergeometricPFQ[{-n, n+2}, {3/2}, (1-x)/2]\n"];

(* Verify for small n *)
Do[
  tn_formula = n * HypergeometricPFQ[{-n, n}, {1/2}, (1-x)/2];
  tn_standard = ChebyshevT[n, x];
  match = Simplify[tn_formula - tn_standard] == 0;
  Print["T_", n, "(x): Match = ", match];
, {n, 1, 3}];

Print[""];

Do[
  un_formula = (n+1) * HypergeometricPFQ[{-n, n+2}, {3/2}, (1-x)/2];
  un_standard = ChebyshevU[n, x];
  match = Simplify[un_formula - un_standard] == 0;
  Print["U_", n, "(x): Match = ", match];
, {n, 1, 3}];

Print["\n=== PART 2: SHIFTED CHEBYSHEV ===\n"];

Print["We use shifted version T_n(x+1) and U_n(x+1)"];
Print["Argument becomes: (1-(x+1))/2 = -x/2\n"];

(* Check what happens with shift *)
Do[
  tn_shifted = ChebyshevT[n, x+1];
  tn_hypergeom = n * HypergeometricPFQ[{-n, n}, {1/2}, -x/2];
  match = Simplify[tn_shifted - tn_hypergeom] == 0;
  Print["T_", n, "(x+1) = n*2F1({-n,n},{1/2},-x/2): ", match];
, {n, 1, 3}];

Print["\n=== PART 3: EGYPT FACTORIALTERM STRUCTURE ===\n"];

(* FactorialTerm denominator *)
factorialDenom[x_, j_] := 1 + Sum[2^(i-1) * x^i * Factorial[j+i] /
                                   (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

Print["FactorialTerm[x, j] = 1 / (1 + sum)"];
Print["Let's look at the sum for j=1,2,3:\n"];

Do[
  denom = factorialDenom[x, j];
  Print["j=", j, ": denominator = ", Expand[denom]];

  (* Try to recognize as hypergeometric *)
  (* Sum starts at i=1, not i=0, so shift index *)
  Print["  Trying to match to hypergeometric pattern..."];

  (* Coefficient at x^i: 2^(i-1) * (j+i)!/((j-i)!*(2i)!) *)
  (* For i=1: 2^0 * (j+1)!/(j-1)!*2! = (j+1)*j / 2 *)
  Print["  Coeff x^1: ", 2^0 * Factorial[j+1]/(Factorial[j-1]*Factorial[2])];

, {j, 1, 3}];

Print["\n=== PART 4: LOOKING FOR PATTERNS ===\n"];

(* Compare coefficient structures *)
Print["Hypergeometric 2F1 coefficient:"];
Print["  C_k = (a)_k * (b)_k / ((c)_k * k!)"];
Print["  where (a)_k = Gamma[a+k]/Gamma[a]\n"];

Print["Egypt coefficient (i-th term):"];
Print["  C_i = 2^(i-1) * (j+i)!/((j-i)! * (2i)!)"];
Print["      = 2^(i-1) * Gamma[j+i+1]/(Gamma[j-i+1] * Gamma[2i+1])\n"];

Print["Trying to match:");
Print["  (a)_i * (b)_i / (c)_i = Gamma[a+i]*Gamma[b+i]*Gamma[c] / (Gamma[a]*Gamma[b]*Gamma[c+i])"];
Print["  Egypt has: Gamma[j+i+1] / (Gamma[j-i+1] * Gamma[2i+1])"];
Print["  Plus factor 2^(i-1)\n"];

(* Try specific values *)
Print["For j=1, coefficient of x^1:"];
j = 1;
i = 1;
coeff = 2^(i-1) * Factorial[j+i]/(Factorial[j-i]*Factorial[2*i]);
Print["  Egypt: ", coeff];
Print["  = ", N[coeff]];

Print["\nTrying Pochhammer interpretation:"];
(* (a)_i = a*(a+1)*...*(a+i-1) *)
(* Want: some combination that gives (j+i)! / ((j-i)! * (2i)!) *)

Print["  (j+i)! / (j-i)! = (j-i+1)*(j-i+2)*...*(j+i)"];
Print["  This is Pochhammer (j-i+1)_{2i}\n"];

Print["  So: (j+i)!/((j-i)!*(2i)!) = (j-i+1)_{2i} / (2i)!"];
Print["                            = (j-i+1)_{2i} / Gamma[2i+1]\n"];

Print["=== PART 5: GENERALIZED HYPERGEOMETRIC? ===\n"];

Print["Egypt sum has TWO Gamma functions in denominator (like 2F1)"];
Print["But also has 2^(i-1) factor..."];
Print[""];

Print["Consider pFq with p=2, q=2 (so 2F2):"];
Print["  2F2({a,b}, {c,d}, z) = Sum[(a)_k*(b)_k / ((c)_k*(d)_k*k!)] * z^k"];
Print[""];

Print["Or maybe 3F2 to have more freedom:"];
Print["  3F2({a,b,e}, {c,d}, z) = Sum[(a)_k*(b)_k*(e)_k / ((c)_k*(d)_k*k!)] * z^k"];
Print[""];

(* Test if we can express Egypt as generalized hypergeometric *)
Print["Testing for j=1:"];
j = 1;
egyptSum = Sum[2^(i-1) * x^i * Factorial[j+i]/(Factorial[j-i]*Factorial[2*i]), {i, 1, j}];
Print["  Egypt sum = ", egyptSum];
Print["  = ", Expand[egyptSum]];

(* Try to match to hypergeometric *)
(* For i=1: x * (j+1)! / ((j-1)! * 2!) = x * j*(j+1)/2 *)
(* For j=1: x * 1*2/2 = x *)

Print["\nFor j=1: sum = x, so 1/(1+x) = 1/(1+x)"];
Print["This is geometric series: Sum[(-x)^k, {k,0,∞}] = 2F1[{1,1},{1},-x]\n"];

Print["=== PART 6: INVESTIGATING THE 2^(i-1) FACTOR ===\n"];

Print["The 2^(i-1) factor is unusual for standard hypergeometric."];
Print["But: 2^(i-1) * x^i = (2x)^i / 2"];
Print["So we can absorb it into the argument!\n"];

Print["Egypt sum = Sum[2^(i-1) * x^i * coeff_i]"];
Print["          = (1/2) * Sum[(2x)^i * coeff_i]"];
Print["          = (1/2) * [hypergeom in 2x]\n"];

Print["Testing for j=1:");
j = 1;
(* Sum starts at i=1, coefficient is (j+i)!/((j-i)!*(2i)!) *)
(* For j=1, i=1: 2!/0!*2! = 2/2 = 1 *)
egyptSum = Sum[2^(i-1) * x^i * Factorial[j+i]/(Factorial[j-i]*Factorial[2*i]), {i, 1, j}];
egyptSumRewritten = (1/2) * Sum[(2*x)^i * Factorial[j+i]/(Factorial[j-i]*Factorial[2*i]), {i, 1, j}];
Print["  Original:  ", Expand[egyptSum]];
Print["  Rewritten: ", Expand[egyptSumRewritten]];
Print["  Match: ", Simplify[egyptSum - egyptSumRewritten] == 0];

Print["\n=== PART 7: LOOKING FOR MASTER FUNCTION ===\n"];

Print["Hypothesis: All three are related by:"];
Print["  1) Parameter specialization"];
Print["  2) Argument transformation"];
Print["  3) Product/ratio operations"];
Print[""];

Print["Chebyshev uses 2F1 with:"];
Print["  - Parameters: {-n, n} or {-n, n+2}"];
Print["  - Denominator: {1/2} or {3/2}"];
Print["  - Argument: (1-x)/2 or shifted -x/2"];
Print[""];

Print["Egypt might use higher pFq or product of 2F1's"];
Print["  - FactorialTerm = 1/(T * ΔU) suggests product structure"];
Print[""];

Print["Gamma weights have Beta function B(a,b)");
Print["  - B(a,b) relates to 2F1 via integral representation"];
Print["  - Integral of t^(a-1)*(1-t)^(b-1) = Beta integral");
Print[""];

Print["CANDIDATE: All are transformations/evaluations of Appell functions?"];
Print["  Appell F1(a,b,b',c;x,y) = hypergeometric in TWO variables"];
Print["  Specialization to diagonal x=y might give our structures\n"];

Print["Or: Gauss continued fraction representation of 2F1?"];
Print["  2F1 has continued fraction expansion"];
Print["  Might explain CF vs Egypt difference\n"];

Print["=== CONCLUSION ===\n"];

Print["Promising directions:"];
Print["1. Express Egypt as 3F2 or 2F2 with transformed argument"];
Print["2. Product structure: FactorialTerm = product of 2F1's"];
Print["3. Appell functions (2-variable hypergeometric)"];
Print["4. Continued fraction representation"];
Print[""];

Print["Next step: Try explicit construction for j=2,3 to find pattern"];
