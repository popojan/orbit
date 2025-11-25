#!/usr/bin/env wolframscript
(* Fix coefficient extraction formulas *)

Print["=== FIXING COEFFICIENT FORMULAS ===\n"];

(* Mason & Handscomb formula - need to verify this *)
tnCoeffMH[n_, j_] := Module[{},
  If[n == 0, Return[1]];  (* Special case T_0 = 1 *)
  If[j > Floor[n/2], Return[0]];  (* Out of range *)
  (-1)^j * 2^(n-2*j-1) * Binomial[n, n-j] / Binomial[n-j, j]
];

(* MathWorld formula for U_n *)
unCoeffMW[n_, r_] := Module[{},
  If[n < 0, Return[0]];  (* U_{-1} = 0 *)
  If[r > Floor[n/2], Return[0]];  (* Out of range *)
  (-1)^r * Binomial[n-r, r] * 2^(n-2*r)
];

Print["Step 1: Verify T_n coefficient formula\n"];

Do[
  (* Ground truth from Mathematica *)
  tn = ChebyshevT[n, y] // Expand;
  coeffsTrue = CoefficientList[tn, y];

  Print["T_", n, "(y):"];
  Print["  Mathematica: ", tn];

  (* My formula *)
  coeffsMine = Table[0, {Length[coeffsTrue]}];
  Do[
    power = n - 2*j;
    If[power >= 0 && power < Length[coeffsTrue],
      coeffsMine[[power + 1]] = tnCoeffMH[n, j];
    ];
  , {j, 0, Floor[n/2]}];

  Print["  My coeffs: ", coeffsMine];
  Print["  True coeffs: ", coeffsTrue];
  Print["  Match: ", coeffsMine == coeffsTrue];
  Print[];
, {n, 0, 4}];

Print["Step 2: Verify U_n coefficient formula\n"];

Do[
  (* Ground truth from Mathematica *)
  un = ChebyshevU[n, y] // Expand;
  coeffsTrue = CoefficientList[un, y];

  Print["U_", n, "(y):"];
  Print["  Mathematica: ", un];

  (* My formula *)
  coeffsMine = Table[0, {Length[coeffsTrue]}];
  Do[
    power = n - 2*r;
    If[power >= 0 && power < Length[coeffsMine],
      coeffsMine[[power + 1]] = unCoeffMW[n, r];
    ];
  , {r, 0, Floor[n/2]}];

  Print["  My coeffs: ", coeffsMine];
  Print["  True coeffs: ", coeffsTrue];
  Print["  Match: ", coeffsMine == coeffsTrue];
  Print[];
, {n, 0, 4}];

Print["Step 3: Check special cases\n"];

Print["T_0(y) = ", ChebyshevT[0, y], " (should be 1)"];
Print["My formula for T_0: ", tnCoeffMH[0, 0]];
Print[];

Print["U_{-1}(y) = ", ChebyshevU[-1, y], " (should be 0)"];
Print["My formula for U_{-1}: ", unCoeffMW[-1, 0]];
Print[];

Print["T_1(y) = ", ChebyshevT[1, y], " (should be y)"];
Print["My formula: const=", tnCoeffMH[1, 0], ", linear=", "undefined (j > Floor[1/2] for linear term)"];
Print["ISSUE: T_1 has only linear term, but formula gives power n-2j = 1-0 = 1 for j=0"];
Print[];

Print["=== DIAGNOSIS ==="];
Print["The M&H formula might be for n >= 1 with special handling."];
Print["Let me check the exact statement in Mason & Handscomb...\n"];

(* Alternative: directly extract from Mathematica *)
Print["Step 4: Alternative approach - extract coefficients directly\n"];

extractTnCoeff[n_, power_] := Coefficient[ChebyshevT[n, y] // Expand, y, power];
extractUnCoeff[n_, power_] := Coefficient[ChebyshevU[n, y] // Expand, y, power];

Print["Using direct extraction:\n"];

Do[
  Print["T_", n, "(y):"];
  Do[
    c = extractTnCoeff[n, p];
    If[c != 0,
      Print["  [y^", p, "]: ", c];
    ];
  , {p, 0, n}];
, {n, 0, 4}];

Print["\n=== SOLUTION ==="];
Print["For algebraic proof, I should:"];
Print["1. Use direct Mathematica extraction as 'known' coefficients"];
Print["2. OR verify M&H formula more carefully (check boundary cases)"];
Print["3. Focus on proving convolution identity using extracted coefficients"];
