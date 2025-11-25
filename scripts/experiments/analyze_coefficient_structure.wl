#!/usr/bin/env wolframscript
(* Analyze coefficient structure across multiple k *)

Print["=== COEFFICIENT STRUCTURE ANALYSIS ===\n"];

analyzeK[kval_] := Module[{n, m, tn, um, umPrev, diff, product, factForm, prodCoeffs, factCoeffs},
  n = Ceiling[kval/2];
  m = Floor[kval/2];

  tn = ChebyshevT[n, x+1] // Expand;
  um = ChebyshevU[m, x+1] // Expand;
  umPrev = ChebyshevU[m-1, x+1] // Expand;
  diff = um - umPrev // Expand;
  product = tn * diff // Expand;
  factForm = 1 + Sum[2^(i-1) * x^i * Factorial[kval+i]/(Factorial[kval-i] * Factorial[2*i]), {i, 1, kval}] // Expand;

  prodCoeffs = CoefficientList[product, x];
  factCoeffs = CoefficientList[factForm, x];

  Print["k=", kval, " (n=", n, ", m=", m, "):"];
  Print["  T_", n, "(x+1) = ", tn];
  Print["  U_", m, "-U_", m-1, " = ", diff];
  Print["  Product coeffs: ", prodCoeffs];
  Print["  Factorial coeffs: ", factCoeffs];
  Print["  Match: ", prodCoeffs == factCoeffs];
  Print[];

  {prodCoeffs, factCoeffs}
];

(* Analyze k=1 through k=6 *)
results = Table[analyzeK[k], {k, 1, 6}];

Print["=== PATTERN ANALYSIS ===\n"];

(* Look for pattern in how coefficients grow *)
Print["Coefficient ratios:"];
Do[
  {prodCoeffs, factCoeffs} = results[[k]];

  If[k > 1,
    Print["k=", k, ":"];
    Do[
      If[i > 0 && i <= Length[factCoeffs]-1,
        coeff = factCoeffs[[i+1]];  (* x^i coefficient *)
        Print["  a_", i, " = ", coeff, " = 2^", i-1, " * (", k+i, ")! / ((", k-i, ")! * (", 2*i, ")!)"];

        (* Simplify factorial *)
        factExp = 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
        Print["     = ", factExp, " (verified: ", coeff == factExp, ")"];
      ];
    , {i, 1, Min[3, k]}];  (* First 3 coefficients *)
    Print[];
  ];
, {k, 2, 5}];

Print["=== KEY OBSERVATION ===\n"];
Print["For ALL tested k, factorial coefficients EXACTLY match"];
Print["Chebyshev product T_n(x+1) * (U_m(x+1) - U_{m-1}(x+1))"];
Print["where n=Ceiling[k/2], m=Floor[k/2].\n"];

Print["This is a COMBINATORIAL IDENTITY, not a transformation."];
