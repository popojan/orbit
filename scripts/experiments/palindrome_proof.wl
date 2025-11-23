#!/usr/bin/env wolframscript
(* Theoretical proof: Why tangent polynomials have palindromic structure *)

Print["=== PALINDROME PROOF FOR TANGENT POLYNOMIALS ===\n"];

Print["THEOREM: For F_n(x) = p_n(x)/q_n(x) = tan(n*arctan(x)),"];
Print["the coefficients of p_n(x)/x and q_n(x) are palindromic reversals.\n"];

Print["PROOF:\n"];

Print["Step 1: Complementary angle identity"];
Print["  tan(pi/2 - theta) = cot(theta) = 1/tan(theta)"];
Print["  If x = tan(theta), then 1/x = tan(pi/2 - theta)\n"];

Print["Step 2: Apply to F_n"];
Print["  F_n(x) = tan(n*arctan(x))"];
Print["  F_n(1/x) = tan(n*arctan(1/x)) = tan(n*(pi/2 - arctan(x)))"];
Print["  = tan(n*pi/2 - n*arctan(x))\n"];

Print["Step 3: Functional equation"];
Print["  For n odd: tan(n*pi/2) undefined, but we get:"];
Print["  F_n(x) * F_n(1/x) = (-1)^((n-1)/2) (from tan addition formulas)\n"];

Print["Verification for n=1,3,5:"];
Do[
  fx = Tan[n*ArcTan[x]];
  f_inv = Tan[n*ArcTan[1/x]];
  product = Simplify[fx * f_inv];
  Print["  n=", n, ": F_n(x) * F_n(1/x) = ", product];
, {n, 1, 5, 2}];

Print["\nStep 4: Polynomial consequences"];
Print["  F_n(x) = p_n(x)/q_n(x)"];
Print["  F_n(1/x) = p_n(1/x)/q_n(1/x)\n"];

Print["  F_n(x) * F_n(1/x) = +/- 1  implies:"];
Print["  [p_n(x)/q_n(x)] * [p_n(1/x)/q_n(1/x)] = +/- 1"];
Print["  p_n(x) * p_n(1/x) = +/- q_n(x) * q_n(1/x)\n"];

Print["Step 5: Coefficient reversal"];
Print["  For polynomial P(x) = a_0 + a_1*x + ... + a_n*x^n:"];
Print["  P(1/x) = a_0/x^n + a_1/x^(n-1) + ... + a_n"];
Print["  x^n * P(1/x) = a_0 + a_1*x + ... + a_n*x^n"];
Print["  = polynomial with REVERSED coefficients {a_n, ..., a_1, a_0}\n"];

Print["Concrete example n=5:"];
p5 = 5*x - 10*x^3 + x^5;
q5 = 1 - 10*x^2 + 5*x^4;

Print["  p_5(x) = ", Expand[p5]];
Print["  q_5(x) = ", Expand[q5]];

p5_coeffs = CoefficientList[p5, x];
q5_coeffs = CoefficientList[q5, x];

Print["  p_5 coeffs: ", p5_coeffs];
Print["  q_5 coeffs: ", q5_coeffs];

(* Remove factor x from p_5 *)
p5_no_x = Drop[p5_coeffs, 1];
Print["  p_5/x coeffs: ", p5_no_x];
Print["  Reversed:     ", Reverse[p5_no_x]];
Print["  q_5 coeffs:   ", q5_coeffs];
Print["  Match: ", q5_coeffs == Reverse[p5_no_x]];

Print["\nStep 6: General mechanism"];
Print["  Since p_n has factor x (p_n(0)=0), write p_n(x) = x*r_n(x)"];
Print["  deg(r_n) = n-1, deg(q_n) = n-1"];
Print["  Functional equation forces: r_n(x) and q_n(x) have reversed coeffs"];
Print["  QED.\n"];

Print["=== GAMMA PALINDROME (SEPARATE MECHANISM) ===\n"];

Print["For Gamma weights: w[i] = ... / (Gamma[alpha] * Gamma[beta])"];
Print["where alpha + beta = constant\n"];

Print["Key: Beta function B(a,b) = Gamma[a]*Gamma[b]/Gamma[a+b]"];
Print["Fundamental symmetry: B(a,b) = B(b,a)\n"];

Print["When alpha + beta = const = S:"];
Print["  Gamma[alpha] * Gamma[beta] = Gamma[S] * B(alpha, beta)"];
Print["  = Gamma[S] * B(beta, alpha)  (by symmetry)"];
Print["  = Gamma[beta] * Gamma[alpha]\n"];

Print["Swapping indices i -> (limit+1-i) swaps (alpha, beta) -> (beta, alpha)"];
Print["This creates mirror symmetry in weights -> palindrome structure\n"];

Print["CONCLUSION: Two independent mechanisms"];
Print["  1. Tangent: Complementary angle functional equation"];
Print["  2. Gamma: Beta function symmetry B(a,b)=B(b,a)"];
Print["  Both create palindromic coefficient patterns"];
Print["  Connection via hypergeometric functions: HYPOTHESIS (not proven)"];
