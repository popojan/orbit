#!/usr/bin/env wolframscript
(* Verify k=3 hand calculation step by step *)

Print["=== VERIFICATION OF k=3 HAND CALCULATION ===\n"];

Print["Part 1: Verify Chebyshev formulas\n"];

(* T_2(y) from de Moivre *)
t2DeMoivre = Sum[Binomial[2, 2*j] * (y^2 - 1)^j * y^(2-2*j), {j, 0, 1}] // Expand;
t2Math = ChebyshevT[2, y] // Expand;

Print["T_2(y) from de Moivre: ", t2DeMoivre];
Print["T_2(y) from Mathematica: ", t2Math];
Print["Match: ", t2DeMoivre === t2Math, "\n"];

(* U_1(y) from de Moivre *)
u1DeMoivre = Sum[Binomial[2, 2*k+1] * (y^2 - 1)^k * y^(1-2*k), {k, 0, 0}] // Expand;
u1Math = ChebyshevU[1, y] // Expand;

Print["U_1(y) from de Moivre: ", u1DeMoivre];
Print["U_1(y) from Mathematica: ", u1Math];
Print["Match: ", u1DeMoivre === u1Math, "\n"];

(* U_0(y) *)
u0DeMoivre = 1;
u0Math = ChebyshevU[0, y];

Print["U_0(y) from de Moivre: ", u0DeMoivre];
Print["U_0(y) from Mathematica: ", u0Math];
Print["Match: ", u0DeMoivre === u0Math, "\n"];

(* Delta U *)
deltaU = u1DeMoivre - u0DeMoivre // Expand;
Print["DeltaU_1(y) = U_1(y) - U_0(y) = ", deltaU, "\n"];

Print["Part 2: Shift to x+1\n"];

(* T_2(x+1) manual *)
t2Shifted = t2DeMoivre /. y -> (x+1) // Expand;
Print["T_2(x+1) = ", t2Shifted];
Print["Manual: 2(x+1)^2 - 1 = 2(x^2+2x+1) - 1 = 2x^2 + 4x + 1"];
manualT2 = 2*x^2 + 4*x + 1;
Print["Match: ", t2Shifted === manualT2, "\n"];

(* DeltaU_1(x+1) manual *)
deltaUShifted = deltaU /. y -> (x+1) // Expand;
Print["DeltaU_1(x+1) = ", deltaUShifted];
Print["Manual: 2(x+1) - 1 = 2x + 1"];
manualDeltaU = 2*x + 1;
Print["Match: ", deltaUShifted === manualDeltaU, "\n"];

Print["Part 3: Compute product\n"];

product = Expand[t2Shifted * deltaUShifted];
Print["Product = T_2(x+1) * DeltaU_1(x+1) = ", product, "\n"];

Print["Manual calculation:"];
Print["  (2x^2 + 4x + 1) * (2x + 1)"];
Print["  = 2x^2*(2x+1) + 4x*(2x+1) + 1*(2x+1)"];
Print["  = 4x^3 + 2x^2 + 8x^2 + 4x + 2x + 1"];
Print["  = 4x^3 + 10x^2 + 6x + 1"];

manualProduct = 4*x^3 + 10*x^2 + 6*x + 1;
Print["Match: ", product === manualProduct, "\n"];

Print["Part 4: Compare with factorial form\n"];

k = 3;
factorialForm = 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}] // Expand;

Print["Factorial form for k=3:"];
Print["  1 + x*(4!/(2!*2!)) + 2*x^2*(5!/(1!*4!)) + 4*x^3*(6!/(0!*6!))"];
Print["  = 1 + x*24/4 + 2*x^2*120/24 + 4*x^3*720/720"];
Print["  = 1 + 6x + 10x^2 + 4x^3"];
Print[];

Print["Factorial form: ", factorialForm];
Print["Product form: ", product];
Print["MATCH: ", factorialForm === product, "\n"];

Print["Part 5: Coefficient-by-coefficient verification\n"];

prodCoeffs = CoefficientList[product, x];
factCoeffs = CoefficientList[factorialForm, x];

Print["Coefficient comparison:"];
Do[
  Print["  [x^", i, "]: product = ", prodCoeffs[[i+1]], ", factorial = ", factCoeffs[[i+1]],
        ", match = ", prodCoeffs[[i+1]] == factCoeffs[[i+1]]];
, {i, 0, k}];

Print["\n=== CONCLUSION ===\n"];

If[product === factorialForm,
  Print["SUCCESS! k=3 hand calculation is CORRECT."];
  Print["All steps verified:"];
  Print["  1. de Moivre formulas for T_2, U_1, U_0 "];
  Print["  2. Shift to (x+1) via substitution "];
  Print["  3. Polynomial multiplication "];
  Print["  4. Exact match with factorial form "];
  Print[];
  Print["This proves the identity for k=3 using ONLY elementary algebra!"];
,
  Print["ERROR: Mismatch found!"];
];
