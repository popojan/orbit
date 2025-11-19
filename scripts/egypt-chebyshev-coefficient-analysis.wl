#!/usr/bin/env wolframscript
(* Analysis of coefficient structure for Egypt-Chebyshev equivalence *)

(* Define Chebyshev polynomials *)
T[n_, y_] := ChebyshevT[n, y]
U[n_, y_] := ChebyshevU[n, y]

(* Define the product polynomial *)
P[j_, x_] := Module[{y, n1, n2},
  y = x + 1;
  n1 = Ceiling[j/2];
  n2 = Floor[j/2];
  Expand[T[n1, y] * (U[n2, y] - U[n2-1, y])]
]

(* Target binomial formula *)
Binomial Formula[j_, x_] := 1 + Sum[2^(i-1) * Binomial[j+i, 2*i] * x^i, {i, 1, j}]

(* Extract coefficients *)
ExtractCoeffs[j_] := Module[{poly, coeffs},
  poly = P[j, x];
  coeffs = Table[Coefficient[poly, x, i], {i, 0, j}];
  coeffs
]

(* Compare with binomial formula coefficients *)
CompareCoeffs[j_] := Module[{chebyCoeffs, binomCoeffs, target},
  chebyCoeffs = ExtractCoeffs[j];
  target = BinomialFormula[j, x];
  binomCoeffs = Table[Coefficient[target, x, i], {i, 0, j}];

  Print["j = ", j];
  Print["Chebyshev coefficients: ", chebyCoeffs];
  Print["Binomial coefficients:  ", binomCoeffs];
  Print["Match: ", chebyCoeffs == binomCoeffs];
  Print[""];

  {chebyCoeffs, binomCoeffs}
]

(* Analyze pattern in coefficient ratios *)
AnalyzeRatios[j_] := Module[{coeffs, ratios},
  coeffs = ExtractCoeffs[j];
  ratios = Table[coeffs[[i+1]]/coeffs[[i]], {i, 1, j}];
  Print["j = ", j, " coefficient ratios:"];
  Print[ratios // Simplify];
  Print[""];
]

(* Look for factorial structure in individual coefficients *)
AnalyzeFactorialStructure[j_] := Module[{coeffs, i},
  coeffs = ExtractCoeffs[j];
  Print["j = ", j, " factorial analysis:"];
  For[i = 1, i <= j, i++,
    Print["  c[", i, "] = ", coeffs[[i+1]], " = ",
      FactorInteger[coeffs[[i+1]]],
      "  Target: ", 2^(i-1) * Binomial[j+i, 2*i]]
  ];
  Print[""];
]

(* Main analysis *)
Print["=== Egypt-Chebyshev Coefficient Structure Analysis ===\n"];

(* Verify j=1 through j=7 *)
Do[CompareCoeffs[j], {j, 1, 7}];

Print["\n=== Coefficient Ratios ===\n"];
Do[AnalyzeRatios[j], {j, 2, 7}];

Print["\n=== Factorial Structure ===\n"];
Do[AnalyzeFactorialStructure[j], {j, 1, 7}];

(* Try to find recurrence in coefficients *)
Print["\n=== Searching for recurrence pattern ===\n"];

(* For each j, look at how coefficients relate to j-1 *)
AnalyzeRecurrence[jmax_] := Module[{prevCoeffs, currCoeffs, j},
  prevCoeffs = ExtractCoeffs[1];
  For[j = 2, j <= jmax, j++,
    currCoeffs = ExtractCoeffs[j];
    Print["P[", j, "] vs P[", j-1, "]:"];

    (* Check if there's a simple transformation *)
    Print["  Length: ", Length[currCoeffs], " vs ", Length[prevCoeffs]];
    Print["  Leading coeff ratio: ", currCoeffs[[-1]]/prevCoeffs[[-1]] // Simplify];
    Print[""];

    prevCoeffs = currCoeffs;
  ];
]

AnalyzeRecurrence[7];

(* Analyze the difference operator ΔU structure *)
Print["\n=== Delta U structure ===\n"];
AnalyzeDeltaU[j_] := Module[{y, n, deltaU},
  y = x + 1;
  n = Floor[j/2];
  deltaU = Expand[U[n, y] - U[n-1, y]];
  Print["j = ", j, ": ΔU_", j, "(x+1) = U_", n, "(x+1) - U_", n-1, "(x+1)"];
  Print["  = ", deltaU];
  Print["  Coefficients: ", Table[Coefficient[deltaU, x, i], {i, 0, Exponent[deltaU, x]}]];
  Print[""];
]

Do[AnalyzeDeltaU[j], {j, 1, 7}];
