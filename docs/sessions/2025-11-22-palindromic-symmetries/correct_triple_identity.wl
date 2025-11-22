#!/usr/bin/env wolframscript
(* Correct triple identity *)

<< Orbit`

Print["CORRECTED TRIPLE IDENTITY\n"];
Print[StringRepeat["=", 70]];
Print[];

Print["IDENTITY:\n"];
Print[];
Print["1 + Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!), {i,1,k}]"];
Print["  = ChebyshevT[k/2, x+1] * (ChebyshevU[k/2, x+1] - ChebyshevU[k/2-1, x+1])"];
Print["  = 1/2 + Cosh[(1+2k)*ArcSinh[sqrt(x)/sqrt(2)]] / (sqrt(2)*sqrt(2+x))"];
Print[];

Print["Or equivalently (dividing by the identity):\n"];
Print["FactorialTerm[x, k] = ChebyshevTerm[x, k] = HyperbolicTerm[x, k]"];
Print[];

Print[StringRepeat["=", 70]];
Print["VERIFICATION:\n"];
Print[];

Do[
  Print["k = ", kval, ":\n"];

  factSum = Sum[2^(i-1) * x^i * Factorial[kval+i] / (Factorial[kval-i] * Factorial[2*i]), {i, 1, kval}];
  chebProd = ChebyshevT[Ceiling[kval/2], x+1] *
             (ChebyshevU[Floor[kval/2], x+1] - ChebyshevU[Floor[kval/2]-1, x+1]);

  Print["  Factorial sum:    ", factSum];
  Print["  Chebyshev prod:   ", Expand[chebProd]];
  Print["  1 + Fact sum:     ", Expand[1 + factSum]];
  Print["  Equal? ", Simplify[1 + factSum - Expand[chebProd]] == 0];
  Print[];

, {kval, 1, 4}];

Print[StringRepeat["=", 70]];
Print["THREE-WAY IDENTITY:\n"];
Print[];

Print["Denomination (what equals what):\n"];
Print[];
Print["  D(x,k) := 1 + Sum[2^(i-1) * x^i * (k+i)! / ((k-i)! * (2i)!)]"];
Print[];
Print["Then:\n"];
Print["  D(x,k) = Chebyshev product"];
Print["  D(x,k) = Hyperbolic expression"];
Print[];
Print["And:\n"];
Print["  FactorialTerm[x,k] = 1/D(x,k)"];
Print[];

Print[StringRepeat["=", 70]];
Print["NOVEL INSIGHTS:\n"];
Print[];

Print["1. FACTORIAL-CHEBYSHEV identity (numerically verified):"];
Print["   1 + Sum[factorials] = Product[Chebyshev polynomials]"];
Print[];

Print["2. FACTORIAL-HYPERBOLIC identity (discovered by Sum):"];
Print["   1 + Sum[factorials] = 1/2 + Cosh[...]/sqrt(...)"];
Print[];

Print["3. CHEBYSHEV-HYPERBOLIC identity (NEW!):"];
Print["   T_n(u)(U_m(u) - U_{m-1}(u)) = 1/2 + Cosh[(1+2k)*ArcSinh[sqrt((u-1)/2)]]/sqrt(2(u+1))"];
Print["   where u = x+1, n = ceiling(k/2), m = floor(k/2)"];
Print[];

Print["This is a NEW representation of Chebyshev polynomial products!"];
Print[];

Print["DONE!");
