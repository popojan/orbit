#!/usr/bin/env wolframscript
(* Systematic coefficient derivation k=4 *)

Print["=== SYSTEMATIC COEFFICIENT DERIVATION k=4 ===\n"];

(* For k=4: n=2, m=2 *)
k = 4;
n = Ceiling[k/2];  (* n=2 *)
m = Floor[k/2];     (* m=2 *)

Print["k=", k, ", n=", n, ", m=", m];
Print[];

(* Step 1: Expand T_n(x+1) explicitly *)
Print["Step 1: T_", n, "(x+1)"];
Print["===================\n"];

tn = ChebyshevT[n, x+1] // Expand;
Print["T_", n, "(x+1) = ", tn];

tnCoeffs = CoefficientList[tn, x];
Print["Coefficients: ", tnCoeffs];
Print[];

(* Step 2: Expand U_m(x+1) *)
Print["Step 2: U_", m, "(x+1)"];
Print["===================\n"];

um = ChebyshevU[m, x+1] // Expand;
Print["U_", m, "(x+1) = ", um];

umCoeffs = CoefficientList[um, x];
Print["Coefficients: ", umCoeffs];
Print[];

(* Step 3: Expand U_{m-1}(x+1) *)
Print["Step 3: U_", m-1, "(x+1)"];
Print["=====================\n"];

umPrev = ChebyshevU[m-1, x+1] // Expand;
Print["U_", m-1, "(x+1) = ", umPrev];

umPrevCoeffs = CoefficientList[umPrev, x];
Print["Coefficients: ", umPrevCoeffs];
Print[];

(* Step 4: Compute U_m - U_{m-1} *)
Print["Step 4: U_", m, "(x+1) - U_", m-1, "(x+1)"];
Print["========================================\n"];

diff = um - umPrev // Expand;
Print["Difference = ", diff];

diffCoeffs = CoefficientList[diff, x];
Print["Coefficients: ", diffCoeffs];
Print[];

(* Step 5: Compute product *)
Print["Step 5: T_", n, "(x+1) * (U_", m, " - U_", m-1, ")"];
Print["=============================================\n"];

product = tn * diff // Expand;
Print["Product = ", product];

prodCoeffs = CoefficientList[product, x];
Print["Coefficients: ", prodCoeffs];
Print[];

(* Step 6: Factorial form *)
Print["Step 6: Factorial form"];
Print["======================\n"];

factForm = 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}] // Expand;
Print["Factorial = ", factForm];

factCoeffs = CoefficientList[factForm, x];
Print["Coefficients: ", factCoeffs];
Print[];

(* Step 7: Compare *)
Print["Step 7: Comparison"];
Print["==================\n"];

Print["Chebyshev coeffs: ", prodCoeffs];
Print["Factorial coeffs: ", factCoeffs];
Print["Match: ", prodCoeffs == factCoeffs];
Print[];

(* Step 8: Analyze coefficient pattern *)
Print["Step 8: Coefficient pattern analysis"];
Print["=====================================\n"];

Do[
  If[i < Length[factCoeffs],
    factCoeff = factCoeffs[[i+1]];  (* i+1 because list is 1-indexed *)
    chebCoeff = If[i < Length[prodCoeffs], prodCoeffs[[i+1]], 0];

    Print["x^", i, ":"];
    Print["  Factorial: ", factCoeff];

    If[i > 0,
      (* Compute factorial formula directly *)
      directFact = 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
      Print["  Direct factorial formula: ", directFact];
    ];

    Print["  Chebyshev: ", chebCoeff];
    Print["  Match: ", factCoeff == chebCoeff];
    Print[];
  ];
, {i, 0, k}];

Print["=== CONCLUSION FOR k=4 ==="];
Print["Coefficients match exactly: ", prodCoeffs == factCoeffs];
