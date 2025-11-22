#!/usr/bin/env wolframscript
(* Explore the triple identity *)

<< Orbit`

Print["TRIPLE IDENTITY EXPLORATION\n"];
Print[StringRepeat["=", 70]];
Print[];

Print["Identity: Three equal expressions for FactorialTerm[x, k]\n"];

Print["1. FACTORIAL (Combinatorics):"];
Print["   Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!), {i,1,k}]"];
Print[];

Print["2. CHEBYSHEV (Orthogonal polynomials):"];
Print["   ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])"];
Print[];

Print["3. HYPERBOLIC (Geometry):"];
Print["   1/2 + Cosh[(1+2k)·ArcSinh[√x/√2]] / (√2·√(2+x))"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

(* What does this imply? *)
Print["IMPLICATIONS:\n"];

Print["A. FACTORIAL = CHEBYSHEV"];
Print["   Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!), {i,1,k}]"];
Print["   = ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])"];
Print[];
Print["   → NEW IDENTITY for Chebyshev polynomials!");
Print["   → Factorial sum equals polynomial product");
Print[];

Print["B. FACTORIAL = HYPERBOLIC"];
Print["   Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!), {i,1,k}]"];
Print["   = 1/2 + Cosh[(1+2k)·ArcSinh[√x/√2]] / (√2·√(2+x))"];
Print[];
Print["   → Finite sum has CLOSED hyperbolic form"];
Print["   → Connection to hyperbolic geometry");
Print[];

Print["C. CHEBYSHEV = HYPERBOLIC"];
Print["   ChebyshevT[⌈k/2⌉, x+1] * (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1])"];
Print["   = 1/2 + Cosh[(1+2k)·ArcSinh[√x/√2]] / (√2·√(2+x))"];
Print[];
Print["   → NEW hyperbolic representation of Chebyshev products!");
Print["   → Bridge between orthogonal polynomials and hyperbolic functions"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

(* Test specific cases *)
Print["VERIFICATION (k=2, various x):\n"];
k = 2;
Do[
  fact = N[Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}], 10];
  cheb = N[ChebyshevT[Ceiling[k/2], x+1] *
           (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]), 10];
  hyp = N[1/2 + Cosh[(1 + 2*k)*ArcSinh[Sqrt[x]/Sqrt[2]]]/(Sqrt[2]*Sqrt[2 + x]), 10];

  Print["x=", N[x,3], ": Fact=", fact, ", Cheb=", cheb, ", Hyp=", hyp];
, {x, {1/2, 1, 2, 5, 10}}];
Print[];

(* Look for patterns *)
Print["PATTERN ANALYSIS:\n"];
Print["Examining the Chebyshev-Hyperbolic connection...\n"];

(* Chebyshev polynomials have representation via cos *)
(* ChebyshevT[n, x] = cos(n * arccos(x)) for |x| <= 1 *)
(* ChebyshevU[n, x] = sin((n+1) * arccos(x)) / sin(arccos(x)) for |x| <= 1 *)

Print["Standard Chebyshev representations use CIRCULAR functions (cos, sin)"];
Print["Our identity uses HYPERBOLIC functions (Cosh, ArcSinh)"];
Print[];
Print["Connection: Analytic continuation?"];
Print["  cos(iz) = Cosh(z)"];
Print["  arcsin(iz) = i·ArcSinh(z)");
Print[];

(* Test the polynomial degree *)
Print["POLYNOMIAL DEGREE:\n"];
Do[
  fact = Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
  chebExpr = ChebyshevT[Ceiling[k/2], x+1] *
             (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

  degFact = Exponent[fact, x];
  degCheb = Exponent[Expand[chebExpr], x];

  Print["k=", k, ": Factorial degree=", degFact, ", Chebyshev degree=", degCheb];
, {k, 1, 6}];
Print[];

(* Can we derive one from another? *)
Print["DERIVATION QUESTION:\n"];
Print["Given the Chebyshev form, can we derive the hyperbolic form algebraically?"];
Print["Or is this a NUMERICAL coincidence that needs proof?\n"];

Print["Testing if relationship holds for ALL x (symbolically):\n"];
k = 2;
factSym = Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
chebSym = ChebyshevT[Ceiling[k/2], x+1] *
          (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Factorial form: ", factSym];
Print["Chebyshev form: ", Expand[chebSym]];
Print["Equal? ", Simplify[factSym - Expand[chebSym]] == 0];
Print[];

Print["CONCLUSION:\n"];
Print["This triple identity is NOT trivial and may reveal:"];
Print["  1. New generating functions for Chebyshev polynomials"];
Print["  2. Hyperbolic representation theorems"];
Print["  3. Connections between combinatorics and geometry");
Print["  4. Possible algebraic proof of Egypt-Chebyshev equivalence"];
Print[];

Print["DONE!");
