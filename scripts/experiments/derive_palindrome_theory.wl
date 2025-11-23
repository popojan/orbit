#!/usr/bin/env wolframscript
(* Theoretical derivation: Why palindromic structures? *)

Print["=== PART 1: TANGENT MULTIPLICATION PALINDROMES ===\n"];

(* Define tan(ntheta) via Chebyshev *)
(* tan(ntheta) = sin(ntheta)/cos(ntheta) = [sin(theta)·U_{n-1}(cos theta)] / [T_n(cos theta)] *)

Print["For x = tan(theta), we have cos(theta) = 1/√(1+x²)"];
Print["Substitution: c = 1/√(1+x²), then x² = (1-c²)/c²"];
Print[""];

Print["Key insight: Symmetric substitution"];
Print["If we parametrize by tan instead of angle, we get rational functions"];
Print[""];

(* Extract polynomial forms *)
Print["Generating tan(ntheta) = P_n(x)/Q_n(x) for n=1..5:");
Print[""];

tanPoly[n_, x_] := Module[{},
  (* Use Chebyshev formula and convert to tan parametrization *)
  expr = Together[Tan[n*ArcTan[x]]];
  {Numerator[expr], Denominator[expr]}
];

Do[
  {num, den} = tanPoly[n, x];
  numCoeffs = CoefficientList[num, x];
  denCoeffs = CoefficientList[den, x];

  Print["n = ", n, ":"];
  Print["  P_", n, "(x) = ", Expand[num]];
  Print["  Q_", n, "(x) = ", Expand[den]];
  Print["  P coeffs: ", numCoeffs];
  Print["  Q coeffs: ", denCoeffs];

  (* Check if coefficients are palindromic *)
  If[Length[numCoeffs] > 1,
    (* P_n has factor x, remove it *)
    numNoX = Drop[numCoeffs, 1];
    isPalindrome = (numNoX == Reverse[denCoeffs]) || (numNoX == -Reverse[denCoeffs]);
    Print["  Palindrome P/x ↔ Q: ", isPalindrome];
  ];
  Print[""];
, {n, 1, 5}];

Print["\n=== THEORETICAL EXPLANATION: TAN PALINDROMES ===\n"];

Print["WHY PALINDROMIC?"];
Print[""];
Print["Observation: tan(theta) and tan(π/2 - theta) are reciprocals"];
Print["  tan(π/2 - theta) = cot(theta) = 1/tan(theta)"];
Print[""];
Print["This creates inversion symmetry in the formulas."];
Print[""];

Print["For x = tan(theta), consider transformation x → 1/x (inversion)"];
Print["This maps theta → π/2 - theta (complementary angle)"];
Print[""];

Print["Testing inversion property for tan(ntheta):"];
Do[
  tn_x = Tan[n*ArcTan[x]];
  tn_inv = Tan[n*ArcTan[1/x]];

  (* Simplify the relationship *)
  ratio = Simplify[tn_x * tn_inv];

  Print["n = ", n, ": tan(n·arctan(x)) · tan(n·arctan(1/x)) = ", ratio];
, {n, 1, 5}];

Print[""];
Print["PALINDROME MECHANISM:"];
Print["If P_n(x)/Q_n(x) satisfies f(x)·f(1/x) = ±1, then:"];
Print["  P_n(x)/Q_n(x) · P_n(1/x)/Q_n(1/x) = ±1"];
Print["  ⇒ P_n(x)P_n(1/x) = ±Q_n(x)Q_n(1/x)"];
Print[""];
Print["Under substitution x → 1/x in polynomial:"];
Print["  P(x) = a₀ + a₁x + ... + aₙx^n");
Print["  P(1/x) = a₀/x^n + a₁/x^{n-1} + ... + aₙ");
Print["  x^n·P(1/x) = a₀ + a₁x + ... + aₙx^n (reversed coeffs!)");
Print[""];

Print["Therefore: x^n·P(1/x) has REVERSED coefficients of P(x)"];
Print["The functional equation forces palindromic structure!");
Print[""];

Print["\n=== PART 2: GAMMA PALINDROMES ===\n"];

Print["Weights: w[i] = n^(a-2i)·nn^i / (Γ(b+2i)·Γ(c-2i))"];
Print["where b + (c-2i+2i) = b + c = constant"];
Print[""];

Print["Key: Beta function symmetry"];
Print["  B(p,q) = Γ(p)Γ(q)/Γ(p+q)");
Print["  B(p,q) = B(q,p)  (fundamental symmetry)");
Print[""];

Print["Our weights with Γ(α)·Γ(β) where α+β = const:");
Print[""];

k = 5;
Do[
  alpha = -1 + 2*i;
  beta = 4 - 2*i + k;
  sum = alpha + beta;

  Print["i=", i, ": Γ(", alpha, ")·Γ(", beta, "), sum = ", sum];
, {i, 1, 4}];

Print[""];
Print["Sum is CONSTANT = 3+k"];
Print[""];

Print["BETA FUNCTION REWRITE:"];
Print["  Γ(α)·Γ(β) = Γ(α+β)·B(α,β)"];
Print["  When α+β = const, this is proportional to B(α,β)"];
Print[""];
Print["Since B(α,β) = B(β,α), swapping indices gives:");
Print["  Γ(α_i)·Γ(β_i) ∝ Γ(β_i)·Γ(α_i)");
Print[""];

Print["For our construction:");
Print["  i → (lim+1-i) swaps (α,β) → (β,α)");
Print["  This creates MIRROR SYMMETRY in weights");
Print[""];

Print["\n=== PART 3: COMMON PRINCIPLE? ===\n"];

Print["QUESTION: Are Chebyshev tan and Gamma sqrt palindromes related?"];
Print[""];

Print["CANDIDATE CONNECTION: Hypergeometric functions"];
Print[""];
Print["Chebyshev polynomials can be expressed via hypergeometric 2F1"];
Print["  T_n(x) = ₂F₁(-n, n; 1/2; (1-x)/2)");
Print["  U_n(x) = (n+1) ₂F₁(-n, n+2; 3/2; (1-x)/2)");
Print[""];

Print["Hypergeometric ₂F₁(a,b;c;z) has Gamma functions in series:"];
Print["  ₂F₁(a,b;c;z) = Σ [Γ(a+k)Γ(b+k)Γ(c)]/[Γ(a)Γ(b)Γ(c+k)] · z^k/k!"];
Print[""];

Print["Beta function also appears in hypergeometric:"];
Print["  Integral representations involve Beta integrals"];
Print[""];

Print["HYPOTHESIS: Both palindromes arise from:"];
Print["  1. Symmetry in hypergeometric parameters"];
Print["  2. Beta function symmetry B(a,b) = B(b,a)"];
Print["  3. Inversion/reflection symmetries in the underlying functions"];
Print[""];

Print["VERIFICATION NEEDED:"];
Print["  - Express tan(ntheta) formula via hypergeometric"];
Print["  - Express Gamma weights via hypergeometric"];
Print["  - Show both reduce to same symmetry principle"];
Print[""];

Print["STATUS: Plausible common origin, but not yet proven"];
